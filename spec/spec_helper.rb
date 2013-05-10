$:.unshift File.dirname(__FILE__) + '/../lib'
require "modgen"

API_URL = 'http://localhost:3000'

API_KEY = 'f0ddaaef2903e6f2ac634e7f6037c9b2'

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  # config.filter_run :focus
  config.color_enabled = true
  config.formatter     = 'documentation'
end
