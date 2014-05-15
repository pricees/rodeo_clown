module RodeoClown
  module Deploy

    def self.on(options)
      # NOTE: Should we check for array? If so, we should select #first
      res =   before_deploy(options)
      res &&= deploy(options)
      res &&= after_deploy(options)
    end

    private

    def self.before_deploy(options)
      true
    end

    #
    # Options - Hash of options for deploymentj
    #   :env -  Hash of environment variables to be merged
    #   :setup - Should run s
    # 
    #
    def self.deploy(options = {})
      strategy = DeployStrategy.by_name(options[:strategy])
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

    def self.after_deploy(options)
      true
    end
  end
end
