require "circle_ci_build_status/version"
require "nori"
require "faraday"
require "colorize"

module CircleCiBuildStatus

  class ProjectNotFound < StandardError ; end

  class Build
    def status
      print_status(project_details["Projects"]["Project"]["@lastBuildStatus"])
    rescue ProjectNotFound
      print_error
    end

    private

    def build_circle_ci_url
      "https://circleci.com/gh/bskyb-commerce/#{project_name}/tree/#{current_branch}.cc.xml?circle-token=#{ENV["CIRCLE_CI_TOKEN"]}"
    end

    def project_details
      response = ::Faraday.get(build_circle_ci_url)
      raise ProjectNotFound if response.status == 404
      ::Nori.new.parse(response.body)
    end

    def project_name
      Dir.pwd =~ /.*\/(.*?)$/ ; $1
    end

    def current_branch
      (`git rev-parse --abbrev-ref HEAD`).strip
    end

    def print_status(status)
      puts
      puts "Project: " + project_name.cyan
      puts "Branch: " + current_branch.yellow
      puts "Build Status: " + status.green
      puts
    end

    def print_error
      puts "\nWe can't seem to find the " + "#{project_name}".cyan + " project with the branch " + "#{current_branch}".yellow + " on Circle CI\n\n"
    end
  end
end
