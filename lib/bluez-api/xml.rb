# frozen_string_literal: true

require 'builder'

require_relative 'xml/config'
require_relative 'xml/generator'
require_relative 'xml/interface'
require_relative 'xml/method'
require_relative 'xml/node'
require_relative 'xml/property'

module BluezApi
  module Xml
    # Conversion from types in the BlueZ docs to DBus types
    # https://dbus.freedesktop.org/doc/dbus-specification.html#basic-types
    BLUEZ_TO_DBUS = {
      'byte'          => 'y',
      'bool'          => 'b',
      'boolean'       => 'b',
      'fd'            => 'h',
      'object'        => 'o',
      'string'        => 's',
      'int16'         => 'n',
      'uint16'        => 'q',
      'int32'         => 'i',
      'uint32'        => 'u',
      'dict'          => 'asv',
      'array{byte}'   => 'ay',
      'array{dict}'   => 'aasv',
      'array{string}' => 'as',
    }.freeze
  end
end
