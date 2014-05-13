require_relative "rodeo_clown/version"
require "aws-sdk"

module RodeoClown

  def self.configs
    @configs ||= 
      if File.exists?(file = File.expand_path(".") + "/.rodeo_clown.yml")
        YAML.load_file(file)
      elsif File.exists?(file = File.expand_path("~") + "/.rodeo_clown.yml")
        YAML.load_file(file)
      else
        {}
      end
  end
  # 
  # Set aws credentials as environment variables
  # Set aws credentials in the ~/.rodeo_clown.yml
  #
  # Just set your aws credentials
  def self.credentials
    @credentials ||= 
      if ENV.key?("AWS_ACCESS_KEY") && ENV.key?("AWS_SECRET_ACCESS_KEY") 
        { access_key_id: ENV["AWS_ACCESS_KEY"],
          secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"], }
      elsif configs.key?("access_key_id") && configs.key?("secret_access_key")
        { access_key_id: configs["access_key_id"],
           secret_access_key: configs["secret_access_key"],}
      else
        raise "Please supply aws_access_key and Aws_secret_access_key"
      end
  end
end

AWS.config RodeoClown.credentials # Street cred

require_relative "rodeo_clown/deploy"
require_relative "rodeo_clown/deploy_strategy"
require_relative "rodeo_clown/ec2"
require_relative "rodeo_clown/elb"
require_relative "rodeo_clown/ext/aws/ec2/instance_collection"
require_relative "rodeo_clown/ext/aws/elb/instance_collection"
