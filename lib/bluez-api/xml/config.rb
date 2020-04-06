# frozen_string_literal: true

module BluezApi
  module Xml
    class Config
      attr_reader :include_optional, :include_deprecated, :include_experimental

      def initialize(include_optional: true, include_deprecated: false, include_experimental: false)
        @include_optional = include_optional
        @include_deprecated = include_deprecated
        @include_experimental = include_experimental
      end

      def include_optional?
        @include_optional
      end

      def include_deprecated?
        @include_deprecated
      end

      def include_experimental?
        @include_experimental
      end
    end
  end
end
