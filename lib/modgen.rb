require "modgen/core_ext/hash"
require "modgen/core_ext/object"
require "modgen/core_ext/string"

require "modgen/version"
require "modgen/configuration"
require "modgen/default_configuration"
require "modgen/errors"

require "faraday"
require "multi_json"
require "mimemagic"

module Modgen

  autoload :Discovery, 'modgen/discovery/discovery'
  autoload :API,       'modgen/api'
  autoload :Session,   'modgen/session'

  # Line set and get configuration
  #
  # *Set:* Modgen.config.key = "value"
  #
  # *Get:* Modgen.config.key
  #
  # == Returns:
  # Top of Modgen::Configuration
  #
  def self.config
    @config ||= Modgen::Configuration.new(DEFAULT_CONFIGURATION)
  end

  # Cofiguration with DSL
  #
  #   Modgen.configure do
  #     key "value"
  #   end
  #
  def self.configure(&block)
    config.instance_eval(&block)
  end

end
