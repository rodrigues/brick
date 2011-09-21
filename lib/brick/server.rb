module Brick
  module Server
    extend self
    MAX_TRIES = 20

    def deploy(tag)
      done = false

      MAX_TRIES.times do
        Net::SSH.start Brick.deploy_server, Brick.deploy_user do |ssh|
          update = ssh.exec!("apt-get update")

          if Brick.verbose?
            puts "apt-get update"
            puts update
          end

          cache_show = ssh.exec!("apt-cache show #{Brick.package_name}")

          if Brick.verbose?
            puts "apt-cache show"
            puts cache_show
          end

          version = tag.split('_')[1]

          unless cache_show =~ /#{Brick.package_name}_#{version}_(.*)\.deb/
            next
          end

          install = ssh.exec!("apt-get install #{Brick.package_name}")

          if Brick.verbose?
            puts "apt-get install"
            puts install
          end

          done = true
        end

        break if done
        sleep 2
      end
    end
  end
end
