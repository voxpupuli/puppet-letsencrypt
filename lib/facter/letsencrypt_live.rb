require "pathname"

Facter.add(:letsencrypt_live) do
    setcode do
        Pathname.new("/etc/letsencrypt/live").children.select(&:directory?).collect(&:basename)
    end
end
