class projects::huurdit {

	$project_name = 'huurdit'
	$project_dir = "/Users/${::boxen_user}/Sites/${project_name}"

	## Create Apache project running on port 10080
	## Proxy the apache server through nginx on port 80
	apache_php::project { $project_name:
		port 		  => 10080,
		source        => "helloworldlondon/${project_name}",
		dir 		  => $project_dir,
		docroot       => "${project_dir}/public",
		mysql         => $project_name,
		redis         => true,
		php           => '5.4.17',
		nginxproxy	  => true
	}

    exec { "run ${project_name} composer":
		command => '/opt/boxen/phpenv/bin/composer install',
		cwd => "${project_dir}",
		creates => "${project_dir}/vendor",
		require => Apache_php::Project[$project_name],
	}

	exec { "db install ${project_name}":
		command => "/opt/boxen/phpenv/shims/php artisan migrate --env=local && /opt/boxen/phpenv/shims/php artisan db:seed --env=local",
		cwd => "${project_dir}",
		require => Exec["run ${project_name} composer"],
		unless  => "mysql -uroot -p13306 -e 'show tables from ${project_name}' --password='' | grep migrations"
    }

    exec { "add ${project_name} heroku-staging":
    	command => "git remote add staging git@heroku.com:${project_name}-staging.git",
    	cwd => "${project_dir}",
    	unless => 'git remote | grep staging',
    	require => Apache_php::Project[$project_name],
    }

    exec { "run ${project_name} npm install":
		command => '/opt/boxen/nodenv/shims/npm install',
		cwd => "${project_dir}",
		creates => "${project_dir}/node_modules",
		require => Apache_php::Project[$project_name],
	}

    exec { "run ${project_name} bower install":
		command => '/opt/boxen/nodenv/shims/bower install',
		cwd => "${project_dir}",
		creates => "${project_dir}/bower_components",
		require => Apache_php::Project[$project_name],
	}
}
