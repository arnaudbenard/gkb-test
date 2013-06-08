require 'spec_helper'

require_relative '_shared/word_streamer_interface'

describe RubyDeveloperTest::WordStreamers::WordFromFileStreamer do
  let(:klass) { described_class }
  let(:instance) { klass.new(file_path) }

  it_behaves_like "a word streamer"

  let(:file_path) { File.join(ROOT_DIR, "lorem_ipsum.txt") }

  let(:words) { comma_separated_string.split(/,/) }
  let(:comma_separated_string) {
    "Lorem,ipsum,dolor,sit,amet,consectetur,adipiscing,elit,Mauris,semper,lacus,commodo"
  }

  context "#initialize" do
    it "accepts file path" do
      expect { klass.new(file_path) }.not_to raise_error
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