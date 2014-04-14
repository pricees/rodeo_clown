module RodeoClown
  class ELB < Struct.new(:aws_elb)

    def self.by_name(name)
      new load_balancers.detect { |elb| elb.name == name }
    end

    def self.load_balancers
      AWS::ELB.new.load_balancers
    end

    # 
    # Return instances, deregister bad ones
    #
    def instances(options = {}, deregister = true)

      status = options.fetch :status, :running
      aws_elb.instances.select do |ec2|
        begin
          ec2.status == status
        rescue AWS::Core::Resource::NotFound => bang
          puts "Couldn't find #{ec2.id}, deregistering ec2 instance." \
          " Please make a note of it."
          aws_elb.instances.deregister ec2
        end
      end
    end

    def print_status(ec2)
      puts "#{ec2.id}\t#{ec2.status}"
    end


    def rotate_instances(instances)
      new_instances = instances.map { |ec2| dup_instance(ec2) }

      until new_instances.all? { |ec2| ec2.status == :running }
        puts "Waiting for ALL instances to be running..."
        new_instances.each { |ec2| print_status(ec2) }
        sleep 5
      end
      instances.each { |ec2| aws_elb.instances.register ec2 }

      instances.each &:stop

      until instances.all? { |ec2| ec2.status == :stopped}
        puts "\nWaiting for ALL instances to be stopped..."
        instances.each { |ec2| print_status(ec2) }
        sleep 5
      end
      instances.each { |ec2| aws_elb.instances.deregister ec2 }
    end


    private

    def dup_instance(instance, count = 1)
      ec2           = AWS::EC2.new#.regions[instance.availability_zone]
      key_pair_name = 'my-key-pair',
      key_pair      = ec2.key_pairs[key_pair_name]

      hsh = {
        security_groups:    instance.security_groups.map(&:name),
        image_id:           instance.image_id,
        instance_type:      instance.instance_type,
        count:              count,
        #key_pair:           key_pair,
        availability_zone:  instance.availability_zone,
      }

      ec2.instances.create(hsh)
    end
  end
end
