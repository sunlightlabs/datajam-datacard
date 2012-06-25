# Datacard

[![Build Status](https://secure.travis-ci.org/sunlightlabs/datajam-datacard.png)](http://travis-ci.org/sunlightlabs/datajam-datacard)

Stats & data visualization engine for [Datajam](http://github.com/sunlightlabs/datajam).

## Installation

Install engine using rubygems:

    $ gem install datajam-datacard
    
Or simply add it to your `Gemfile`:

    gem 'datajam-datacard', :require => 'datajam/datacard'
    
## Development

To start working on a project clone the repo and bundle all the dependencies:

    $ git clone git://github.com/sunlightlabs/datajam-datacard.git
    $ git submodule init && git submodule update
    $ cd datajam-datacard
    $ bundle install
    
Unit tests run with `spec` rake task (which is default):

    $ rake spec
    
Original [datajam](https://github.com/sunlightlabs/datajam) app is used for
testing and it's submoduled in `spec/datajam`. You can run it normally with
`rackup` command:

    $ bundle exec rackup -p 3000
    
## Development guidelines

Conventions are the same as in [Datajam](http://github.com/sunlightlabs/datajam)
project - you can find all necessary information in its `README` file.

## License

TODO...
