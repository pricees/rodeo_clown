module RodeoClown
  class ELB < Struct.new(:aws_elb)

    def self.by_name(name)
      new load_balancers[name]
    end

    def self.load_balancers
      AWS::ELB.new.load_balancers
    end

    def instances
      aws_elb.instances
    end
  end
end
