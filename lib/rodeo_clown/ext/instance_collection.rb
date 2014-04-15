class AWS::ELB::InstanceCollection
  def rotate(options = {})

    new_instances = start_new_instances
    stop_current_instances(new_instances)

    old_instances = []
    each { |instance| old_instances << instance }

    deregister old_instances
    register   new_instances
  end

  private

  def wait_for_status(status, collection = self, interval = 5)
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

  def start_new_instances
    new_instances = map { |ec2| dup_instance(ec2) }
    wait_for_status(:running, new_instances)

    new_instances
  end

  def stop_current_instances(interval = 5)
    each &:stop
    wait_for_status(:stopped)
  end

  def dup_instance(instance, count = 1)
    ec2           = AWS::EC2.new#.regions[instance.availability_zone]
    key_pair_name = 'my-key-pair',
    key_pair      = ec2.key_pairs[key_pair_name]

    hsh = {
      security_groups:    instance.security_groups.map(&:name),
      image_id:           instance.image_id,
      instance_type:      instance.instance_type,
      count:              count,
      availability_zone:  instance.availability_zone,
    }

    ec2.instances.create(hsh)
  end
end
