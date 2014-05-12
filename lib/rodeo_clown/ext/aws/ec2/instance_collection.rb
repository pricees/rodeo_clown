class AWS::EC2::InstanceCollection
  def wait_for_status(status, interval = 1, collection = self)
    until collection.all? { |ec2| ec2.status == status } 
      puts "Waiting for ALL instances to be #{status}..."
      collection.each { |ec2| print_status(ec2) }
      sleep interval
    end

    collection
  end

  def print_status(ec2)
    puts "#{ec2.id}\t#{ec2.status}"
  end
end
