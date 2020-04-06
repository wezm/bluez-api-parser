# frozen_string_literal: true

require 'test_helper'

describe BluezApi::Interface do
  before do
    device_api = read_fixture('device-api.txt')
    @interface = BluezApi::Interface.new
    device_api.each_line { |line| @interface.parse(line) }
    @interface.finalize
  end

  it 'parses the name, object_path, and service' do
    _(@interface.name).must_equal 'org.bluez.Device1'
    _(@interface.object_path).must_equal '[variable prefix]/{hci0,hci1,...}/dev_XX_XX_XX_XX_XX_XX'
    _(@interface.service).must_equal 'org.bluez'
  end

  it 'parses the methods' do
    method_names = @interface.methods.map(&:name)
    _(method_names).must_equal %w[
      Connect
      Disconnect
      ConnectProfile
      DisconnectProfile
      Pair
      CancelPairing
    ]
  end

  it 'parses the properties' do
    property_names = @interface.properties.map(&:name)
    _(property_names).must_equal %w[
      Address
      AddressType
      Name
      Icon
      Class
      Appearance
      UUIDs
      Paired
      Connected
      Trusted
      Blocked
      Alias
      Adapter
      LegacyPairing
      Modalias
      RSSI
      TxPower
      ManufacturerData
      ServiceData
      ServicesResolved
      AdvertisingFlags
      AdvertisingData
    ]
  end

  it 'parses the comments' do
    comments = @interface.comments.comments
    # rubocop:disable Layout/LineLength
    _(comments).must_equal [
      "BlueZ D-Bus Device API description\n **********************************\n \n \n Device hierarchy\n ================\n \n",
    ]
    # rubocop:enable Layout/LineLength
  end
end
