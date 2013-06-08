module RubyDeveloperTest
  module WordStreamers
    class WordFromFileStreamer
      def initialize(file_path)
        @file_path = file_path
      end

      def next_word
        data.delete_at(0)
      end

      private

      def load_all_data
        @data = open(@file_path) {|f| f.read }.split(",")
      end

      def data
        load_all_data if @data.nil?
        @data
      end
    end
  end
end
