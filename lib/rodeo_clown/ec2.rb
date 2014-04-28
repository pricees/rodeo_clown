require "forwardable"
module RodeoClown
  class EC2  < Struct.new(:ec2)
    def self.instances
      ec2.instances
    end

    def self.ec2
      @ec2 ||= AWS::EC2.new
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

    def self.filter_by_tag_options(instances, options, method = :tagged_values)
      return instances if options.nil? || options.empty?

      all = options.delete(:scope) == :all
      vals = options.delete(:values)

      if all
        vals.inject(instances) { |i, value| i.send(method, value) }
      else
        instances.tagged_values *vals
      end
    end
  end
end
