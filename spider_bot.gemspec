Gem::Specification.new do |s|
  s.name = %q{spider_bot}
  s.version = "0.9.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Steven Soroka"]
  s.date = %q{2008-12-04}
  s.default_executable = %q{spider_bot}
  s.description = %q{A non-threaded spider bot that spiders a site with response time stats. easily extendable}
  s.email = %q{ssoroka78@gmail.com}
  s.executables = ["spider_bot"]
  s.extra_rdoc_files = ["bin/spider_bot", "lib/spider_bot.rb", "README"]
  s.files = ["bin/spider_bot", "lib/spider_bot.rb", "Rakefile", "README", "Manifest", "spider_bot.gemspec"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/ssoroka/spider_bot}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Spider_bot", "--main", "README"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{spider_bot}
  s.rubygems_version = %q{1.2.0}
  s.summary = %q{A non-threaded spider bot that spiders a site with response time stats. easily extendable}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if current_version >= 3 then
      s.add_development_dependency(%q<mechanize>, [">= 0"])
      s.add_development_dependency(%q<ssoroka-ansi>, [">= 0"])
    else
      s.add_dependency(%q<mechanize>, [">= 0"])
      s.add_dependency(%q<ssoroka-ansi>, [">= 0"])
    end
  else
    s.add_dependency(%q<mechanize>, [">= 0"])
    s.add_dependency(%q<ssoroka-ansi>, [">= 0"])
  end
end
