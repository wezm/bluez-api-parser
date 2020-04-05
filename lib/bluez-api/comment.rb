# frozen_string_literal: true

module BluezApi
  class Comment
    attr_reader :lines

    def initialize
      @lines = []
    end

    def <<(line)
      # Skip initial empty lines
      @lines << line unless line.empty? && @lines.empty?
    end

    def finalize
      # Delete last empty lines from comment
      @lines = @lines.reverse.drop_while(&:empty?).reverse

      # Find indents
      indents = @lines.reduce(255) do |mindent, line|
        if line.empty?
          mindent
        else
          [mindent, line.count("\t")].min
        end
      end

      # Remove indents
      @lines.map! { |line| line[indents..] || String.new }

      # Replace indents
      @lines.each { |line| line.gsub!("\t", '    ') }

      true
    end
  end
end
