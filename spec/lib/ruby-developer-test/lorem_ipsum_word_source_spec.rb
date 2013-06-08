require 'spec_helper'

require_relative '_shared/word_source_interface'

describe RubyDeveloperTest::LoremIpsumWordSource do

  let(:klass) { described_class }
  let(:instance) { klass.new("foo bar") }

  it_behaves_like "a word source"

  let(:word_streamer) {
    ::RubyDeveloperTest::WordStreamers::WordFromStringStreamer.new(
      comma_separated_string
    )
  }


  let(:short_comma_separated_string) { "lorem,ipsum,ipsum" }
  let(:long_comma_separated_string) {
    "lorem,ipsum,ipsum,dolor,sit,amet,lorem,ipsum,dolor,sit,amet,dolor,dolor,foo,bar,baz"
  }

  let(:comma_separated_string) { short_comma_separated_string }


  let(:top_5_words_result_1) { ["ipsum", "lorem", nil, nil, nil ] }
  let(:top_5_words_result_2) { ["dolor", "ipsum", "lorem", "sit", "amet"] }

  let(:top_5_consonants_result_1) { ["m","p","s",nil,nil] }
  let(:top_5_consonants_result_2) { ["m", "p","s", "r", "l"] }

  before do
    instance.stub(:word_streamer => word_streamer)
  end

  context "#run" do
    let(:comma_separated_string) { long_comma_separated_string }

    it "scans all available words" do
      instance.run
      expect(instance.count).to eq 16
    end
  end

  context "#next_word" do
    it "returns next word from the streamer" do
      word_streamer.should_receive(:next_word).and_return("next word")
      expect(instance.next_word).to eq "next word"
    end

    it "triggers callbacks" do
      pending
    end
  end

  context "#top_5_words" do
    context "no words scanned" do
      it "returns an array with 5 nils" do
        expect(instance.top_5_words).to eq [nil,nil,nil,nil,nil]
      end
    end

    context "less than 5 different words scanned" do
      it "returns an array of words of size 5 padded with nils" do
        3.times { instance.next_word }
        expect(instance.top_5_words).to eq top_5_words_result_1
      end
    end

    context "more than 5 different words scanned" do

      let(:comma_separated_string) {long_comma_separated_string}

      it "returns top 5 words based on what's been read so far" do
        comma_separated_string.split(/,/).length.times { instance.next_word }
        expect(instance.top_5_words).to eq top_5_words_result_2
      end
    end
  end

  context "#top_5_consonants" do
    context "no words scanned" do
      it "returns an array with 5 nils" do
        expect(instance.top_5_consonants).to eq [nil,nil,nil,nil,nil]
      end
    end

    context "less than 5 different consonants scanned" do
      let(:comma_separated_string) { "mm,pp,ssppmm" }

      it "returns an array of consonants of size 5 padded with nils" do
        3.times { instance.next_word }
        expect(instance.top_5_consonants).to eq top_5_consonants_result_1
      end
    end

    context "more than 5 different consonants scanned" do

      it "returns top 5 consonants based on what's been read so far" do
        3.times { instance.next_word }
        expect(instance.top_5_consonants).to eq top_5_consonants_result_2
      end
    end
  end

  context "#count" do
    it "returns the current count of scanned words" do
      instance.next_word
      expect(instance.count).to eq 1
      instance.next_word
      instance.next_word
      expect(instance.count).to eq 3
    end
  end

  context "#add_callback_on_word_match" do

    let(:callbacks_result_1) {
      ["found lorem", "found ipsum", "found ipsum", "found lorem", "found ipsum"]
    }

    let(:callbacks_result_2) {
      ["found lorem 1", "found lorem 2",
       "found ipsum 1", "found ipsum 2",
       "found ipsum 1", "found ipsum 2",
       "found lorem 1", "found lorem 2",
       "found ipsum 1", "found ipsum 2"]
    }
    let(:comma_separated_string) { long_comma_separated_string }

    it "adds callback on word match" do
      result = []
      instance.add_callback_on_word_match "lorem" do
        result << "found lorem"
      end
      instance.add_callback_on_word_match "ipsum" do
        result << "found ipsum"
      end
      instance.add_callback_on_word_match "foobar" do
        result << "found foobar"
      end
      instance.run
      expect(result).to eq callbacks_result_1
    end

    it "adds multiple callbacks on a single word" do
      result = []
      instance.add_callback_on_word_match "lorem" do
        result << "found lorem 1"
      end
      instance.add_callback_on_word_match "lorem" do
        result << "found lorem 2"
      end
      instance.add_callback_on_word_match "ipsum" do
        result << "found ipsum 1"
      end
      instance.add_callback_on_word_match "ipsum" do
        result << "found ipsum 2"
      end
      instance.add_callback_on_word_match "foobar" do
        result << "found foobar"
      end
      instance.run
      expect(result).to eq callbacks_result_2
    end
  end
end
