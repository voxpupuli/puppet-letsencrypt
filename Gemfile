source 'https://rubygems.org'

group :test do
  gem 'rake'
  gem 'puppet', ENV['PUPPET_VERSION'] || ['>= 3.4', '< 5']
  gem 'puppet-lint', '~> 1.0'
  gem 'rspec-puppet'
  gem 'puppet-syntax'
  gem 'puppetlabs_spec_helper'
  gem 'metadata-json-lint'
  unless ENV['PUPPET_VERSION'] == '~> 3.4.0'
    gem 'puppet-strings'
  end
  gem 'puppet-lint-absolute_classname-check'
  gem 'puppet-lint-alias-check'
  gem 'puppet-lint-empty_string-check'
  gem 'puppet-lint-file_ensure-check'
  gem 'puppet-lint-file_source_rights-check'
  gem 'puppet-lint-fileserver-check'
  gem 'puppet-lint-leading_zero-check'
  gem 'puppet-lint-spaceship_operator_without_tag-check'
  gem 'puppet-lint-trailing_comma-check'
  gem 'puppet-lint-undef_in_function-check'
  gem 'puppet-lint-unquoted_string-check'
  gem 'puppet-lint-variable_contains_upcase'

  if ENV['TRAVIS_RUBY_VERSION'] < '2.2'
    gem 'json_pure', '~> 1.8'
  end

  if ENV['TRAVIS_RUBY_VERSION'] < '2.0'
    gem 'rubocop', '~> 0.39.0'
  else
    gem 'rubocop'
  end
end

group :development do
  gem 'yard'
  gem 'travis'
  gem 'travis-lint'
  gem 'beaker'
  gem 'beaker-rspec'
  gem 'vagrant-wrapper'
  gem 'puppet-blacksmith'
  gem 'guard-rake'
  gem 'pry'
end
