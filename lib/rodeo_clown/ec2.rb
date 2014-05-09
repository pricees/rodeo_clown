require "forwardable"
module RodeoClown
  class EC2  < Struct.new(:ec2)
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
      created_instances = instances.create(options)
      sleep 1 while instances.any? {|i| i.status == :pending }
      created_instances
    end

    def self.by_name(name)
      new instances[name]
    end

    #
    # options: keys: [ foo... , scope: :all], [:values scope: any]
    #
    def self.filter_instances(options = {})
      filtered = filter_by_tag_options(instances, options[:keys], :tagged)

      filter_by_tag_options(filtered, options[:values], :tagged_values)
    end

    def self.filter_by_tag_options(instances, options, filter = :tagged_values)
      return instances if options.nil? || options.empty?

      all = options.delete(:scope) == :all
      vals = options.delete(:values)

      if all
        vals.inject(instances) { |i, value| i.send(filter, value) }
      else
        instances.send filter, *vals
      end
    end
  end
end
