
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{friendly_format}
  s.version = "0.6.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Lin Jen-Shin (a.k.a. godfat \347\234\237\345\270\270)"]
  s.date = %q{2009-01-05}
  s.description = %q{make user input be valid xhtml and format it with gsub("\n", "<br/>") etc. you can partially allow some tags and don't escape them.}
  s.email = %q{godfat (XD) godfat.org}
  s.extra_rdoc_files = ["CHANGES", "LICENSE", "NOTICE", "README", "TODO", "friendly_format.gemspec"]
  s.files = ["CHANGES", "LICENSE", "NOTICE", "README", "Rakefile", "TODO", "friendly_format.gemspec", "lib/friendly_format.rb", "lib/friendly_format/adapters/hpricot_adapter.rb", "lib/friendly_format/adapters/libxml_adapter.rb", "lib/friendly_format/adapters/nokogiri_adapter.rb", "lib/friendly_format/set_common.rb", "lib/friendly_format/set_strict.rb", "lib/friendly_format/version.rb", "test/sample/complex_article.txt", "test/sample/complex_article_result.txt", "test/test_friendly_format.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/godfat/friendly_format}
  s.rdoc_options = ["--diagram", "--charset=utf-8", "--inline-source", "--line-numbers", "--promiscuous", "--main", "README"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{ludy}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{make user input be valid xhtml and format it with gsub("\n", "<br/>") etc. you can partially allow some tags and don't escape them.}
  s.test_files = ["test/test_friendly_format.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<bones>, [">= 2.2.0"])
      s.add_development_dependency(%q<minitest>, [">= 1.3"])
      s.add_development_dependency(%q<hpricot>, [">= 0.6"])
      s.add_development_dependency(%q<nokogiri>, [">= 1.1"])
      s.add_development_dependency(%q<libxml-ruby>, [">= 0.9"])
    else
      s.add_dependency(%q<bones>, [">= 2.2.0"])
      s.add_dependency(%q<minitest>, [">= 1.3"])
      s.add_dependency(%q<hpricot>, [">= 0.6"])
      s.add_dependency(%q<nokogiri>, [">= 1.1"])
      s.add_dependency(%q<libxml-ruby>, [">= 0.9"])
    end
  else
    s.add_dependency(%q<bones>, [">= 2.2.0"])
    s.add_dependency(%q<minitest>, [">= 1.3"])
    s.add_dependency(%q<hpricot>, [">= 0.6"])
    s.add_dependency(%q<nokogiri>, [">= 1.1"])
    s.add_dependency(%q<libxml-ruby>, [">= 0.9"])
  end
end
