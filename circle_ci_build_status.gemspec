# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'circle_ci_build_status/version'

Gem::Specification.new do |spec|
  spec.name          = "circle_ci_build_status"
  spec.version       = CircleCiBuildStatus::VERSION
  spec.authors       = ["Alex Foster"]
  spec.email         = ["alexjfno1@gmail.com"]
  spec.summary       = %q{A CLI that can quicky print the status of your build in the terminal.}
  spec.description   = %q{A CLI that will get the build status based on your current project and branch name and print it in the terminal.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = ["build"]
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "nori"
  spec.add_dependency "faraday"
  spec.add_dependency "nokogiri"
  spec.add_dependency "colorize"
  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "pry"
end
