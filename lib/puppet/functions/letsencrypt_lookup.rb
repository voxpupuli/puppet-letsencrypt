Puppet::Functions.create_function(:letsencrypt_lookup) do
  def letsencrypt_lookup(cn)
    domain = cn.split('.', 2)[1]
    wildcard = "*.#{domain}"
    certs = closure_scope['facts'].fetch('letsencrypt_directory', nil)
    certs.fetch(cn, certs.fetch(wildcard, nil)) unless certs.nil?
  end
end
