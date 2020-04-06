# frozen_string_literal: true

module BluezApi
  module Xml
    class Method
      def initialize(method)
        @method = method
      end

      # xml: Builder::XmlMarkup
      def generate(xml)
        if @method.has_parameters?
          xml.method(:name => @method.name) do
            @method.in_parameters.each do |param|
              generate_parameter(xml, param, 'in')
            end

            @method.out_parameters.each do |param|
              generate_parameter(xml, param, 'out')
            end
          end
        else
          xml.method(:name => @method.name)
        end
      end

      private

      def generate_parameter(xml, param, direction)
        dbus_type = BLUEZ_TO_DBUS.fetch(param.type)
        xml.arg(:name => param.name, :type => dbus_type, :direction => direction)
      end
    end
  end
end
