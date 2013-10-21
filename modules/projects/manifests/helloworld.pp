class projects::helloworld {

	$project_name = 'helloworld'

	# nginx config
	php::project { $project_name:
		source        => 'git@github.com:helloworldlondon/huurdit.git',
		dir 		  => "/Users/${::boxen_user}/Sites/${project_name}",
		mysql         => $project_name,
		nginx         => "${::boxen_repodir}/modules/projects/templates/shared/nginx.laravel.conf.erb",
		redis         => true,
		php           => '5.4.17',
	}

    exec { "run ${project_name} composer":
		command => '/opt/boxen/phpenv/bin/composer install',
		cwd => "/Users/${::boxen_user}/Sites/${project_name}",
		require => Php::Project[$project_name],
	}

	exec { "db install ${project_name}":
		command => "/opt/boxen/phpenv/shims/php artisan migrate --env=local && /opt/boxen/phpenv/shims/php artisan db:seed --env=local",
		cwd => "/Users/${::boxen_user}/Sites/${project_name}",
		require => Exec["run ${project_name} composer"],
		unless  => "mysql -uroot -p13306 -e 'show tables from ${project_name}' --password='' | grep migrations"
    }

    # Add heroku git remotes
    exec { "add ${project_name} heroku-dev":
    	command => 'git remote add dev git@heroku.com:helloworldlondon-dev.git',
    	cwd => "/Users/${::boxen_user}/Sites/${project_name}",
    	unless => 'git remote | grep dev',
    	require => Php::Project[$project_name],
    }

    exec { "add ${project_name} heroku-staging":
    	command => 'git remote add staging git@heroku.com:helloworldlondon-staging.git',
    	cwd => "/Users/${::boxen_user}/Sites/${project_name}",
    	unless => 'git remote | grep staging',
    	require => Php::Project[$project_name],
    }

    exec { "run ${project_name} npm install":
		command => '/opt/boxen/nodenv/shims/npm install',
		cwd => "/Users/${::boxen_user}/Sites/${project_name}",
		creates => "/Users/${::boxen_user}/Sites/${project_name}/node_modules",
		require => Php::Project[$project_name],
	}

    exec { "run ${project_name} bower install":
		command => '/opt/boxen/nodenv/shims/bower install',
		cwd => "/Users/${::boxen_user}/Sites/${project_name}",
		creates => "/Users/${::boxen_user}/Sites/${project_name}/bower_components",
		require => Php::Project[$project_name],
	}

}