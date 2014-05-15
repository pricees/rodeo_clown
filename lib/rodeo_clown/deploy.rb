module RodeoClown
  module Deploy

    def self.on(instance)
      # NOTE: Should we check for array? If so, we should select #first
      res =   before_deploy(instance)
      res &&= deploy(instance)
      res &&= after_deploy(instance)
    end
  end

  private

  def self.before_deploy(instance)
    true
  end

  def self.deploy(instance, strategy, setup = true)
    ENV["APP"] = "test.www.raise.com"
    ENV["DOMAIN"] = instance.dns_name
    ENV["BRANCH"] = "master"
    
    if setup
      ARGV << "setup"
      DeployStrategy.by_name(strategy).do
      ARGV.delete "setup"
    end
    ARGV << "deploy"
    DeployStrategy.by_name(strategy).do
  end

  def self.after_deploy(instance)
    true
  end
end
