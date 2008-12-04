require 'mechanize'
require 'ansi'
require 'benchmark'

class SpiderBot
  # override these for handling events
  def on_page(page)
  end

  def on_404(link)
  end
  
  def on_500(link)
  end

  # override these for changing how urls are classified as links
  def off_site?(url)
    url !~ /^\// # urls not starting with a /
  end

  def ignorable?(url)
    url =~ /\/.*\..+/ && # files with extensions
      url !~ /\.html$/ # but not html files
  end

  ## implementation! :)
  attr_accessor :fourohfour, :fivehundred, :response_times, :been_to, :go_to
  def initialize(options = {})
    @agent = WWW::Mechanize.new
    @agent.user_agent = options[:agent] || 'spider bot'
    @been_to = ['/']
    @go_to = []
    @fourohfour = []
    @fivehundred = []
    @response_times = []
    @key = "\n\nKey:\n{#{ANSI.color(:yellow){'queued'}}}/{#{ANSI.color(:green){'hit'}}}/{#{ANSI.color(:red){'404s'}}}/{#{ANSI.color(:red){'500s'}}} {current action}"
    @quiet = options[:quiet]
  end
  
  def start(url = nil)
    @starting_url = url || 'http://0.0.0.0:3000/'
    fetch @starting_url
  end
  
  def fetch(link)
    status "fetching #{link}"
    @been_to << link
    begin
      page = nil
      real = Benchmark.measure {
        page = @agent.get link
      }.real
      @response_times << [link, real]
      (page/'a').each{|el|
        if el['href']
          url = el['href'].gsub(/\#.*/, '')
          @go_to.push url unless @go_to.include?(url) || @been_to.include?(url) || off_site?(url) || ignorable?(url)
        end
      }
      on_page(page) # on_page event
    rescue Net::HTTPNotFound => e
      @fourohfour << link
      status "#{link} not found, 404"
      on_404(link)
    rescue Net::HTTPInternalServerError => e
      @fivehundred << link
      status ANSI.color(:red) {"#{link} dead! 500 error!"}
      on_500(link)
    rescue Interrupt => e
      status "Interrupt caught, shutting down."
      close_up_shop
      exit
    end

    # fetch next link in list.
    next_link = @go_to.shift
    if next_link
      fetch(next_link)
    else
      close_up_shop
    end
  end
  
  def status(s)
    return if @quiet
    to_go = ANSI.color(:yellow) { @go_to.size.to_s }
    done = ANSI.color(:green) { @been_to.size.to_s }
    fourohfour = ANSI.color(:red) { @fourohfour.size.to_s }
    fivehundred = ANSI.color(:red) { @fivehundred.size.to_s }
    STDOUT.print(ANSI.clear_screen + ANSI.up(100) + ANSI.left(100))
    STDOUT.print("spidering #{@starting_url}..\n")
    STDOUT.print("#{to_go}/#{done}/#{fourohfour}/#{fivehundred}: #{s}")
    STDOUT.print("\n\nNext 15 links:\n#{@go_to[0..14].join("\n")}")
    STDOUT.print(@key)
    STDOUT.flush
  end
  
  def close_up_shop
    return if @quiet
    STDOUT.puts "\n\nDone!"
    if @fourohfour.any?
      STDOUT.puts "Here are all your broken links:\n#{@fourohfour.join("\n")}"
    else
      STDOUT.puts "You have no broken links that I could find"
    end
    if @fivehundred.any?
      STDOUT.puts "Here are all your dead 500 links:\n#{@fivehundred.join("\n")}"
    else
      STDOUT.puts "You have no dead (500) pages that I could find"
    end
    STDOUT.puts "\n5 slowest pages: "
    @response_times.sort_by{|link, time|
      -time
    }.first(5).each{|link, time|
      STDOUT.printf "%0.3fs %s\n", time, link
    }
  end
end
