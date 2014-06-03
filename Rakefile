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
  gem.name = "higml"
  gem.homepage = "http://github.com/flyingmachine/higml"
  gem.license = "MIT"
  gem.summary = %Q{Higml is a terse format for converting an input hash to an output hash.}
  gem.description = %Q{Higml is a terse format for converting a static input hash to a dynamic output hash.}
  gem.email = "daniel@flyingmachinestudios.com"
  gem.authors = ["Daniel Higginbotham"]
end
Jeweler::RubygemsDotOrgTasks.new

require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.spec_files = FileList['spec/**/*_spec.rb']
end

Spec::Rake::SpecTask.new(:rcov) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :default => :spec
