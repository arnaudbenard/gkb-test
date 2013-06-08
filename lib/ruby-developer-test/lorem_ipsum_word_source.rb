module RubyDeveloperTest
  class LoremIpsumWordSource

    def initialize #(word_streamer)
      @word_stats = {}
      @word_count = 0
      @consonant_stats = {}
    end

    def run

    end

    def next_word
      word = word_streamer.next_word
      callback_after_next_word(word)
      word
    end

    def top_5_consonants
      sorted_stats = @consonant_stats.sort {|x,y| y[1] <=> x[1]}
      consonants = sorted_stats.collect {|el| el[0] }
      add_padding_to_array(consonants, 5, nil).take(5)
    end

    def top_5_words
      sorted_stats = @word_stats.sort {|x,y| y[1] <=> x[1]}
      words = sorted_stats.collect {|el| el[0] }
      add_padding_to_array(words, 5, nil).take(5)
    end

    def count
      @word_count
    end

    def callback

    end

    private

    def add_padding_to_array(data_array, max_length, filler)
      data_array + filled_array(max_length - data_array.length, filler)
    end

    def filled_array(length, filler)
      [].fill(0,length){ filler }
    end

    def callback_after_next_word(word)
      increase_word_count
      count_unique_words(word)
      count_consonants(word)
    end

    def word_streamer
      @word_streamer ||= ::RubyDeveloperTest::WordStreamers::WordFromStringStreamer.new(
        "lorem,ipsum,ipsum"
      )
    end

    def increase_word_count
      @word_count += 1
    end

    def count_unique_words(word)
      @word_stats[word] = @word_stats[word].to_i + 1
    end

    def count_consonants(word)
      extract_consonants(word).each do |letter|
        @consonant_stats[letter] = @consonant_stats[letter].to_i + 1
      end
    end

    def extract_consonants(word)
      english_cosonant_list =  %W{
        b c d f g h j k l m n p q r s t v x z w y
        B C D F G H J K L M N P Q R S T V X Z W Y
      }

      word.split("").select do |letter|
        english_cosonant_list.member? letter
      end
    end



  end
end