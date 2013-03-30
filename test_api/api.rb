require "grape"
require "multi_json"

require File.expand_path('../discovery', __FILE__)
require File.expand_path('../v1', __FILE__)

module ModgenTest
  class API < Grape::API
    mount ModgenTest::APIDiscovery => '/api'
    mount ModgenTest::APIv1        => '/api/v1'
  end
end
