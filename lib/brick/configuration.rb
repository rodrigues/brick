module Brick
  module Configuration
    attr_accessor :bricklayer_server, :package_name,
                  :deploy_server, :deploy_user

    def load_configuration(options = {})
      bricklayer_server = options[:bricklayer]
      package_name      = options[:name]
      deploy_server     = options[:server]
      deploy_user       = options[:user]
    end
  end
end
