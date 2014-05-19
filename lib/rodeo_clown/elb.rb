require "forwardable"
module RodeoClown
  class ELB < Struct.new(:elb)

    def timeout
      @timeout ||= (ENV["TIMEOUT"] || 60).to_i
    end

    extend Forwardable
      def_delegators :elb, :availability_zones, :instances

    def self.by_name(name)
      new load_balancers[name]
    end

    def self.load_balancers
      AWS::ELB.new.load_balancers
    end

    def register_and_wait(new_instances)
      new_instances.each do |i|
        begin
          puts "...registering: #{i.id}"
          instances.register(i.id)
        rescue AWS::ELB::Errors::InvalidInstance
          puts "Instance #{i.id} could not be registered to load balancer"
        end
      end

      wait_for_state(instances, "InService")
    end

    def deregister(ary_instances)
      ary_instances.each do |i|
        begin
          puts "...deregistering: #{i.id}"
          instances.deregister(i.id)
        rescue AWS::ELB::Errors::InvalidInstance
          puts "Instance #{i.id} currently not registered to load balancer"
        end
      end
    end

    #
    # Rotate servers given 
    #
    def rotate(hsh)
      current_ec2, new_ec2 = hsh.first

      cur_instances = EC2.by_tags("Name" => current_ec2.to_s)
      new_instances = EC2.by_tags("Name" => new_ec2.to_s)

      register_and_wait new_instances
      deregister        cur_instances
    end

    #
    # Wait for all the instances to become InService
    #
    def wait_for_state(instances, exp_state)

      time = 0
      all_good = false

      loop do
        all_good = instances.all? do |i|
          state = i.elb_health[:state] 
          puts "#{i.id}: #{state}"

          exp_state == state
        end

        break if all_good || time > timeout

        sleep 1
        time += 1
      end

      # If timeout before all inservice, deregister and raise error
      unless all_good
        raise "Instances are out of service"
      end
    end
  end
end

