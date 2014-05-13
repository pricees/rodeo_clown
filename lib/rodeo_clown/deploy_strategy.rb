module RodeoClown
  module DeployStrategy

    def self.by_name name
      const_get name.capitalize
    end
  end
end
require_relative "deploy_strategy/mina"
