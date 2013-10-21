class projects::laravel {

	$project_name = 'laravel'
	$project_dir = "/Users/${::boxen_user}/Sites/${project_name}"

	php::project { $project_name:
		source        => "thomaswelton/${project_name}",
		dir 		  => "/Users/${::boxen_user}/Sites/${project_name}",
		mysql         => $project_name,
		nginx         => "${::boxen_repodir}/modules/projects/templates/shared/nginx.laravel.conf.erb",
		redis         => true,
		php           => '5.4.17',
	}

    exec { "run ${project_name} composer":
		command => '/opt/boxen/phpenv/bin/composer install',
		cwd => "${project_dir}",
		creates => "${project_dir}/vendor",
		require => Php::Project[$project_name],
	}

	exec { "db install ${project_name}":
		command => "/opt/boxen/phpenv/shims/php artisan migrate --env=local && /opt/boxen/phpenv/shims/php artisan db:seed --env=local",
		cwd => "${project_dir}",
		require => Exec["run ${project_name} composer"],
		unless  => "mysql -uroot -p13306 -e 'show tables from ${project_name}' --password='' | grep migrations"
    }

    exec { "run ${project_name} npm install":
		command => '/opt/boxen/nodenv/shims/npm install',
		cwd => "${project_dir}",
		creates => "${project_dir}/node_modules",
		require => Php::Project[$project_name],
	}

    exec { "run ${project_name} bower install":
		command => '/opt/boxen/nodenv/shims/bower install',
		cwd => "${project_dir}",
		creates => "${project_dir}/bower_components",
		require => Php::Project[$project_name],
	}

}
