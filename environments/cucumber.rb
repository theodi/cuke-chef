name 'cucumber'

default_attributes 'ENV'      => 'production',
                   'RACK_ENV' => 'production'
#                   'chef_client' => {
#                       'conf_dir' => '/tmp'
#                   }


#override_attributes #'user'        => 'vagrant',
                    #'group'       => 'vagrant',
                    #'envbuilder'  => {
                    #    'owner'    => 'vagrant',
                    #    'group'    => 'vagrant',
                    #    'base_dir' => '/home/env/'
                    #},
override_attributes                     'chef_client'       => {
                        'cron' => {
                            'use_cron_d' => true,
                            'hour'       => "0",
                            'minute'     => "0",
                            'log_file'   => "/var/log/chef/cron.log"
                        }
                    }

cookbook 'apt', '= 1.9.0'
#cookbook 'build-essential', '= 1.3.4'
#cookbook 'envbuilder', '= 0.1.5'
#cookbook 'git', '= 2.3.0'
cookbook 'imagemagick', '= 0.2.2'
cookbook 'libcurl', '= 0.1.0'
#cookbook 'mysql', '= 2.1.2'
#cookbook 'nginx', '= 1.4.0'
#cookbook 'nodejs', '= 1.1.1'
#cookbook 'odi-deployment', '= 0.1.2'
cookbook 'odi-nginx', '= 0.1.3'
cookbook 'odi-rvm', '= 0.1.0'
cookbook 'odi-users', '= 0.1.0'
cookbook 'odi-xml', '= 0.1.0'
cookbook 'odi-memcached', '= 0.1.0'
cookbook 'redisio', '= 1.4.1'
cookbook 'rvm', '= 0.0.2'
cookbook 'sqlite', '= 0.1.0'
cookbook 'xslt', '= 0.0.1'
#cookbook 'odi-cert-deployer', '= 0.1.0'
