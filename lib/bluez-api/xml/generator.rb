# frozen_string_literal: true

module BluezApi
  module Xml
    class Generator
      def initialize(config)
        @config = config
      end

      def generate(parser)
        parser.interfaces.map do |interface|
          unless interface.has_methods?
            warn "skipping interface without methods: #{interface.name}"
            next
          end

          build_interface_xml(interface)
        end
      end

      private

      def build_interface_xml(interface)
        Xml::Interface.new(@config).generate(interface)
      end
    end
  end
end
