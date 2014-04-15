class AWS::ELB::InstanceCollection
  def rotate(options = {})

    new_instances = start_new_instances(options)
    old_instances = stop_current_instances

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

  def start_new_instances(options = {})
    new_instances = map do |instance| 
      create_instance(instance_attributes(instance).merge(options))
    end

    wait_for_status(:running, new_instances)

    new_instances
  end

  def stop_current_instances(interval = 5)
    old_instances = map { |instance| stop_instance(instance) }

    wait_for_status(:stopped)
    old_instances 
  end
  
  def instance_attributes(instance)
    {
      security_groups:    instance.security_groups.map(&:name),
      image_id:           instance.image_id,
      instance_type:      instance.instance_type,
      availability_zone:  instance.availability_zone,
    }
  end

  def create_instance(options)
    ec2.instances.create(options)
  end

  def stop_instance(instance)
    instance.stop
    instance
  end

  def ec2
    @ec2 ||= AWS::EC2.new
  end
end
