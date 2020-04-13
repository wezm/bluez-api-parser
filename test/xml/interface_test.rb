# frozen_string_literal: true

require 'test_helper'

describe BluezApi::Xml::Interface do
  def build_interface
    device_api = read_fixture('device-api.txt')
    interface = BluezApi::Interface.new
    device_api.each_line { |line| interface.parse(line) }
    interface.tap(&:finalize)
  end

  it 'generates XML' do
    config = BluezApi::Xml::Config.new
    interface = build_interface
    builder = Builder::XmlMarkup.new(:indent => 2)
    xml = BluezApi::Xml::Interface.new(config, builder).generate(interface)

    _(xml).must_equal <<~END_XML
      <interface name="org.bluez.Device1">
        <method name="Connect"/>
        <method name="Disconnect"/>
        <method name="ConnectProfile">
          <arg name="uuid" type="s" direction="in"/>
        </method>
        <method name="DisconnectProfile">
          <arg name="uuid" type="s" direction="in"/>
        </method>
        <method name="Pair"/>
        <method name="CancelPairing"/>
        <property name="Address" type="s" access="read"/>
        <property name="AddressType" type="s" access="read"/>
        <property name="Name" type="s" access="read"/>
        <property name="Icon" type="s" access="read"/>
        <property name="Class" type="u" access="read"/>
        <property name="Appearance" type="q" access="read"/>
        <property name="UUIDs" type="as" access="read"/>
        <property name="Paired" type="b" access="read"/>
        <property name="Connected" type="b" access="read"/>
        <property name="Trusted" type="b" access="readwrite"/>
        <property name="Blocked" type="b" access="readwrite"/>
        <property name="Alias" type="s" access="readwrite"/>
        <property name="Adapter" type="o" access="read"/>
        <property name="LegacyPairing" type="b" access="read"/>
        <property name="Modalias" type="s" access="read"/>
        <property name="RSSI" type="n" access="read"/>
        <property name="TxPower" type="n" access="read"/>
        <property name="ManufacturerData" type="asv" access="read"/>
        <property name="ServiceData" type="asv" access="read"/>
        <property name="ServicesResolved" type="b" access="read"/>
      </interface>
    END_XML
  end
end
