require 'puppetlabs_spec_helper/rake_tasks'
require 'puppet-lint/tasks/puppet-lint'
require 'puppet-syntax/tasks/puppet-syntax'
require 'rubocop/rake_task'

RuboCop::RakeTask.new

# These two gems aren't always present, for instance
# on Travis with --without development
begin
  require 'puppet_blacksmith/rake_tasks'
  require 'puppet-strings/rake_tasks'
rescue LoadError
end

PuppetLint.configuration.send('disable_80chars')
PuppetLint.configuration.log_format = '%{path}:%{linenumber}:%{check}:%{KIND}:%{message}'

# Forsake support for Puppet 2.6.2 for the benefit of cleaner code.
# http://puppet-lint.com/checks/class_parameter_defaults/
PuppetLint.configuration.send('disable_class_parameter_defaults')
# http://puppet-lint.com/checks/class_inherits_from_params_class/
PuppetLint.configuration.send('disable_class_inherits_from_params_class')

exclude_paths = [
  'pkg/**/*',
  'vendor/**/*',
  'spec/**/*',
]
PuppetLint.configuration.ignore_paths = exclude_paths
PuppetSyntax.exclude_paths = exclude_paths

desc 'Run metadata-json-lint'
task :metadata do
  out = `bundle exec metadata-json-lint metadata.json`
  $CHILD_STATUS != 0 ? (fail out) : (puts 'Metadata OK!')
end

desc 'Run acceptance tests'
RSpec::Core::RakeTask.new(:acceptance) do |t|
  t.pattern = 'spec/acceptance'
end

desc 'Run syntax, lint, and spec tests.'
task :test => [
  :syntax,
  :lint,
  :metadata,
  :spec,
]

namespace :strings do
  doc_dir = File.dirname(__FILE__) + '/doc'
  git_uri = `git config --get remote.origin.url`.strip
  vendor_mods = File.dirname(__FILE__) + '/.modules'

  desc 'Checkout the gh-pages branch for doc generation.'
  task :checkout do
    unless Dir.exist?(doc_dir)
      Dir.mkdir(doc_dir)
      Dir.chdir(doc_dir) do
        system 'git init'
        system "git remote add origin #{git_uri}"
        system 'git pull'
        system 'git checkout gh-pages'
      end
    end
  end

  desc 'Generate documentation with the puppet strings command.'
  task :generate do
    Dir.mkdir(vendor_mods) unless Dir.exist?(vendor_mods)
    system "bundle exec puppet module install puppetlabs/strings --modulepath #{vendor_mods}"
    system "bundle exec puppet strings --modulepath #{vendor_mods}"
  end

  desc 'Push new docs to GitHub.'
  task :push do
    Dir.chdir(doc_dir) do
      system 'git add .'
      system "git commit -m 'Updating docs for latest build.'"
      system 'git push origin gh-pages'
    end
  end

  desc 'Run checkout, generate, and push tasks.'
  task :update => [
    :checkout,
    :generate,
    :push,
  ]
end
