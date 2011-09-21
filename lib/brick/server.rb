module Brick
  module Server
    extend self

    def deploy(tag)
      Net::SSH.start Brick.deploy_server, Brick.deploy_user do |ssh|
        ssh.exec!("apt-get update")
        info = ssh.exec!("apt-cache show #{Brick.package_name}")
        version = tag.split('_')[1]

        unless info =~ /#{Brick.package_name}_#{version}_(.*)\.deb/
          abort "version not updated"
        end

        ssh.exec!("apt-get install #{Brick.package_name}")
      end
    end
  end
end
