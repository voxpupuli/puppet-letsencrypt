require 'pathname'

Facter.add(:letsencrypt_live) do
  setcode do
    livedir = Pathname.new('/etc/letsencrypt/live')

    if !livedir.directory?
      []
    else
      livedir.children.select(&:directory?).map(&:basename).map(&:to_s)
    end
  end
end
