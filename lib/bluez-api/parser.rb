# frozen_string_literal: true

module BluezApi
  class Parser
    attr_reader :interfaces

    def initialize
      @interfaces = []
      @current_interface = nil
    end

    # file: String
    def parse(file)
      file.each_line do |line|
        line.rstrip!

        if line.start_with?('=')
          @interfaces << Interface.new
          @current_interface = @interfaces.last
        elsif @current_interface
          @current_interface = nil unless @current_interface.parse(line)
        end
      end
    end

    def finalize
      @interfaces.reject! do |interface|
        interface.methods.methods.empty? && interface.properties.properies.empty?
      end

      @interfaces.reduce(true) { |success, interface| success & interface.finalize }
    end
  end
end
