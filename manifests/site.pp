require boxen::environment
require homebrew
require gcc

Exec {
  group       => 'staff',
  logoutput   => on_failure,
  user        => $boxen_user,

  path => [
    "${boxen::config::home}/rbenv/shims",
    "${boxen::config::home}/rbenv/bin",
    "${boxen::config::home}/rbenv/plugins/ruby-build/bin",
    "${boxen::config::home}/homebrew/bin",
    '/usr/bin',
    '/bin',
    '/usr/sbin',
    '/sbin'
  ],

  environment => [
    "HOMEBREW_CACHE=${homebrew::config::cachedir}",
    "HOME=/Users/${::boxen_user}"
  ]
}

File {
  group => 'staff',
  owner => $boxen_user
}

Package {
  provider => homebrew,
  require  => Class['homebrew']
}

Repository {
  provider => git,
  extra    => [
    '--recurse-submodules'
  ],
  require  => File["${boxen::config::bindir}/boxen-git-credential"],
  config   => {
    'credential.helper' => "${boxen::config::bindir}/boxen-git-credential"
  }
}

Service {
  provider => ghlaunchd
}

Homebrew::Formula <| |> -> Package <| |>

node default {
  # core modules, needed for most things
  include dnsmasq
  include git
  include hub
  include nginx

  /*
  # fail if FDE is not enabled
  if $::root_encrypted == 'no' {
    fail('Please enable full disk encryption and try again')
  }
  */
 
  # osx settings
  include osx::global::disable_autocorrect
  include osx::global::expand_save_dialog
  include osx::finder::empty_trash_securely
  include osx::finder::unhide_library
  include osx::software_update
  include osx::disable_app_quarantine
  class { 'osx::global::natural_mouse_scrolling':
    enabled => false
  }
  class { 'osx::dock::icon_size': 
    size => 42
  }

  # node versions
  include nodejs::v0_4
  include nodejs::v0_6
  include nodejs::v0_8
  include nodejs::v0_10

  # default ruby versions
  include ruby::1_8_7
  include ruby::1_9_2
  include ruby::1_9_3
  include ruby::2_0_0
  
  # browsers
  include chrome
  include chrome::canary
  include firefox
  include opera

  # dev tools
  include tower
  include github_for_mac
  include cyberduck
  include sequel_pro
  include virtualbox
  include sublime_text_2

  sublime_text_2::package { 'Emmet':
    source => 'sergeche/emmet-sublime'
  }

  sublime_text_2::package { 'CoffeeScript':
    source => 'Xavura/CoffeeScript-Sublime-Plugin'
  }

  sublime_text_2::package { 'EditorConfig':
    source => 'sindresorhus/editorconfig-sublime'
  }

  sublime_text_2::package { 'laravel-blade':
    source => 'Medalink/laravel-blade'
  }

  sublime_text_2::package { 'trailing_spaces':
    source => 'SublimeText/TrailingSpaces'
  }

  sublime_text_2::package { 'sass-textmate-bundle':
    source => 'nathos/sass-textmate-bundle'
  }

  sublime_text_2::package { 'sublime-text-puppet':
    source => 'eklein/sublime-text-puppet'
  }

  # productivity apps
  include skype
  include openoffice
  include adobe_reader
  include spotify
  include harvest
  include transmission

  include java
  include libpng
  include wget
  include pkgconfig
  include pcre
  include libtool
  include beanstalk
  include foreman
  include heroku
  include imagemagick
  include php::5_4_17
  include php::composer
  include mysql
  include redis

  class { 'php::global':
    version => '5.4.17'
  }

  # common, useful packages
  package {
    [
      'ack',
      'findutils',
      'gnu-tar'
    ]:
  }

  file { "${boxen::config::srcdir}/our-boxen":
    ensure => link,
    target => $boxen::config::repodir
  }
}
