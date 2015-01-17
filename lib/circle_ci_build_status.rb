require "circle_ci_build_status/version"
require "nori"
require "faraday"
require "colorize"

module CircleCiBuildStatus

  class ProjectNotFound < StandardError ; end

  class Build
    def status
      build_status = project_details["Projects"]["Project"]["@lastBuildStatus"]
      activity = project_details["Projects"]["Project"]["@activity"]
      print_status(build_status, activity)
    rescue ProjectNotFound
      print_error
    rescue Faraday::ConnectionFailed
      puts "\nSorry, we failed to get a connection.\n".red
    end

    private

    def build_circle_ci_url
      "https://circleci.com/gh/#{ENV["GITHUB_USER"]}/#{project_name}/tree/#{current_branch}.cc.xml?circle-token=#{ENV["CIRCLE_CI_TOKEN"]}"
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

    def print_status(status, activity)
      if(activity == "Building")
        status = "In progress".blue
      elsif(status == "Success")
        status = status.green
      else
        status = status.red
      end

      puts
      puts "Project: #{project_name.cyan}"
      puts "Branch: #{current_branch.yellow}"
      puts "Build Status: #{status}"
      puts
    end

    def print_error
      puts "\nWe can't seem to find the #{project_name.cyan} project with the branch #{current_branch.yellow} on Circle CI\n\n"
    end
  end
end
