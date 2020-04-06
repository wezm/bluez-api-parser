# frozen_string_literal: true

module BluezApi
  class Methods
    attr_reader :methods

    REGEX = /
       \t+               # preceding tabs
       (?:(.+)[ ])?      # return types - Argh! LE Advertising Manager does not specify return type
       ([A-Z]\w+)        # method name
       \(([^\)]*)\)      # parameters
       (?:[ ]\[(.*)\])?  # tags
       (?:[ ]\((.*)\))?  # limitations
    /xi.freeze

    def initialize
      @methods = []
      @current_method = nil
    end

    def parse(line)
      if line =~ REGEX
        @methods << Method.new(
          name: $2,
          out_parameter_strings: $1,
          in_parameter_strings: $3,
          string_tags: $4,
          limitation: $5
        )
        @current_method = @methods.last
      elsif @current_method
        @current_method.comment << line
      end
    end

    def finalize
      @methods.reduce(true) { |success, method| success & method.finalize }
    end

    def self.method?(line)
      line.match?(REGEX)
    end
  end
end
