# TwitterImages

[![Build Status](https://travis-ci.org/Alehanz/twitter_images.svg?branch=master)](https://travis-ci.org/Alehanz/twitter_images) [![Coverage Status](https://coveralls.io/repos/Alehanz/twitter_images/badge.svg)](https://coveralls.io/r/Alehanz/twitter_images)

This is a CLI tool for downloading the most recent images off of twitter based
on the search terms you provide.

## Installation

Execute this in the terminal:

    $ gem install twitter_images

## Usage

In order to use this gem you have to set up your Twitter credentials.
You can get those at [Twitter app management page](https://apps.twitter.com/).
Create a new app, go to Keys and Access Tokens, generate your Access Token.

Then you can either set up

    CONSUMER_KEY
    CONSUMER_SECRET
    ACCESS_TOKEN
    ACCESS_SECRET

in your .bashrc, .bash_profile, .zshenv or whichever shell config you normally
use or you can just run

    $ twitter_images

and set those up through the command prompts.

After that you'll need to specify an absolute path to the folder you want to
save your images to and specify search terms.

## Development

After checking out the repo, run `bundle` to install dependencies.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/[my-github-username]/twitter_images/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
