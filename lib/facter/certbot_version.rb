# frozen_string_literal: true

Facter.add(:certbot_version) do
  confine { Facter::Core::Execution.which('certbot') }

  setcode do
    output = Facter::Core::Execution.execute('certbot --version 2>/dev/null')
    output[%r{^certbot (.*)$}, 1] if output
  end
end
