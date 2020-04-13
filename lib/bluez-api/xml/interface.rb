# frozen_string_literal: true

module BluezApi
  module Xml
    class Interface
      def initialize(config, xml)
        @config = config
        @xml = xml
      end

      def generate(interface)
        # rubocop:disable Style/BlockDelimiters
        @xml.interface(:name => interface.name) { |_| # Is this needed?
          interface.methods.each do |method|
            generate_method(method)
          end

          interface.properties.each do |property|
            generate_property(property)
          end
        }
        # rubocop:enable Style/BlockDelimiters
      end

      private

      def generate_method(method)
        return if method.deprecated? && !@config.include_deprecated?
        return if method.optional? && !@config.include_optional?
        return if method.experimental? && !@config.include_experimental?

        begin
          Xml::Method.new(method).generate(@xml)
        rescue KeyError => e
          warn "Unable to generate method (#{e.class.name}, #{e.message}): #{method.inspect}"
        end
      end

      def generate_property(property)
        return if property.optional? && !@config.include_optional?
        return if property.experimental? && !@config.include_experimental?

        Xml::Property.new(property).generate(@xml)
      end
    end
  end
end
