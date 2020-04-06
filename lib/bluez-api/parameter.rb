# frozen_string_literal: true

module BluezApi
  class Parameter
    class InvalidParameter < StandardError; end

    attr_reader :type, :name

    def self.from_string(string)
      arg = string.split(' ')
      if arg.size != 2
        raise InvalidParameter, "Unable to determine parameter from #{string.inspect}"
      end

      new(arg.first, arg.last)
    end

    def initialize(type, name)
      @type = type
      @name = name
    end

    def ==(other)
      type == other.type && name == other.name
    end
  end
end
