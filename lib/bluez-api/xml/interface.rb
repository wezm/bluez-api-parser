# frozen_string_literal: true

module BluezApi
  module Xml
    class Interface
      def initialize(config)
        @config = config
        @xml = Builder::XmlMarkup.new(:indent => 2)
        @xml.instruct!
        @xml.declare! :DOCTYPE, :node, :PUBLIC,
                      '-//freedesktop//DTD D-BUS Object Introspection 1.0//EN',
                      'http://www.freedesktop.org/standards/dbus/1.0/introspect.dtd'
      end

      def generate(interface)
        # rubocop:disable Style/BlockDelimiters
        @xml.node {
          @xml.interface(:name => interface.name) { |_|
            interface.methods.each do |method|
              generate_method(method)
            end

            interface.properties.each do |property|
              generate_property(property)
            end
          }
        }
        # rubocop:enable Style/BlockDelimiters
      end

      private

      def generate_method(method)
        return if method.deprecated? && !@config.include_deprecated?
        return if method.optional? && !@config.include_optional?
        return if method.experimental? && !@config.include_experimental?

        Xml::Method.new(method).generate(@xml)
      end

      def generate_property(property)
        return if property.optional? && !@config.include_optional?
        return if property.experimental? && !@config.include_experimental?

        Xml::Property.new(property).generate(@xml)
      end
    end
  end
end
