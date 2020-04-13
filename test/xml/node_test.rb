# frozen_string_literal: true

require 'test_helper'

describe BluezApi::Xml::Interface do
  it 'generates XML' do
    xml = BluezApi::Xml::Node.new.generate { |_xml| }

    _(xml).must_equal <<~END_XML
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE node PUBLIC "-//freedesktop//DTD D-BUS Object Introspection 1.0//EN" "http://www.freedesktop.org/standards/dbus/1.0/introspect.dtd">
      <node>
      </node>
    END_XML
  end
end
