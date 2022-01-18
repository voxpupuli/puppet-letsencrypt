# frozen_string_literal: true

Puppet::Functions.create_function(:'letsencrypt::letsencrypt_lookup') do
  def letsencrypt_lookup(common_name)
    domain = common_name.split('.', 2)[1]
    wildcard = "*.#{domain}"
    certs = closure_scope['facts'].fetch('letsencrypt_directory', nil)
    certs&.fetch(common_name, certs.fetch(wildcard, nil))
  end
end
