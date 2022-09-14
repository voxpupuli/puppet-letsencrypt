# frozen_string_literal: true

def supported_os_gandi(os)
  # Gandi plugin is only supported on debian 11 and ubuntu 20.04 and superiors
  (os['name'] == 'Debian' && os['release']['major'].to_i >= 11) || (os['name'] == 'Ubuntu' && os['release']['major'].to_i >= 20)
end
