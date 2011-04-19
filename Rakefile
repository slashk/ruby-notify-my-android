require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "ruby-notify-my-android"
  gem.homepage = "http://github.com/slashk/ruby-notify-my-android"
  gem.license = "MIT"
  gem.summary = %Q{Send notifications to Android devices via the Notify My Android API}
  gem.description = %Q{Send notifications to Android devices via the Notify My Android API. Details about the API are available at https://nma.usk.bz/api.php .}
  gem.email = "ken.pepple@rabbityard.com"
  gem.authors = ["Ken Pepple"]
  # gem.executables = [ 'notify-my-android' ] 
  gem.add_runtime_dependency "xml-simple", ">= 1.0.15"
  gem.add_development_dependency 'webmock'
end
Jeweler::RubygemsDotOrgTasks.new

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

require 'rcov/rcovtask'
Rcov::RcovTask.new do |test|
  test.libs << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "ruby-notify-my-android #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
