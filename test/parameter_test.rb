# frozen_string_literal: true

require 'test_helper'

describe BluezApi::Parameter do
  describe 'from_string' do
    it 'sets type and name from the string' do
      parameter = BluezApi::Parameter.from_string('int count')
      _(parameter.type).must_equal 'int'
      _(parameter.name).must_equal 'count'
    end

    it 'raises an error if the string has fewer than two words' do
      expect { BluezApi::Parameter.from_string('one') }
        .must_raise BluezApi::Parameter::InvalidParameter
    end

    it 'raises an error if the string has more than two words' do
      expect { BluezApi::Parameter.from_string('one two three') }
        .must_raise BluezApi::Parameter::InvalidParameter
    end
  end
end
