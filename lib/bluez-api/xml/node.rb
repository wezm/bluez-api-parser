# frozen_string_literal: true

module BluezApi
  module Xml
    class Node
      def initialize
        @xml = Builder::XmlMarkup.new(:indent => 2)
        @xml.instruct!
        @xml.declare! :DOCTYPE, :node, :PUBLIC,
                      '-//freedesktop//DTD D-BUS Object Introspection 1.0//EN',
                      'http://www.freedesktop.org/standards/dbus/1.0/introspect.dtd'
      end

      def generate
        @xml.node do
          yield @xml
        end
      end
    end
  end
end
