module RubyDeveloperTest
  module WordStreamers
    class WordFromStringStreamer
      def initialize(comma_separated_string)
        @comma_separated_string = comma_separated_string
      end

      def next_word
        data.delete_at(0)
      end

      private

      def data
        @data ||= @comma_separated_string.split(/,/)
      end
    end
  end
end
