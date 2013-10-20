class projects::huurdit {

	include apache

	$project_name = 'huurdit'

	## Create Apache project running on port 10080
	## Proxy the apache server through nginx on port 80
	apache::php::project { $project_name:
		port 		  => 10080,
		source        => "helloworldlondon/${project_name}",
		dir 		  => "/Users/${::boxen_user}/Sites/${project_name}",
		docroot       => "/Users/${::boxen_user}/Sites/${project_name}/public",
		mysql         => $project_name,
		redis         => true,
		php           => '5.4.17',
		nginxproxy	  => true
	}

    exec { "run ${project_name} composer":
		command => '/opt/boxen/phpenv/bin/composer install',
		cwd => "/Users/${::boxen_user}/Sites/${project_name}",
		creates => "/Users/${::boxen_user}/Sites/${project_name}/vendor",
		require => Apache::Php::Project[$project_name],
	}

	exec { "db install ${project_name}":
		command => "/opt/boxen/phpenv/shims/php artisan migrate --env=local && /opt/boxen/phpenv/shims/php artisan db:seed --env=local",
		cwd => "/Users/${::boxen_user}/Sites/${project_name}",
		require => Exec["run ${project_name} composer"],
		unless  => "mysql -uroot -p13306 -e 'show tables from ${project_name}' --password='' | grep migrations"
    }

    exec { "add ${project_name} heroku-staging":
    	command => 'git remote add staging git@heroku.com:${project_name}-staging.git',
    	cwd => "/Users/${::boxen_user}/Sites/${project_name}",
    	unless => 'git remote | grep staging',
    	require => Apache::Php::Project[$project_name],
    }

    exec { "run ${project_name} npm install":
		command => '/opt/boxen/nodenv/shims/npm install',
		cwd => "/Users/${::boxen_user}/Sites/${project_name}",
		creates => "/Users/${::boxen_user}/Sites/${project_name}/node_modules",
		require => Apache::Php::Project[$project_name],
	}

    exec { "run ${project_name} bower install":
		command => '/opt/boxen/nodenv/shims/bower install',
		cwd => "/Users/${::boxen_user}/Sites/${project_name}",
		creates => "/Users/${::boxen_user}/Sites/${project_name}/bower_components",
		require => Apache::Php::Project[$project_name],
	}

}