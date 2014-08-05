require "aws-sdk"
module RodeoClown
  module S3

    def self.get_config_files
      configs = RodeoClown.get_configs('production')
      credentials =  {
        access_key_id: configs["access_key_id"],
        secret_access_key: configs["secret_access_key"],
      }

      s3 = AWS::S3.new(credentials)

      s3.buckets["raise.config"].objects.each do |s3_file|
        new_local_file = determine_path_for(s3_file.key)
        File.open(new_local_file, 'w') do |local_file|
          puts "Writing #{new_local_file}"
          local_file.write(s3_file.read)
        end
      end
    end

    def self.determine_path_for(file_name)
      File.join(File.expand_path("."),file_name)
    end
  end

end
