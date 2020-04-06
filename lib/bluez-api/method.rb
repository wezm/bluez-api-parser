# frozen_string_literal: true

module BluezApi
  class Method
    Tags = Struct.new(:optional, :deprecated, :experimental)

    attr_reader :out_parameter, :out_parameters, :in_parameters, :tags, :comment
    attr_accessor :name

    def initialize(name:, out_parameter_strings:, in_parameter_strings:, string_tags:, limitation:)
      self.name = name
      self.out_parameter_strings = out_parameter_strings
      @out_parameters = []
      self.in_parameter_strings = in_parameter_strings
      @in_parameters = []
      self.string_tags = string_tags
      self.limitation = limitation
      @comment = Comment.new
      @tags = Tags.new(false, false, false)
    end

    def out_parameter_strings=(match)
      # TODO: Can Parameter.from_string be used here instead of in finalize
      @out_parameter_strings = (match || '').downcase.split(', ')
    end

    def in_parameter_strings=(match)
      # TODO: Can Parameter.from_string be used here instead of in finalize
      @in_parameter_strings = (match || '').split(', ')
    end

    def string_tags=(match)
      @string_tags = (match || '').downcase.split(', ')
    end

    def limitation=(match)
      @limitation = (match || '').downcase
    end

    # TODO: Tidy this up
    def finalize
      @string_tags.each do |tag|
        @tags.optional |= tag.include?('optional')
        @tags.deprecated |= tag.include?('deprecated')
        @tags.experimental |= tag.include?('experimental')
      end

      success = true
      success &= @comment.finalize

      @in_parameters = @in_parameter_strings.map { |s| Parameter.from_string(s) }

      # Remove first void if present
      index = @out_parameter_strings.index('void') || @out_parameter_strings.length
      @out_parameter_strings.delete_at(index)
      if @out_parameter_strings.empty?
        # FIXME: Why is there out_parameter and out_parameters. Can there be just out_parameters
        @out_parameter = Parameter.from_string('void unnamed')
        return success
      end

      # Guess out parameter name from method name
      param_name = guess_out_parameter_name
      if !param_name.empty?
        @out_parameter_strings.first << " #{param_name}"
        @out_parameter = Parameter.from_string(@out_parameter_strings.first)
      else
        @out_parameter_strings.each_with_index do |string, i|
          string << " value#{i}"
        end
      end

      @out_parameters = @out_parameter_strings.map { |s| Parameter.from_string(s) }

      success
    end

    def optional?
      @tags.optional
    end

    def deprecated?
      @tags.deprecated
    end

    def experimental?
      @tags.experimental
    end

    def has_parameters?
      !@in_parameters.empty? || !@out_parameters.empty?
    end

    private

    # FIXME: We can do better here
    # E.g. ReadValue -> Value, ConnectDevice -> Device
    def guess_out_parameter_name
      return '' if @out_parameter_strings.size != 1

      if @name =~ /([A-Z][a-z0-9]+)+/
        $& # .downcase # FIXME: downcase?
      else
        'value'
      end
    end
  end
end
