# frozen_string_literal: true

module BluezApi
  class Properties
    attr_reader :properties

    REGEX = /
      (?:Properties|^)  # Properties keyword or start of line
      \t{1,2}           # preceding tabs (max 2)
      ([a-z1-6{}_]+)    # type name
      [ ]               # space
      ([A-Z]\w+)        # method name
      (?:[ ]\[(.*)\])?  # tags
      (?:[ ]\((.*)\))?  # limitations
    /x.freeze

    def initialize
      @properties = []
      @current_property = nil
    end

    def parse(line)
      if line =~ REGEX
        @properties << Property.new(
          type: $1,
          name: $2,
          string_tags: $3,
          limitation: $4
        )
        @current_property = @properties.last
      elsif @current_property
        @current_property.comment << line
      end
    end

    def finalize
      @properties.reduce(true) { |success, property| success & property.finalize }
    end
  end
end
