source 'https://rubygems.org'

group :test do
  gem 'rake'
  gem 'puppet', ENV['PUPPET_VERSION'] || ['>= 3.4', '< 5']
  gem 'puppet-lint', '~> 2.0', '>= 2.0.2'
  gem 'rspec-puppet'
  gem 'puppet-syntax'
  gem 'puppetlabs_spec_helper'
  gem 'metadata-json-lint'
  unless ENV['PUPPET_VERSION'] == '~> 3.4.0'
    gem 'puppet-strings'
  end
  gem 'puppet-lint-alias-check', '~> 0.1.1'
  gem 'puppet-lint-file_source_rights-check', '~> 0.1.1'
  gem 'puppet-lint-spaceship_operator_without_tag-check', '~> 0.1.1'
  gem 'puppet-lint-variable_contains_upcase', '~> 1.0', '>= 1.0.2'
  gem 'puppet-lint-param-docs', '~> 1.4', '>= 1.4.1'
  gem 'puppet-lint-strict_indent-check', '~> 2.0', '>= 2.0.2'
  gem 'puppet-lint-absolute_classname-check', '~> 0.2.4'
  gem 'puppet-lint-leading_zero-check', '~> 0.1.1'
  gem 'puppet-lint-unquoted_string-check', '~> 0.3.0'
  gem 'puppet-lint-trailing_comma-check', '~> 0.3.2'
  gem 'puppet-lint-empty_string-check', '~> 0.2.2'
  gem 'puppet-lint-file_ensure-check', '~> 0.3.1'
  gem 'puppet-lint-undef_in_function-check', '~> 0.2.1'
  gem 'rubocop'
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
