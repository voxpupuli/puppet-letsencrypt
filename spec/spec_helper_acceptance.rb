require 'voxpupuli/acceptance/spec_helper_acceptance'

configure_beaker do |host|
  # docker image does not provide cron in all cases
  case fact_on(host, 'os.family')
  when 'Debian'
    host.install_package('cron')
  when 'RedHat'
    host.install_package('crontabs')
  end
  install_module_from_forge('puppet-systemd', '>= 2.6.0')
end
