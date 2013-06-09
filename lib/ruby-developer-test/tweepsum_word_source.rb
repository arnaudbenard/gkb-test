module RubyDeveloperTest
  class TweepsumWordSource < WordSource
    def initialize(timeline_feed_url)
      streamer = ::RubyDeveloperTest::WordStreamers::WordFromTwitterStreamer.new(
        timeline_feed_url
      )
      super(streamer)
    end
  end
end