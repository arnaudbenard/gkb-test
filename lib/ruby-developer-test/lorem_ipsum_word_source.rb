module RubyDeveloperTest
  class LoremIpsumWordSource < WordSource
    def initialize(file_path)
      streamer = ::RubyDeveloperTest::WordStreamers::WordFromFileStreamer.new(
        file_path
      )
      super(streamer)
    end
  end
end