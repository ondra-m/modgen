require "grape"
require "multi_json"

require File.expand_path('../discovery', __FILE__)
require File.expand_path('../v1', __FILE__)

require 'sqlite3'
require 'active_record'
require 'uri'

ActiveRecord::Base.establish_connection(
  adapter:  'sqlite3',
  database: 'db.sqlite3',
  encoding: 'utf8'
)

require "model"

module ModgenTest
  class API < Grape::API
    mount ModgenTest::APIDiscovery => '/api'
    mount ModgenTest::APIv1        => '/api/v1'
  end
end
