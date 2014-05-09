module RodeoClown
  class Deploy

    def self.on(instance)
      # NOTE: Should we check for array? If so, we should select #first
      res =   before_deploy(instance)
      res &&= deploy(instance)
      res &&= after_deploy(instance)
    end
  end

  private

  def self.before_deploy(instance)
  end

  def self.deploy(instance)
  end

  def self.after_deploy(instance)
  end
end
