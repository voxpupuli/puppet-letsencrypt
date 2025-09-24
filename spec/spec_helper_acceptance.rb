# frozen_string_literal: true

require 'voxpupuli/acceptance/spec_helper_acceptance'
require 'spec_helper_local'

configure_beaker do |host|
  # docker image does not provide cron in all cases
  case fact_on(host, 'os.family')
  when 'Debian'
    host.install_package('cron')
  when 'RedHat'
    host.install_package('crontabs')
  end
end
