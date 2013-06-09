require 'spec_helper'

require_relative '_shared/word_source_interface'

describe RubyDeveloperTest::TweepsumWordSource do

  let(:klass) { described_class }
  let(:instance) { klass.new("foo bar") }

  it_behaves_like "a word source"


end
