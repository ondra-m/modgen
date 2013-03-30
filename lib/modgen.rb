# Test API
#
# in 'test_api' run 'shotgun config.ru --port=9292'

require "modgen/core_ext/hash"
require "modgen/core_ext/object"
require "modgen/core_ext/string"

require "modgen/version"
require "modgen/default_configuration"
require "modgen/errors"

require "modgen/configuration"

require "faraday"
require "multi_json"

module Modgen

  autoload :Discovery, 'modgen/discovery/discovery'
  autoload :API,       'modgen/api'

  def self.config
    @config ||= Configuration.new(DEFAULT_CONFIGURATION)
  end

  def self.configure(&block)
    config.instance_eval(&block)
  end

end
