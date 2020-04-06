# frozen_string_literal: true

require 'test_helper'

describe BluezApi::Xml::Generator do
  it 'generates XML for each interface' do
    # Parse
    parser = BluezApi::Parser.new
    parser.parse(read_fixture('adapter-api.txt'))
    parser.parse(read_fixture('device-api.txt'))
    _(parser.finalize).must_equal true

    # Generate
    config = BluezApi::Xml::Config.new
    generator = BluezApi::Xml::Generator.new(config)
    docs = generator.generate(parser)

    # Validate
    _(docs[0]).must_include '<interface name="org.bluez.Adapter1"'
    _(docs[1]).must_include '<interface name="org.bluez.Device1"'
  end
end
