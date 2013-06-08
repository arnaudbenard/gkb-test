require 'spec_helper'

describe RubyDeveloperTest::LoremIpsumWordSource do

  let(:klass) { described_class }

  it_behaves_like "a word source"

  subject { klass.new }

end
