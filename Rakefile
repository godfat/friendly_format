# encoding: utf-8

begin
  require 'bones'
rescue LoadError
  abort '### Please install the "bones" gem ###'
end

ensure_in_path 'lib'
proj = 'friendly_format'
require "#{proj}/version"

Bones{
  version FriendlyFormat::VERSION

  # ruby_opts [''] # silence warning, too many in addressable and/or dm-core

  depend_on 'nokogiri', :development => true, :version => '>=1.2'
  depend_on 'hpricot',  :development => true, :version => '>=0.8'

  name    proj
  url     "http://github.com/godfat/#{proj}"
  authors 'Lin Jen-Shin (aka godfat 真常)'
  email   'godfat (XD) godfat.org'

  history_file   'CHANGES'
   readme_file   'README'
   ignore_file   '.gitignore'
  rdoc.include   ['\w+']
}

CLEAN.include Dir['**/*.rbc']

task :default do
  Rake.application.options.show_task_pattern = /./
  Rake.application.display_tasks_and_comments
end
