
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{friendly_format}
  s.version = "0.5.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Lin Jen-Shin (a.k.a. godfat \347\234\237\345\270\270)"]
  s.date = %q{2008-11-05}
  s.description = %q{}
  s.email = %q{godfat (XD) godfat.org}
  s.extra_rdoc_files = ["CHANGES", "LICENSE", "NOTICE", "README", "TODO", "friendly_format.gemspec"]
  s.files = ["CHANGES", "LICENSE", "NOTICE", "README", "Rakefile", "TODO", "friendly_format.gemspec", "lib/friendly_format.rb", "lib/friendly_format/version.rb", "tasks/ann.rake", "tasks/bones.rake", "tasks/gem.rake", "tasks/git.rake", "tasks/manifest.rake", "tasks/notes.rake", "tasks/post_load.rake", "tasks/rdoc.rake", "tasks/rubyforge.rake", "tasks/setup.rb", "tasks/spec.rake", "tasks/svn.rake", "tasks/test.rake", "test/sample/complex_article.txt", "test/sample/complex_article_result.txt", "test/test_friendly_format.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/godfat/friendly_format}
  s.rdoc_options = ["--diagram", "--charset=utf-8", "--inline-source", "--line-numbers", "--promiscuous", "--main", "README"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{ludy}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{}
  s.test_files = ["test/test_friendly_format.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<hpricot>, [">= 0.6.0"])
      s.add_development_dependency(%q<bones>, [">= 2.1.0"])
      s.add_development_dependency(%q<minitest>, [">= 1.3.0"])
    else
      s.add_dependency(%q<hpricot>, [">= 0.6.0"])
      s.add_dependency(%q<bones>, [">= 2.1.0"])
      s.add_dependency(%q<minitest>, [">= 1.3.0"])
    end
  else
    s.add_dependency(%q<hpricot>, [">= 0.6.0"])
    s.add_dependency(%q<bones>, [">= 2.1.0"])
    s.add_dependency(%q<minitest>, [">= 1.3.0"])
  end
end
