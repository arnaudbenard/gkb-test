require 'spec_helper'

require_relative "word_source_interface"

describe RubyDeveloperTest::Abstract::WordSource do

  class TestConatiner
    include RubyDeveloperTest::Abstract::WordSource
  end

  let(:klass) { TestConatiner }

  it_behaves_like "a word source"

end
