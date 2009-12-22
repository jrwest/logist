require 'rubygems'
require 'spec/rake/spectask'

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
  t.spec_opts = ['--format nested']
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
end



