require "forwardable"
module RodeoClown
  class EC2  < Struct.new(:ec2)
    include InstanceBuilder

     STATUS = %w[pending running shutting-down terminated stopping stopped]

    def self.instances
      ec2.instances
    end

    def self.ec2
      @ec2 ||= AWS::EC2.new
    end

    def self.create_instance(options)
      new_instance = instances.create(options)
      instances.wait_for_status(:running, 2, [*new_instance])
      new_instance
    end

    def create_instance(options)
      self.class.create_instance(options)
    end

    def self.by_name(name)
      new instances[name]
    end

    # Filter by had of tag values.
    # Keys and values as strings
    # 
    # Examples
    #   RodeoClown::EC2.by_tags("app" => "rodeo", "version" = "2.1")
    #   # => [ instance-1, instanc-2 ]
    #
    # Returns an array of instances
    def self.by_tags(options = {})
      return instances if options.nil? || options.empty?

      instances.tagged_values(options.values).select do |instance|
        tags = instance.tags.to_h
        (options.to_a - tags.to_a).empty?
      end
    end

    def reboot
      ec2.reboot
    end

    def pending?
      ec2.status == :pending
    end

    def running?
      ec2.status == :running
    end

    def stopped?
      ec2.status == :stopped
    end

    def terminated?
      ec2.status == :terminated
    end

    def dns_name
      ec2.dns_name
    end
  end
end
