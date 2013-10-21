# This file manages Puppet module dependencies.
#
# It works a lot like Bundler. We provide some core modules by
# default. This ensures at least the ability to construct a basic
# environment.

def github(name, version, options = nil)
  options ||= {}
  options[:repo] ||= "boxen/puppet-#{name}"
  mod name, version, :github_tarball => options[:repo]
end

# Includes many of our custom types and providers, as well as global
# config. Required.

github "boxen",      "3.0.2"

# Core modules for a basic development environment. You can replace
# some/most of these if you want, but it's not recommended.

github "autoconf",   "1.0.0"
github "dnsmasq",    "1.0.0"
github "gcc",        "2.0.1"
github "git",        "1.2.5"
github "homebrew",   "1.4.1"
github "hub",        "1.0.3"
github "inifile",    "1.0.0", :repo => "puppetlabs/puppetlabs-inifile"
github "nginx",      "1.4.2"
github "nodejs",     "3.2.10"
github "openssl",    "1.0.0"
github "repository", "2.2.0"
github "ruby",       "6.3.4"
github "stdlib",     "4.1.0", :repo => "puppetlabs/puppetlabs-stdlib"
github "sudo",       "1.0.0"
github "xquartz",    "1.1.0"

# Optional/custom modules. There are tons available at
# https://github.com/boxen.

mod "apache",
  :git => "git://github.com/thomaswelton/puppet-apache.git"


github "chrome"  		   , "1.1.1"
github "firefox" 		   , "1.1.3"
github "opera"             , "0.3.0"

github "zsh"               , "1.0.0"
github "sublime_text_2"	   , "1.1.2"
github "tower"             , "1.0.0"
github "github_for_mac"	   , "1.0.1"
github "cyberduck"		   , "1.0.1"
github "sequel_pro"		   , "1.0.1"
github "divvy"			   , "1.0.1"
github "googledrive"	   , "1.0.2"

github "skype"             , "1.0.6"
github "openoffice"        , "1.2.0"
github "adobe_reader"	   , "1.1.0"
github "spotify"           , "1.0.1"
github "harvest"           , "1.0.2"
github "transmission"      , "1.0.0"
github "virtualbox"		   , "1.0.6"

github "beanstalk"		   , "1.0.0"
github "foreman" 		   , "1.0.0"
github "heroku"            , "2.0.0"
github "imagemagick"       , "1.2.1"
github "mysql"             , "1.1.5"
github "wget"              , "1.0.0"
github "libtool"           , "1.0.0"
github "pkgconfig"         , "1.0.0"
github "pcre"              , "1.0.0"
github "libpng"            , "1.0.0"

github "java"			   , "1.1.2"
github "php"               , "1.1.3"
github "redis"             , "1.0.0"
