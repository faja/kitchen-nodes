module Kitchen
  module Transport
    class Winrm < Kitchen::Transport::Base
      # Monkey patch of test-kitchen winrm transport
      # that returns stdout
      class Connection < Kitchen::Transport::Base::Connection
        def node_execute(command, &block)
          session.run_powershell_script(command, &block)
        end
      end
    end
  end

  module Provisioner
    module IpFinder
      # WinRM implementation for returning active non-localhost IPs
      class Winrm
        def initialize(connection)
          @connection = connection
        end

        def find_ips
          out = @connection.node_execute(
            'Get-NetIPConfiguration | % { $_.ipv4address.IPAddress }')
          data = []
          out[:data].each do |out_data|
            stdout = out_data[:stdout]
            data << stdout.chomp unless stdout.nil?
          end
          data
        end
      end
    end
  end
end
