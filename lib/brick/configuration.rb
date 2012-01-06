module Brick
  module Configuration
    attr_accessor :bricklayer_server, :package_name,
                  :deploy_server, :deploy_user, :max_tries

    def load_configuration(options = {})
      self.bricklayer_server = options[:bricklayer]
      self.package_name      = options[:name]
      self.deploy_server     = options[:server]
      self.deploy_user       = options[:user]
      self.max_tries         = options[:max_tries] || 50
      @verbose               = options[:verbose]
    end

    def verbose?
      @verbose
    end
  end
end
