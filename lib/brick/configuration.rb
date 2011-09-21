module Brick
  module Configuration
    attr_accessor :bricklayer_server, :package_name,
                  :deploy_server, :deploy_user

    def load_configuration(options = {})
      self.bricklayer_server = options[:bricklayer]
      self.package_name      = options[:name]
      self.deploy_server     = options[:server]
      self.deploy_user       = options[:user]
      @verbose               = options[:verbose]
    end

    def verbose?
      @verbose
    end
  end
end
