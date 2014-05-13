require 'mina'
require 'rake'

#
# This file is stolen from "bin/mina" and the Mena directory.
# Its more or less, a hack, for our immediate purposes
#
module RodeoClown
  module DeployStrategy
    class Mina

      #
      # Command pattern
      #
      def self.do
        $:.unshift File.expand_path('../../lib', __FILE__)

=begin
        # Intercept: if invoked as 'mina --help', don't let it pass through Rake, or else
        # we'll see the Rake help screen. Redirect it to 'mina help'.
        if ARGV.delete('--help') || ARGV.delete('-h')
          ARGV << 'help'
        end

        if ARGV.delete('--version') || ARGV.delete('-V')
          puts "Mina, version v#{Mina.version}"
          exit
        end

        if ARGV.delete('--simulate') || ARGV.delete('-S')
          ENV['simulate'] = '1'
        end
=end

        scope = self

        Rake.application.instance_eval do
          standard_exception_handling do
            begin
              # Initialize Rake and make it think it's Mina.
              init 'mina'

              # (The only way @rakefiles has only 1 value is if -f is specified.)
              custom_rakefile = (@rakefiles.size == 1)
              @rakefiles = ['Minafile', 'config/deploy.rb']  unless custom_rakefile

              # Workaround: Rake 0.9+ doesn't record task descriptions unless it's needed.
              # Need it for 'mina help'
              if Rake::TaskManager.respond_to?(:record_task_metadata)
                Rake::TaskManager.record_task_metadata = true
              end

              # Load the Mina Rake DSL.
              require 'mina/rake'

              # Allow running without a Rakefile
              begin
                load_rakefile  if have_rakefile || custom_rakefile
              rescue Exception
                puts "Error loading Rakefile!"
                raise "There may be a problem with config/deploy.rb and/or Rakefile"
              end

              # Run tasks
              top_level

              scope.mina_cleanup! if top_level_tasks.any?

              true

            rescue Mina::Failed => e
              puts ""
              scope.print_error "Command failed."
              scope.print_stderr "#{e.message}"
              exit e.exitstatus
            end
          end
        end
      end
    end
  end
end
