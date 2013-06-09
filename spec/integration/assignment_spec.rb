require 'spec_helper'

describe "ruby dev test" do
  context "LoremIpsumWordSource that pulls in words from 'lorem_ipsum.txt'" do

    let(:instance) { ::RubyDeveloperTest::LoremIpsumWordSource.new(file_path) }
    let(:file_path) { File.join(ROOT_DIR, "lorem_ipsum.txt") }


    let(:words) { comma_separated_string.split(/,/) }
    let(:comma_separated_string) {
      "Lorem,ipsum,dolor,sit,amet,consectetur,adipiscing,elit,Mauris,semper,lacus,commodo"
    }


    it "works correctly" do
      words.each_with_index do |word|
        expect(instance.next_word).to eq word
      end
    end
  end

  context "any word source can assign callbacks on specific words" do
    let(:instance) { ::RubyDeveloperTest::WordSource.new(streamer) }
    let(:streamer) {
      ::RubyDeveloperTest::WordStreamers::WordFromStringStreamer.new(
        comma_separated_string
      )
    }
    let(:comma_separated_string) {
      "ipsum,dolor,sit,amet,semper,semper,elit,semper,Mauris,semper"
    }

    let(:callback_result) {
      ["found semper 1", "found semper 2", "found semper 1", "found semper 2",
       "found semper 1", "found semper 2", "found semper 1", "found semper 2"]
    }


    it "works correctly" do

      result = []
      instance.add_callback_on_word_match "semper" do
        result << "found semper 1"
      end

      instance.add_callback_on_word_match "semper" do
        result << "found semper 2"
      end

      instance.run

      expect(result).to eq callback_result
    end
  end

  context "word source which uses Twitter API" do
    let(:instance) { ::RubyDeveloperTest::TweepsumWordSource.new(timeline_feed_url) }
    let(:timeline_feed_url) { "https://api.twitter.com/1/statuses/user_timeline.json?screen_name=tweepsum&count=1" }

    let(:words) { comma_separated_string.split(/,/) }
    let(:comma_separated_string) {
      "Lorem,ipsum,tweets,at,coffee,time,http://t.co/RfAeb8d9dh,for,web,designers,and,wireframes,11:00 08-06-2013,#tweepsum"
    }

    let(:result) {
      %w(
        Lorem ipsum tweets at coffee time http://t.co/RfAeb8d9dh for web
        designers and wireframes 11:00 08-06-2013 #tweepsum
        Lorem ipsum tweets at coffee time http://t.co/RfAeb8d9dh for web
        designers and wireframes 11:00 07-06-2013 #tweepsum
        Lorem ipsum tweets followed by http://t.co/aIQiLM0h3P you should
        follow @tweepsum too 11:00 06-06-2013 #tweepsum
        A lorem ipsum tweet at coffee time each day for web designers or
        anyone needing a test twitter feed 11:00 05-06-2013 #tweepsum
        A lorem ipsum tweet at coffee time each day for web designers or
        anyone needing a test twitter feed 11:00 04-06-2013 #tweepsum
      )
    }

    before do
      stub_request(
        :get,
        "https://api.twitter.com/1/statuses/user_timeline.json?count=1&screen_name=tweepsum"
      ).to_return({:body => TwitterResponseFixtures::Statuses.user_timeline_response})

    end

    it "works correctly" do
      result = []
      expect {
        120.times do
          result << instance.next_word
        end
      }.not_to raise_error
      expect(result).to eq result
    end

  end

end