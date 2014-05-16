require 'socket'
require 'timeout'


module IsPortOpen
  def port_open?(ip, port = 22)
    begin
      Timeout::timeout(1) do
        begin
          s = TCPSocket.new(ip, port)
          s.close
          return true
        rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH
          return false
        end
      end
    rescue Timeout::Error
    end

    false
  end
end
