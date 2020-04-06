# frozen_string_literal: true

require 'test_helper'

describe BluezApi::Xml::Method do
  def build_method(line)
    methods = BluezApi::Methods.new
    methods.parse(line)
    methods.finalize
    methods.methods.first
  end

  it 'generates XML' do
    builder = Builder::XmlMarkup.new(:indent => 2)
    method = build_method("\t\tarray{byte} ReadValue(dict flags)")
    xml = BluezApi::Xml::Method.new(method).generate(builder)

    _(xml).must_equal <<~END_XML
      <method name="ReadValue">
        <arg name="flags" type="asv" direction="in"/>
        <arg name="ReadValue" type="ay" direction="out"/>
      </method>
    END_XML
  end
end
