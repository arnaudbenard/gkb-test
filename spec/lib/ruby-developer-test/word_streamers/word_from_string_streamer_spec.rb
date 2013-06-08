require 'spec_helper'

require_relative '_shared/word_streamer_interface'

describe RubyDeveloperTest::WordStreamers::WordFromStringStreamer do
  let(:klass) { described_class }
  let(:instance) { klass.new(comma_separated_string) }

  it_behaves_like "a word streamer"


  let(:words) { comma_separated_string.split(/,/) }
  let(:comma_separated_string) { "lorem,ipsum,ipsum" }

  context "#initialize" do
    it "accepts comma separated string" do
      expect { klass.new(comma_separated_string) }.not_to raise_error
    end
  end

  context "#next_word" do
    it "returns next word" do
      expect(instance.next_word).to eq words[0]
      expect(instance.next_word).to eq words[1]
      expect(instance.next_word).to eq words[2]
    end
  end



end