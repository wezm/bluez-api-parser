# frozen_string_literal: true

require 'test_helper'

# This test covers Methods and Method

describe BluezApi::Methods do
  def with_line(line)
    methods = BluezApi::Methods.new
    methods.parse(line)
    methods.finalize
    methods.methods
  end

  it 'parses a simple method' do
    methods = with_line("\t\tvoid StartDiscovery()")
    _(methods.size).must_equal 1
    method = methods.first

    _(method.name).must_equal 'StartDiscovery'
    _(method.out_parameter).must_equal BluezApi::Parameter.new('void', 'unnamed')
    _(method.out_parameters).must_be_empty
    _(method.in_parameters).must_be_empty
    _(method.tags).must_equal BluezApi::Method::Tags.new(false, false, false)
  end

  it 'parses a method with arguments' do
    methods = with_line("\t\tarray{byte} ReadValue(dict flags)")
    _(methods.size).must_equal 1
    method = methods.first

    _(method.name).must_equal 'ReadValue'
    out_parameter = BluezApi::Parameter.new('array{byte}', 'ReadValue')
    _(method.out_parameter).must_equal out_parameter
    _(method.out_parameters).must_equal [out_parameter]
    _(method.in_parameters).must_equal [BluezApi::Parameter.new('dict', 'flags')]
    _(method.tags).must_equal BluezApi::Method::Tags.new(false, false, false)
  end

  it 'parses a method with multiple arguments' do
    methods = with_line("\t\tvoid RegisterApplication(object application, dict options)")
    _(methods.size).must_equal 1
    method = methods.first

    _(method.name).must_equal 'RegisterApplication'
    _(method.out_parameter).must_equal BluezApi::Parameter.new('void', 'unnamed')
    _(method.out_parameters).must_be_empty
    _(method.in_parameters).must_equal [
      BluezApi::Parameter.new('object', 'application'),
      BluezApi::Parameter.new('dict', 'options'),
    ]
    _(method.tags).must_equal BluezApi::Method::Tags.new(false, false, false)
  end

  it 'parses a method with multiple out parameters' do
    methods = with_line("\t\tfd, uint16, uint16 Acquire()")
    _(methods.size).must_equal 1
    method = methods.first

    _(method.name).must_equal 'Acquire'
    _(method.out_parameter).must_be_nil
    _(method.out_parameters).must_equal [
      BluezApi::Parameter.new('fd', 'value0'),
      BluezApi::Parameter.new('uint16', 'value1'),
      BluezApi::Parameter.new('uint16', 'value2'),
    ]
    _(method.in_parameters).must_be_empty
    _(method.tags).must_equal BluezApi::Method::Tags.new(false, false, false)
  end

  it 'parses a method with tags' do
    methods = with_line("\t\tobject ConnectDevice(dict properties) [experimental]")
    _(methods.size).must_equal 1
    method = methods.first

    _(method.name).must_equal 'ConnectDevice'
    out_parameter = BluezApi::Parameter.new('object', 'ConnectDevice')
    _(method.out_parameter).must_equal out_parameter
    _(method.out_parameters).must_equal [out_parameter]
    _(method.in_parameters).must_equal [
      BluezApi::Parameter.new('dict', 'properties'),
    ]
    _(method.tags).must_equal BluezApi::Method::Tags.new(false, false, true)
  end

  it 'parses an optional method' do
    methods = with_line("\t\tfd, uint16 AcquireWrite(dict options) [optional]")
    _(methods.size).must_equal 1
    method = methods.first

    _(method.name).must_equal 'AcquireWrite'
    _(method.out_parameter).must_be_nil
    _(method.out_parameters).must_equal [
      BluezApi::Parameter.new('fd', 'value0'),
      BluezApi::Parameter.new('uint16', 'value1'),
    ]
    _(method.in_parameters).must_equal [
      BluezApi::Parameter.new('dict', 'options'),
    ]
    _(method.tags).must_equal BluezApi::Method::Tags.new(true, false, false)
  end
end
