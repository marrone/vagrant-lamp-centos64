class pch(
	$root_pwd,
	$dbname,
	$dbuser,
	$dbpassword,
	$app_folder
)
{
	service {
		'iptables':
			ensure => stopped,
			enable => false
			;
	}

	package{
		[
			'vim-enhanced',
			'screen',
			'git',
            'curl'
		]:
			ensure => present,
			require => Yumrepo['epel']
			;
	}

	yumrepo {
	    'epel':
	        descr       => 'Extra Packages for Enterprise Linux 6 - $basearch',
	        enabled     => "1",
	        gpgcheck    => "1",
	        failovermethod => 'priority',
	        gpgkey      => "http://download.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-6",
	        mirrorlist  => 'https://mirrors.fedoraproject.org/metalink?repo=epel-6&arch=$basearch'
	        ;
	}

	class { '::apache': 
        default_vhost => false
    }
	apache::vhost { "local.pch":
		port    => '80',
		docroot => "/var/www/$app_folder",
		directories => [
			{ 
                path => "/var/www/$app_folder", 
                order => 'Allow,Deny', 
                allow => 'from all', 
                allow_override => ['All'],
                options => ["Indexes","FollowSymLinks"]
            }
		],
        priority => '1',
	}
	apache::vhost { "blackjack.local.dev.pch.com":
		port    => '80',
        servername => "blackjack.local.dev.pch.com",
		docroot => "/var/www/$app_folder/blackjack/trunk/website",
		directories => [
			{ 
                path => "/var/www/$app_folder/blackjack/trunk/website", 
                directoryindex => "index.php index.html",
                order => 'Allow,Deny', 
                allow => 'from all', 
                allow_override => ['All']
            }
		],
	}
	class { 'php': }
	class {
		'mysql':
			root_pwd => $root_pwd,
			dev_db_name => $dbname,
			dev_db_user => $dbuser,
			dev_db_pwd => $dbpassword
			;
	}
	file {
		"/var/www/$app_folder":
			ensure => link,
			target => '/vagrant_projects',
			require => Class['::apache']
			;
	}
}
