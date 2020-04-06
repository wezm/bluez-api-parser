# frozen_string_literal: true

require 'test_helper'

describe BluezApi::Parser do
  it 'parses the interfaces' do
    parser = BluezApi::Parser.new
    parser.parse(read_fixture('adapter-api.txt'))
    parser.parse(read_fixture('device-api.txt'))
    _(parser.finalize).must_equal true

    _(parser.interfaces.map(&:name)).must_equal %w[
      org.bluez.Adapter1
      org.bluez.Device1
    ]
  end
end
