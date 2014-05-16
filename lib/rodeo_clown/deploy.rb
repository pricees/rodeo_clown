module RodeoClown
  module Deploy

    def self.on(options = {})
      deploy(options)
    end

    private

    def self.deploy(options)
      strategy = DeployStrategy.by_name(options[:strategy])
      strategy.do(options)
      strategy
    end
  end
end
