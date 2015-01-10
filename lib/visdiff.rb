require "visdiff/version"

require 'visdiff/client'
require 'visdiff/config'
require 'visdiff/image'
require 'visdiff/revision'

module Visdiff
  def self.config
    @config ||= Config.new
    yield(@config) if block_given?
    @config
  end

  config.base_url = "http://www.visdiff.com/"
end
