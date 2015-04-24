# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'twitter_images/version'

Gem::Specification.new do |spec|
  spec.name          = "twitter_images"
  spec.version       = TwitterImages::VERSION
  spec.authors       = ["Alexey Zabelin"]
  spec.email         = ["zabelin.alex@gmail.com"]

  spec.summary       = %q{A CLI tool that downloads the most recent images from twitter based on the search terms provided}
  spec.description   = %q{A CLI tool that downloads the most recent images from twitter based on the search terms provided. Please remember that you need to provide your own
consumer key and consumer secret as well as the access token and access token secret. You
can find those over here: https://apps.twitter.com Just create a placeholder app
and generate the required credentials.}
  spec.homepage      = "https://github.com/Alehanz/twitter_images"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "https://rubygems.org"
  end

  spec.add_dependency "fileutils", "~> 0.7"
  spec.add_dependency "json", "~> 1.8.2"
  spec.add_dependency "oauth", "~> 0.4.7"
  spec.add_dependency "ruby-progressbar", "~> 1.7.5"

  spec.add_development_dependency "bundler", "~> 1.8"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "coveralls", "~> 0.8.1"
end
