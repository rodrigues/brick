module Brick
  module Bricklayer
    extend self
    MAX_TRIES = 80
    SUCCESS = %r{^dpkg-buildpackage: full upload; Debian-native package \(full source is included\)}

    def wait_build(tag)
      abort "build not succeeded" unless succeeded? build(tag, project(tag))
    end

    def succeeded?(build)
      result = ""

      MAX_TRIES.times do
        result = RestClient.get(log_uri % build).lines.to_a.last
        break if result =~ SUCCESS
        sleep 2
      end

      puts result if Brick.verbose?
      result =~ SUCCESS
    end

    def project(tag)
      project = nil

      MAX_TRIES.times do
        project = JSON.parse RestClient.get(project_uri)
        puts "project_: #{project}" if Brick.verbose?
        break if project["last_tag_testing"] == tag
        project = nil
        sleep 5
      end

      abort "tag not built" unless project
      puts "project: #{project}" if Brick.verbose?
      project
    end

    def build(tag, project)
      build = nil
      done = false

      MAX_TRIES.times do
        builds = JSON.parse RestClient.get(build_uri)

        builds.reverse.each do |item|
          done = item["version"] == tag.split('_')[1]
          build = item if done
          break if done
        end

        break if done
        sleep 2
      end

      abort "build not found for tag #{tag}" unless done
      puts "build: #{build}" if Brick.verbose?
      build["build"]
    end

    def base_uri
      "#{Brick.bricklayer_server}/%s/#{Brick.package_name}"
    end

    def project_uri
      (base_uri % "project").tap do |uri|
        puts "project_uri: #{uri}" if Brick.verbose?
      end
    end

    def build_uri
      (base_uri % "build").tap do |uri|
        puts "build_uri: #{uri}" if Brick.verbose?
      end
    end

    def log_uri
      ("#{base_uri % "log"}/%s").tap do |uri|
        puts "log_uri: #{uri}" if Brick.verbose?
      end
    end
  end
end
