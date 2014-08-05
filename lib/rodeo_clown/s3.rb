require "aws-sdk"
module RodeoClown
  module S3

    def self.get_config_files
      s3 = AWS::S3.new(credentials)

      s3.buckets["raise.config"].objects.each do |s3_file|
        File.open(determine_path_for(s3_file.key), 'w') do |local_file|
          local_file.write(s3_file.read)
        end
      end
    end

    def self.credentials
      @credentials ||=
      if ENV.key?("AWS_KEY") && ENV.key?("AWS_SECRET_KEY") 
        { access_key_id: ENV["AWS_KEY"],
          secret_access_key: ENV["AWS_SECRET_KEY"], }
      else
        raise "Please supply AWS_KEY and AWS_SECRET_KEY"
      end
    end

    def self.determine_path_for(file_name)
      path = file_name == "deploy.rb" ? "/" : "/deploy/"
      "#{File.expand_path("config")}#{path}#{file_name}"
    end
  end

end
