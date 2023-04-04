# the docker images for EL9 are quite minimal and dont have a cron daemon. its present in the official installation
if $facts['os']['family'] == 'RedHat' and Integer($facts['os']['release']['major']) == 9 {
  package { 'cronie':
    ensure => 'installed',
  }
}
