require 'rubygems'
require 'spec/rake/spectask'
require 'find'

GEM_FILES = %w[rakefile] + Dir.glob("{lib}/**/*")
gem_spec = Gem::Specification.new do |spec|
  spec.name = 'logist'
  spec.version = '0.0.0'
  spec.summary = ''
  spec.description = ''
  spec.email = 'jordan.west@westwardwd.com'
  spec.homepage = 'http://www.westwardwd.com'
  spec.authors = ['Jordan West']
  spec.files = GEM_FILES
end

task :default => [:spec]

Spec::Rake::SpecTask.new do |t|
  t.warning = false
  t.rcov = false
  t.spec_opts = ['--format nested', '--color']
end

namespace :gem do
  desc "Generate gemspec file"
  task :spec do
    File.open("#{gem_spec.name}.gemspec", 'w') do |f|
      f.write gem_spec.to_yaml
    end
  end

  desc "build ruby gem"
  task :build => [:spec] do
    sh "gem build #{gem_spec.name}.gemspec"
  end

  desc "install ruby gem"
  task :install => [:build] do
    gem_filename = "#{gem_spec.name}-#{gem_spec.version}.gem"
    sh "sudo gem install #{gem_filename}"
  end

  desc "uninstall ruby gem"
  task :uninstall do
    sh "sudo gem uninstall #{gem_spec.name}"
  end

  desc "uninstalls ruby gem and removes associated files"
  task "housekeep" => [:uninstall] do
    sh "rm -rfd *.gem*"    
  end
end



