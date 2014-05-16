module RodeoClown
  module InstanceBuilder
    attr_reader :key_pair
    attr_accessor :tags

    def from_options(options)
      options.symbolize_keys! # Symbolize all the things (for AWS-SDK)

      @key_pair_name = options.delete(:key_pair_name)
      @tags          = options.delete(:tags)
      @options       = options
      @availability_zones = options.delete(:availability_zones) || []
    end

    def configs
      @options.merge(:key_pair => key_pair)
    end

    def apply_tags(instances)
      rc_tags = { "rc_created_by" => "Rodeo Clown #{RodeoClown::VERSION}",
        "rc_created_at" => Time.now.to_s }

      [*instances].each {|i| i.tags.set(tags.merge(rc_tags)) }
    end

    def key_pair=(key_pair_name)
      @key_pair = AWS::EC2::KeyPair.new(key_pair_name)
    end

    def build_instances
      ary_of_options =  
        if @availability_zones.any?
          @availability_zones.map do |zone|
            configs.merge(availability_zone: zone)
          end
        else
          [configs]
        end

      ary_of_options.each do |options|
        instances = yield options
        apply_tags(instances)
        instances
      end.flatten
    end
  end
end
