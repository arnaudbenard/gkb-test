module TwitterResponseFixtures
  class Statuses
    class << self

      def user_timeline_response
        file  = File.join(ROOT_DIR,"spec/support/twitter_responses/statuses/user_timeline.js")
        IO.read(file)
      end

    end
  end
end