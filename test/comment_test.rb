# frozen_string_literal: true

require 'test_helper'

describe BluezApi::Comment do
  before do
    @comment = BluezApi::Comment.new
  end

  it 'ignores leading empty lines' do
    @comment << ''
    @comment << ''
    @comment << 'not empty'
    @comment.finalize
    _(@comment.lines).must_equal ['not empty']
  end

  it 'trims trailing empty lines' do
    @comment << 'before'
    @comment << ''
    @comment << 'after'
    @comment << ''
    @comment.finalize
    _(@comment.lines).must_equal ['before', '', 'after']
  end

  it 'preserves indentation shared by all lines' do
    @comment << "\t\tone"
    @comment << "\t\ttwo"
    @comment << "\t\tthree"
    @comment.finalize
    _(@comment.lines).must_equal %w[one two three]
  end

  it 'replaces any non-shared indentation with spaces' do
    @comment << "\tone"
    @comment << "\t\ttwo"
    @comment << "\t\tthree"
    @comment.finalize
    _(@comment.lines).must_equal ['one', '    two', '    three']
  end

  it 'handles blank lines between those with indentation' do
    @comment << "\t\tone"
    @comment << ''
    @comment << "\t\tthree"
    _(@comment.finalize).must_equal true
  end
end
