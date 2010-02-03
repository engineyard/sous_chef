require 'bundler'
Bundler.require_env
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "sous_chef"
    gem.summary = %Q{Chef's prep-cook}
    gem.description = %Q{Create bash scripts using a simple chef-like syntax}
    gem.email = ["memde@engineyard.com", "bdonovan@engineyard.com"]
    gem.homepage = "http://github.com/engineyard/sous_chef"
    gem.authors = ["Martin Emde", "Brian Donovan"]

    bundle = Bundler::Bundle.load(File.dirname(__FILE__) + '/Gemfile')
    bundle.environment.dependencies.each do |d|
      if d.only && d.only.include?('runtime')
        gem.add_dependency d.name, d.version.to_s
      end
    end
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.spec_files = FileList['spec/**/*_spec.rb']
end

Spec::Rake::SpecTask.new(:rcov) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
  spec.rcov_opts << '--exclude' << 'spec,vendor,Library'
end

task :spec => :check_dependencies

begin
  require 'reek/adapters/rake_task'
  Reek::RakeTask.new do |t|
    t.fail_on_error = true
    t.verbose = false
    t.source_files = 'lib/**/*.rb'
  end
rescue LoadError
  task :reek do
    abort "Reek is not available. In order to run reek, you must: sudo gem install reek"
  end
end

begin
  require 'roodi'
  require 'roodi_task'
  RoodiTask.new do |t|
    t.verbose = false
  end
rescue LoadError
  task :roodi do
    abort "Roodi is not available. In order to run roodi, you must: sudo gem install roodi"
  end
end

task :default => :spec

begin
  require 'yard'
  YARD::Rake::YardocTask.new
rescue LoadError
  task :yardoc do
    abort "YARD is not available. In order to run yardoc, you must: sudo gem install yard"
  end
end
