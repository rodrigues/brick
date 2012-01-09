module Brick
  module Server
    extend self

    def deploy(tag)
      Net::SSH.start Brick.deploy_server, Brick.deploy_user do |ssh|
        Brick.max_tries.times do
          exec(ssh, "apt-get update")
          cache_show = exec(ssh, "apt-cache show #{Brick.package_name}")
          version = tag.split('_')[1]

          unless cache_show =~ /#{Brick.package_name}_#{version}_(.*)\.deb/
            sleep 2
            next
          end

          exec(ssh, "apt-get install --force-yes -y #{Brick.package_name}")
          break
        end
      end
    end

    def exec(ssh, command)
      ssh.exec!(command).tap do |result|
        return result unless Brick.verbose?
        puts command
        puts result
      end
    end
  end
end
