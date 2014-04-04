require_relative "rodeo_clown/version"
require "aws-sdk"

module RodeoClown

  # 
  # Set aws credentials as environment variables
  # Set aws credentials in the ~/.rodeo_clown.yml
  #
  # Just set your aws credentials
  def self.credentials
    @credentials ||= 
      if File.exists?(file = File.expand_path("~") + "/.rodeo_clown.yml")
        YAML.load_file(file)
      elsif ENV.key?("AWS_ACCESS_KEY") && ENV.key?("AWS_SECRET_ACCESS_KEY") 
        { access_key_id: ENV["AWS_ACCESS_KEY"],
          secret_access_key_id: ENV["AWS_SECRET_ACCESS_KEY"], }
      else
        raise "Please supply aws_access_key and Aws_secret_access_key"
      end
  end
end

AWS.config RodeoClown.credentials # Street cred

require_relative "rodeo_clown/elb"
