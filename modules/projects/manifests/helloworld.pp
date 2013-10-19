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

    exec { 'run helloworld composer':
		command => '/opt/boxen/phpenv/bin/composer install',
		cwd => "/Users/${::boxen_user}/Sites/helloworld",
		creates => "/Users/${::boxen_user}/Sites/helloworld/vendor",
		require => Php::Project[helloworld],
	}

	exec { "db install helloworld":
		command => "/opt/boxen/phpenv/shims/php artisan migrate --env=local && /opt/boxen/phpenv/shims/php artisan db:seed --env=local",
		cwd => "/Users/${::boxen_user}/Sites/helloworld",
		require => Exec['run helloworld composer'],
		unless  => "mysql -uroot -p13306 -e 'show tables from helloworld' --password='' | grep migrations"
    }

    # Add heroku git remotes
    exec { 'add helloworld heroku-dev':
    	command => 'git remote add dev git@heroku.com:helloworldlondon-dev.git',
    	cwd => "/Users/${::boxen_user}/Sites/helloworld",
    	unless => 'git remote | grep dev',
    	require => Php::Project[helloworld],
    }

    exec { 'add helloworld heroku-staging':
    	command => 'git remote add staging git@heroku.com:helloworldlondon-staging.git',
    	cwd => "/Users/${::boxen_user}/Sites/helloworld",
    	unless => 'git remote | grep staging',
    	require => Php::Project[helloworld],
    }

    exec { 'run helloworld npm install':
		command => '/opt/boxen/nodenv/shims/npm install',
		cwd => "/Users/${::boxen_user}/Sites/helloworld",
		creates => "/Users/${::boxen_user}/Sites/helloworld/node_modules",
		require => Php::Project[helloworld],
	}

    exec { 'run helloworld bower install':
		command => '/opt/boxen/nodenv/shims/bower install',
		cwd => "/Users/${::boxen_user}/Sites/helloworld",
		creates => "/Users/${::boxen_user}/Sites/helloworld/bower_components",
		require => Php::Project[helloworld],
	}

}