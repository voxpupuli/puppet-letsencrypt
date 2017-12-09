require 'pathname'

Facter.add(:letsencrypt_live) do
  setcode do
    livedir = Pathname.new('/etc/letsencrypt/live')

    if !livedir.directory?
      []
    else
      livedir.children.select(&:directory?).collect(&:basename).map { |name| name.to_s }
    end
  end
end