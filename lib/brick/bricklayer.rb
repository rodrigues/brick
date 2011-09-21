module Brick
  module Bricklayer
    extend self
    MAX_TRIES = 40
    SUCCESS = %r{^dpkg-buildpackage: full upload; Debian-native package \(full source is included\)}

    def wait_build(tag)
      succeeded? build(tag, project(tag))
    end

    def succeeded?(build)
      done = false

      MAX_TRIES.times do
        log = RestClient.get(log_uri % build["build"])
        done = log.lines.to_a.last =~ SUCCESS
        break if done
        sleep 2
      end

      exit 1 unless done
    end

    def project(tag)
      project = nil
      done = false

      MAX_TRIES.times do
        project = JSON.parse RestClient.get(project_uri)
        done = project["last_tag_testing"] == tag
        break if done
        sleep 5
      end

      unless done
        abort "tag #{tag} isn't the last. last_tag_testing (#{project["last_tag_testing"]})"
      end

      project
    end

    def build(tag, project)
      build = nil
      done = false

      MAX_TRIES.times do
        builds = JSON.parse RestClient.get(build_uri)

        builds.reverse.each do |item|
          done = item["version"] == tag.split("_")[1]
          build = item if done
          break if done
        end

        break if done
        sleep 2
      end

      unless done
        abort "build not found for tag #{tag}"
      end

      build["build"]
    end

    def project_uri
      "#{Brick.bricklayer_server}/project/#{Brick.package_name}"
    end

    def build_uri
      "#{Brick.bricklayer_server}/build/#{Brick.package_name}"
    end

    def log_uri
      "#{Brick.bricklayer_server}/log/#{Brick.package_name}/%s"
    end
  end
end
