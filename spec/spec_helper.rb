require 'ruby-developer-test'

ROOT_DIR = File.join( File.dirname(__FILE__), "../" )

require 'webmock/rspec'

require 'support/twitter_response_fixtures'

#WebMock.disable_net_connect!(:allow => //)


RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
end
