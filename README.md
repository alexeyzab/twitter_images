# twitter_images

[![Gem Version](https://badge.fury.io/rb/twitter_images.svg)](http://badge.fury.io/rb/twitter_images)
[![Circle CI](https://circleci.com/gh/alexeyzab/twitter_images.svg?style=shield)](https://circleci.com/gh/alexeyzab/twitter_images)
[![Code Climate](https://codeclimate.com/github/alexeyzab/twitter_images/badges/gpa.svg)](https://codeclimate.com/github/alexeyzab/twitter_images)
[![Test Coverage](https://codeclimate.com/github/alexeyzab/twitter_images/badges/coverage.svg)](https://codeclimate.com/github/alexeyzab/twitter_images/coverage)

This is a CLI tool for downloading the most recent images off of Twitter based
on the search terms you provide.

## Roadmap

I've recently started a major overhaul of the gem's structure. However, it's
still a work in progress, and there is a lot I want to add and change.

For the list of possible future changes see the [Trello board](https://trello.com/b/PJXWYp01/twitter-images).

## Installation

Execute this in the terminal:

    $ gem install twitter_images

## Usage

![alt tag](http://i.imgur.com/OrielQo.gif)

After installing the gem you need to run the following command to authorize the
app with Twitter:

`twitter_images -a`

After that, your credentials will be saved in your home directory, inside a
`twitter_imagesrc` file. No need to set up any environment variables anymore.
If you remove the configuration file, you can simply run the command again to
re-authorize the app.

The CLI format is as follows: `twitter_images [path] [search terms] [amount]`

For example:

`twitter_images ./test_pics "#cats" 50`

will download 50 pictures into your ./test_pics directory.

You can search for hashtags and multiple words if you enclose your search terms
in quotes. You can also search for non-hashtags words like so:

`twitter_images ./test_pics friends 150`

Please note that the Twitter API rate limit is 180 calls every 15 minutes.

## Development

After checking out the repo, run `bundle` to install the dependencies.

To install this gem onto your local machine, run `bundle exec rake install`.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
