# frozen_string_literal: true

module BluezApi
  module Xml
    class Property
      def initialize(property)
        @property = property
      end

      # xml: Builder::XmlMarkup
      def generate(xml)
        xml.property(:name => @property.name, :type => type, :access => access)
      end

      private

      def access
        @property.read_only? ? 'read' : 'readwrite'
      end

      def type
        BLUEZ_TO_DBUS.fetch(@property.type)
      end
    end
  end
end
