# frozen_string_literal: true

require 'voxpupuli/acceptance/spec_helper_acceptance'

configure_beaker do |host|
  # docker image does not provide cron in all cases
  case fact_on(host, 'os.family')
  when 'Debian'
    host.install_package('cron')
  when 'RedHat'
    host.install_package('crontabs')
    host.install_package('gnupg2') if fact('os.release.major').to_i >= 10
  end
end
