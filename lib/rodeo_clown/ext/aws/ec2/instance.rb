class AWS::EC2::Instance
  include IsPortOpen

  def port_open?(port)
    super(dns_name, port)
  end

  def ssh_open?
    port_open? 22
  end

  def http_open?
    port_open? 80
  end

  def https_open?
    port_open? 443
  end
end

