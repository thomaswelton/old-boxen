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

  # node versions
  include nodejs::v0_10_18

  class { 'nodejs::global': version => 'v0.10.18' }

  nodejs::module { 'bower':
    node_version => 'v0.10.18'
  }

  nodejs::module { 'grunt-cli':
    node_version => 'v0.10.18'
  }

  # default ruby versions
  include ruby::2_0_0

  class { 'ruby::global':
    version => '2.0.0'
  }

  ruby::gem { "bundler for 2.0.0":
    gem     => 'bundler',
    ruby    => '2.0.0'
  }
  ruby::gem { "compass for 2.0.0":
    gem     => 'compass',
    ruby    => '2.0.0'
  }
  
  # browsers
  include chrome
  include chrome::canary
  include firefox
  include opera

  # dev tools
  include tower

  exec { 'gittower command line tools':
    command => 'ln -s /Applications/Tower.app/Contents/MacOS/gittower /opt/boxen/bin/gittower',
    creates => '/opt/boxen/bin/gittower',
  }

  include github_for_mac
  include cyberduck
  include sequel_pro
  include virtualbox
  include sublime_text_2

  # productivity apps
  include skype
  include openoffice
  include adobe_reader
  include spotify
  include harvest
  include transmission

  package { 'CreatveCloudInstaller':
    ensure   => installed,
    source   => 'https://ccmdls.adobe.com/AdobeProducts/PHSP/14/osx10/AAMmetadataLS20/CreativeCloudInstaller.dmg',
    provider => appdmg,
  }

  package { 'LiveReload':
    ensure   => installed,
    source   => 'http://download.livereload.com/LiveReload-2.3.26.zip',
    provider => compressed_app,
  }

  include java
  include libpng
  include wget
  include pkgconfig
  include pcre
  include libtool
  include beanstalk
  include foreman
  include imagemagick
  include php::5_4_17
  include php::composer
  include mysql
  include redis
  include heroku

  heroku::plugin { 'pipeline':
    source => 'heroku/heroku-pipeline'
  }

  heroku::plugin { 'push':
    source => 'ddollar/heroku-push'
  }

  heroku::plugin { 'accounts':
    source => 'ddollar/heroku-accounts'
  }

  heroku::plugin { 'dashboard':
    source => 'ddollar/heroku-dashboard'
  }

  heroku::plugin { 'redis-cli':
    source => 'ddollar/heroku-redis-cli'
  }

  class { 'php::global':
    version => '5.4.17'
  }

  php::extension::mcrypt { 'mcrypt for 5.4.17':
    php => '5.4.17'
  }

  # common, useful packages
  package {
    [
      'ack',
      'findutils',
      'gnu-tar'
    ]:
  }

  # sublime text packages
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

  sublime_text_2::package { 'sublime_alignment':
    source => 'wbond/sublime_alignment'
  }

  sublime_text_2::package { 'SublimeHTMLMustache':
    source => 'adamchainz/SublimeHTMLMustache'
  }

  sublime_text_2::package { 'TrailingSpaces':
    source => 'SublimeText/TrailingSpaces'
  }

  sublime_text_2::package { 'SideBarEnhancements':
    source => 'titoBouzout/SideBarEnhancements'
  }

  sublime_text_2::package { 'SublimeLinter':
    source => 'SublimeLinter/SublimeLinter'
  }

  sublime_text_2::package { 'dotfiles-syntax-highlighting-st2':
    source => 'mattbanks/dotfiles-syntax-highlighting-st2'
  }
}
