module Brick
  module TestingTag
    extend self

    def create
      version_tags = `git tag | grep ^v`.lines
      max_major = 0
      max_minor = 0

      version_tags.each do |version|
        major, minor = strip_version('v', version)

        if major > max_major
          max_major = major
          max_minor = minor
        elsif major == max_major and minor > max_minor
          max_minor = minor
        end
      end

      testing_tags = `git tag| grep ^testing_#{max_major}.#{max_minor}`.lines
      build = 0

      testing_tags.each do |testing|
        major, minor, version = strip_version('testing_', testing)
        build = version + 1 if version >= build
      end

      tag = "testing_#{max_major}.#{max_minor}.#{build}"
      `git tag #{tag}`
      `git push --tags`
      tag
    end

    def strip_version(prefix, version)
      version.delete(prefix).split('.').map(&:to_i)
    end
  end
end
