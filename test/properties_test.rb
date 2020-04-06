# frozen_string_literal: true

require 'test_helper'

describe BluezApi::Properties do
  def with_line(line)
    properties = BluezApi::Properties.new
    properties.parse(line)
    properties.finalize
    properties.properties
  end

  it "parses a 'read-only' property" do
    properties = with_line("\tarray{string} UUIDs [read-only]")
    _(properties.size).must_equal 1
    property = properties.first

    _(property.type).must_equal 'array{string}'
    _(property.name).must_equal 'UUIDs'
    _(property.tags.read_only).must_equal true
  end

  it "parses a 'readonly' property" do
    properties = with_line("\tuint32 NumberOfItems [readonly]")
    _(properties.size).must_equal 1
    property = properties.first

    _(property.type).must_equal 'uint32'
    _(property.name).must_equal 'NumberOfItems'
    _(property.tags.read_only).must_equal true
  end

  it "parses a 'readwrite' property" do
    properties = with_line("\tstring Equalizer [readwrite]")
    _(properties.size).must_equal 1
    property = properties.first

    _(property.type).must_equal 'string'
    _(property.name).must_equal 'Equalizer'
    _(property.tags.read_only).must_equal false
  end

  it "parses an optional 'readonly' property with trailing colon" do
    properties = with_line("\tstring UUID [readonly, optional]:")
    _(properties.size).must_equal 1
    property = properties.first

    _(property.type).must_equal 'string'
    _(property.name).must_equal 'UUID'
    _(property.tags.read_only).must_equal true
    _(property.tags.optional).must_equal true
  end
end
