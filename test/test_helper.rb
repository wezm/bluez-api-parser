# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'bluez-api'

require 'minitest/autorun'

def read_fixture(*path)
  File.read File.join('test', 'fixtures', *path)
end
