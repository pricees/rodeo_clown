#
# I wanted to be special and use the Rakefile from Mina to deploy, alas shell
# scripts just work.
#
module RodeoClown
  module DeployStrategy
    class Mina

      # :options - Hash of options for deploymentj
      #   :env -  Hash of environment variables to be merged
      #   :setup - Should run s
      #
      # NOTE: This "first_argument" manipulation is a hack, wranglers!
      def self.do(options)
        if options.key?(:env)
          options[:env].each { |k, v| ENV[k.to_s] = v }
        end

        deploy_from_shell(options[:setup])

        puts "Deployment finished.\t\t\t #{options.inspect}"

        true
      end

      def self.deploy_from_shell(setup, deploy = true)
        vars = %w[DOMAIN BRANCH APP].map { |v| "#{v}=#{ENV[v] || 'master'}" }.join(" ")
        cmd  = ""
        cmd << "#{vars} mina setup -v;" if setup
        cmd << "#{vars} mina deploy -v;" if deploy

        puts "RUNNING '#{cmd}'"
        puts "This may take some time.."
        `#{cmd}`
      end
    end
  end
end
