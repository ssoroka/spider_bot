require 'rubygems'
require 'rake'
require 'echoe'

Echoe.new('spider_bot', '0.9.2') do |p|
  p.description = 'A non-threaded spider bot that spiders a site with response time stats. easily extendable'
  p.url = 'http://github.com/ssoroka/spider_bot'
  p.author = 'Steven Soroka'
  p.email = 'ssoroka78@gmail.com'
  p.ignore_pattern = ["tmp/*"]
  p.development_dependencies = ['mechanize', 'ssoroka-ansi']
end

Dir["#{File.dirname(__FILE__)}/tasks/*.rake"].sort.each{|f| load f }