module RodeoClown
  module Deploy

    def self.on(instance, strategy = 'mina', setup = true)
      # NOTE: Should we check for array? If so, we should select #first
      res =   before_deploy(instance)
      res &&= deploy(instance, strategy, setup)
      res &&= after_deploy(instance)
    end

    private

    def self.before_deploy(instance)
      true
    end

    #
    # Options - Hash of options for deploymentj
    #   :env -  Hash of environment variables to be merged
    #   :setup - Should run s
    # 
    #
    def self.deploy(options = {})
      strategy = DeployStrategy.by_name(strategy)
      if options.key?(:env)
        options[:env].each { |k, v| ENV[k.to_s] = v }
      end

      if options[:setup]
        ARGV << "setup"
        strategy.do 

        ARGV.delete "setup"
      end

      ARGV << "deploy"
      strategy.do
    end

    def self.after_deploy(instance)
      true
    end
  end
end
