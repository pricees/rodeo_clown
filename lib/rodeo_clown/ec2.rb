require "forwardable"
module RodeoClown
  class EC2  < Struct.new(:ec2)

     STATUS = %w[pending running shutting-down terminated stopping stopped]

=begin
    instances = ec2.instances.create(
      :image_id => "ami-8c1fece5",
      :count => 10)

      sleep 1 while instances.any? {|i| i.status == :pending }
    #  Specifying block device mappings

      ec2.instances.create({
        :image_id => "ami-8c1fece5",
        :block_device_mappings => [{
        :device_name => "/dev/sda2",
        :ebs => {
        :volume_size => 15, # 15 GiB
        :delete_on_termination => true
      }
      }]
    })
=end

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
  end
end
