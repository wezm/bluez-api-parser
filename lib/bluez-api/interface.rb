# frozen_string_literal: true

module BluezApi
  class Interface
    attr_reader :comments, :name, :object_path, :service

    def initialize
      @state = State::COMMENT
      @methods = Methods.new
      @properties = Properties.new
      @comments = Comments.new
      @name = nil
      @object_path = nil
      @service = nil
    end

    def parse(line)
      if line.start_with?("Service\t")
        @state = State::SERVICE
      elsif line.start_with?("Interface\t")
        @state = State::INTERFACE
      elsif line.start_with?("Object path\t")
        @state = State::OBJECT_PATH
      elsif line.start_with?("Methods\t") || Methods.method?(line)
        @state = State::METHODS
      elsif line.start_with?("Properties\t")
        @state = State::PROPERTIES
      elsif @state != State::COMMENT && !line.empty? && !line.start_with?("\t")
        # If we do not parse comment, but line starts with characters, we are done.
        return false
      end

      case @state
      when State::COMMENT
        @comments.parse(line)
      when State::SERVICE
        parse_service(line)
      when State::INTERFACE
        parse_interface(line)
      when State::OBJECT_PATH
        parse_object_path(line)
      when State::METHODS
        @methods.parse(line)
      when State::PROPERTIES
        @properties.parse(line)
      end

      true
    end

    def finalize
      success = true
      success &= @methods.finalize
      success &= @properties.finalize
      success
    end

    def has_methods?
      !@methods.methods.empty?
    end

    def methods
      @methods.methods
    end

    def properties
      @properties.properties
    end

    private

    class State
      COMMENT = 1
      SERVICE = 2
      INTERFACE = 3
      OBJECT_PATH = 4
      METHODS = 5
      PROPERTIES = 6
    end

    class Comments
      attr_reader :comments

      def initialize
        @comments = []
      end

      def parse(line)
        @comments << String.new if line.empty? || line.start_with?(' ') || line.start_with?("\t")
        @comments.last << ' ' unless (@comments.last || '').empty?
        if @comments.last.nil?
          @comments << line
        else
          @comments.last << line
        end
      end
    end

    def parse_service(line)
      @service = $1 if line =~ /Service\t+(.+)/
    end

    def parse_interface(line)
      @name = $1 if line =~ /Interface\t+(.+)/
    end

    def parse_object_path(line)
      @object_path = $1 if line =~ /Object path\t+(.+)/
    end
  end
end
