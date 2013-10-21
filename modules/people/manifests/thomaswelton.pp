class people::thomaswelton {

  # projects
  include projects::laravel
  include projects::huurdit
  include projects::givemeabreak
  include projects::helloworld

  include zsh

  $home     = "/Users/${::boxen_user}"

  # dotfiles
  repository { "${home}/.dotfiles":
    source => 'thomaswelton/dotfiles'
  }

  ######################
  # Install and register
  # Sublime Text 2
  ######################

  include sublime_text_2

  $st2_key_gist = 'https://gist.github.com/622d203c506e306de300.git'
  $st2_key_dir  = "${home}/tmp/sub_key"

  repository { $st2_key_dir:
    source => $st2_key_gist
  }

  file { "${home}/Library/Application Support/Sublime Text 2/Settings/License.sublime_license":
    ensure  => present,
    source => "${st2_key_dir}/key",
    require => Repository[$st2_key_dir]
  }
}
