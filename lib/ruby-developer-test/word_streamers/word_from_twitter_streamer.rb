require "json"
require "open-uri"

module RubyDeveloperTest
  module WordStreamers
    class WordFromTwitterStreamer
      def initialize
        @recent_data_ttl = 60
      end

      def next_word
        data.delete_at(0)
      end

      private

      def data
        if should_refresh_data?
          refresh_data
        end
        @data
      end

      def extract_words(string)
        string.split(" ").collect do |str|
          str.split(",")
        end.flatten
      end

      def raw_current_data
        ::JSON::parse(fetch_new_data)
      end

      def fetch_new_data
        open("https://api.twitter.com/1/statuses/user_timeline.json?screen_name=tweepsum&count=1") {|f| f.read }
      end

      def recent_data
        @recent_data
      end

      def refresh_data
        @recent_data = {
          :last_refresh => Time.now,
          :data => raw_current_data,
        }

        @data = @recent_data[:data].collect do |el|
          extract_words(el["text"])
        end.flatten
      end

      def should_refresh_data?
        @recent_data.nil? || @recent_data[:last_refresh]  < (Time.now - @recent_data_ttl)
      end
    end
  end
end
