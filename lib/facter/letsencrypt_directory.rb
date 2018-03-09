require 'openssl'
require 'pathname'

Facter.add(:letsencrypt_directory) do
  setcode do
    certs = {}

    # locate the certificate repository
    livedir = [
      '/etc/letsencrypt/live',
      '/etc/certbot/live'
    ].map { |path| Pathname.new path }.find(&:directory?)

    # collect the sans from each certificate
    if livedir
      Pathname.new(livedir).children.select(&:directory?).each do |path|
        pem = File.join(path, 'cert.pem')
        cert = OpenSSL::X509::Certificate.new(File.new(pem).read)
        san = cert.extensions.find { |e| e.oid == 'subjectAltName' }
        names = san.value.split(',').map { |entry| entry.split(':')[1] }
        names.each do |n|
          certs[n] = path.to_s
        end
      end
    end

    certs
  end
end
