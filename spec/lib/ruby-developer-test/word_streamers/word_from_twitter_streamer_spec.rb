require 'spec_helper'

require_relative '_shared/word_streamer_interface'

describe RubyDeveloperTest::WordStreamers::WordFromTwitterStreamer do
  let(:klass) { described_class }
  let(:instance) { klass.new(timeline_feed_url) }
  let(:timeline_feed_url) { "https://api.twitter.com/1/statuses/user_timeline.json?screen_name=tweepsum&count=1" }

  it_behaves_like "a word streamer"



  let(:words) { comma_separated_string.split(/,/) }
  let(:comma_separated_string) {
    "Lorem,ipsum,tweets,at,coffee,time,http://t.co/RfAeb8d9dh,for,web,designers,and,wireframes,11:00 08-06-2013,#tweepsum"
  }

  context "#next_word" do
    before do
      stub_request(
        :get,
        "https://api.twitter.com/1/statuses/user_timeline.json?count=1&screen_name=tweepsum"
      ).to_return({:body => TwitterResponseFixtures::Statuses.user_timeline_response})

    end


    it "returns next word" do
      expect(instance.next_word).to eq words[0]
      expect(instance.next_word).to eq words[1]
      expect(instance.next_word).to eq words[2]
    end

    context "when we read from multiple tweets" do

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



end