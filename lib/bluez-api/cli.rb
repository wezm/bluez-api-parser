# frozen_string_literal: true

require 'bluez-api'
require 'optparse'
require 'pathname'

module BluezApi
  class CLI
    BANNER = 'Usage: bluezapi2xml [options] some-api.txt'
    Arguments = Struct.new(:output_dir, :config)

    def initialize(args)
      @options = CLI::Parser.parse(args)
      @args = args
    end

    def run
      if @args.empty?
        warn BANNER
        exit 2
      end

      @args.each do |api_file|
        warn "Processing #{api_file}"
        parser = BluezApi::Parser.new
        parser.parse(File.read(api_file))
        unless parser.finalize
          warn "Unable to finalize #{api_file}"
          exit 1
        end

        out_path = @options.output_dir + Pathname(api_file).basename.sub_ext('.xml')
        node = Xml::Node.new.generate do |xml|
          parser.interfaces.map do |interface|
            unless interface.has_methods?
              warn "skipping interface without methods: #{interface.name}"
              next
            end

            Xml::Interface.new(@options.config, xml).generate(interface)
          end
        end

        out_path.write(node)
        warn "Wrote #{out_path}"
      end
    end

    class Parser
      def self.parse(argv)
        args = Arguments.new(Pathname('.'), Xml::Config.new)

        opt_parser = OptionParser.new do |opts|
          opts.banner = BANNER

          opts.on('-o PATH', 'XML output directory (defaults to .)') do |o|
            args.output_dir = Pathname(o)
          end

          opts.on('--no-include-optional', "don't include optional methods and properties") do
            args.config.include_optional = false
          end

          opts.on('--include-experimental', 'include experimental methods and properties') do
            args.config.include_experimental = true
          end

          opts.on('--include-deprecated', 'include deprecated methods and properties') do
            args.config.include_deprecated = true
          end

          opts.on('-h', '--help', 'Prints this help') do
            puts opts
            exit
          end
        end

        opt_parser.parse!(argv)

        args
      end
    end
  end
end
