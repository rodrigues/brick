require "active_support/core_ext/module/attribute_accessors"
require "json"
require "rest_client"
require "net/ssh"

require "brick/configuration"
require "brick/bricklayer"
require "brick/testing_tag"
require "brick/version"

module Brick
  extend self
  extend Configuration

  def run!(options = {})
    load_configuration(options)
    TestingTag.create.tap do |testing_tag|
      Bricklayer.wait_build(testing_tag)
      Server.deploy(testing_tag)
    end
  end
end
