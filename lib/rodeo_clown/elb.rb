module RodeoClown
  class ELB < AWS::ELB

    def self.by_name(name)
      new.load_balancers.detect { |elb| elb.name == name }
    end

    def self.load_balancers
      new.load_balancers
    end

    # 
    # Return instances, deregister bad ones
    #
    def instances(options = {}, deregister = true)

      status = options.fetch :status, :running
      elb.instances.select do |ec2|
        begin
          ec2.status == status
        rescue AWS::Core::Resource::NotFound => bang
          puts "Couldn't find #{ec2.id}, deregistering ec2 instance." \
          " Please make a note of it."
          elb.instances.deregister ec2
        end
      end
    end
  end
end
