class projects::helloworld {

	# nginx config
	php::project { 'helloworld':
		source        => 'helloworldlondon/helloworld',
		dir 		  => "/Users/${::boxen_user}/Sites/helloworld",
		mysql         => 'helloworld',
		nginx         => "${::boxen_repodir}/modules/projects/templates/shared/nginx.laravel.conf.erb",
		redis         => true,
		php           => '5.4.17',
	}

	# Add heroku git remotes
	exec { 'add helloworld heroku-dev':
		command => 'git remote add dev git@heroku.com:helloworldlondon-dev.git',
		cwd => "/Users/${::boxen_user}/Sites/helloworld",
		unless => 'git remote | grep dev',
	}

	exec { 'add helloworld heroku-staging':
		command => 'git remote add staging git@heroku.com:helloworldlondon-staging.git',
		cwd => "/Users/${::boxen_user}/Sites/helloworld",
		unless => 'git remote | grep staging',
	}

	# Run composer on first install if vendor dir not found
	if ! defined(File["/Users/${::boxen_user}/Sites/helloworld/vendor"]) {
	    exec { 'run helloworld composer':
			command => '/opt/boxen/phpenv/bin/composer install',
			cwd => "/Users/${::boxen_user}/Sites/helloworld"
		}
	}

	# Run npm install on first install if node_modules dir not found
	if ! defined(File["/Users/${::boxen_user}/Sites/helloworld/node_modules"]) {
	    exec { 'run helloworld npm install':
			command => '/opt/boxen/nodenv/shims/npm install',
			cwd => "/Users/${::boxen_user}/Sites/helloworld"
		}
	}

	# Run bower install on first install if bower_components dir not found
	if ! defined(File["/Users/${::boxen_user}/Sites/helloworld/bower_components"]) {
	    exec { 'run helloworld bower install':
			command => '/opt/boxen/nodenv/shims/bower install',
			cwd => "/Users/${::boxen_user}/Sites/helloworld"
		}
	}
}