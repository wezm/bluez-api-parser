# frozen_string_literal: true

require 'test_helper'

describe BluezApi::Property do
  describe 'attributes' do
    it 'sets name, type and comment correctly' do
      # string Name [readonly, optional]
      property = BluezApi::Property.new(
        type: 'String',
        name: 'Name',
        string_tags: 'readonly, optional',
        limitation: nil
      ).tap(&:finalize)

      _(property.type).must_equal 'string' # it gets downcased
      _(property.name).must_equal 'Name'
      _(property.comment).must_be_kind_of BluezApi::Comment
    end
  end

  describe 'tags' do
    def with_tags(tags)
      BluezApi::Property.new(
        type: 'String',
        name: 'Name',
        string_tags: tags,
        limitation: nil
      ).tap(&:finalize)
    end

    describe 'read_only' do
      it 'sets read_only from read-only' do
        property = with_tags('read-only, optional')
        _(property.tags.read_only).must_equal true
      end

      it 'sets read_only from readonly' do
        property = with_tags('readonly, optional')
        _(property.tags.read_only).must_equal true
      end

      it 'sets optional' do
        property = with_tags('readonly, optional')
        _(property.tags.optional).must_equal true
      end

      it 'sets experimental' do
        property = with_tags('readonly, experimental')
        _(property.tags.experimental).must_equal true
      end

      it 'sets server_only from limitation' do
        property = BluezApi::Property.new(
          type: 'String',
          name: 'Name',
          string_tags: nil,
          limitation: 'Server Only'
        ).tap(&:finalize)
        _(property.tags.server_only).must_equal true
      end
    end
  end
end
