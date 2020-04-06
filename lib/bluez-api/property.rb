# frozen_string_literal: true

module BluezApi
  class Property
    Tags = Struct.new(:optional, :read_only, :experimental, :server_only)

    attr_reader :type, :tags, :comment
    attr_accessor :name

    def initialize(type:, name:, string_tags:, limitation:)
      self.type = type
      self.name = name
      self.string_tags = string_tags
      self.limitation = limitation
      @comment = Comment.new
      @tags = Tags.new(false, false, false, false)
    end

    def type=(type)
      @type = type.downcase
    end

    def string_tags=(match)
      @string_tags = (match || '').downcase.split(', ')
    end

    def limitation=(match)
      @limitation = (match || '').downcase
    end

    def optional?
      @tags.optional
    end

    def read_only?
      @tags.read_only
    end

    def experimental?
      @tags.experimental
    end

    def server_only?
      @tags.server_only
    end

    def finalize
      @string_tags.each do |tag|
        @tags.optional |= tag.include?('optional')
        @tags.experimental |= tag.include?('experimental')
        @tags.read_only |= tag.include?('read-only')
        @tags.read_only |= tag.include?('readonly')
      end
      @tags.server_only = @limitation.include?('server only')

      success = @comment.finalize

      success
    end
  end
end
