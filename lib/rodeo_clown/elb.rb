require "forwardable"
module RodeoClown
  class ELB < Struct.new(:aws_elb)
    extend Forwardable
      def_delegators :aws_elb, :availability_zones, :instances

    def self.by_name(name)
      new load_balancers[name]
    end

    def self.load_balancers
      AWS::ELB.new.load_balancers
    end

    #
    # Rotate servers given 
    #
    def rotate(hsh)
      current_ec2, new_ec2 = hsh.first

      cur_instances = EC2.filter_instances(values: { values: current_ec2.to_s})
      new_instances = EC2.filter_instances(values: { values: new_ec2.to_s})

      new_instances.each do |i|
        begin
          puts "...registering: #{i.id}"
          instances.register(i.id)
        rescue AWS::ELB::Errors::InvalidInstance
          puts "Instance #{i.id} could not be registered to load balancer"
        end
      end

      cur_instances.each do |i|
        begin
          puts "...deregistering: #{i.id}"
          instances.deregister(i.id)
        rescue AWS::ELB::Errors::InvalidInstance
          puts "Instance #{i.id} currently not registered to load balancer"
        end
      end
    end
  end
end

