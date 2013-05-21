name 'services-manager'

default_attributes 'user'              => 'services-manager',
                   'group'             => 'services-manager',
                   'ruby'              => '1.9.3-p374',
                   'project_fqdn'      => 'services-manager.theodi.org',
                   'git_project'       => 'services-manager',
                   'migration_command' => '',
                   'chef_client'       => {
                       'cron' => {
                           'use_cron_d' => true,
                           'hour'       => "*",
                           'minute'     => "*/5",
                           'log_file'   => "/var/log/chef/cron.log"
                       }
                   }

override_attributes 'envbuilder'  => {
                        'base_dir' => '/var/www/services-manager.theodi.org/shared/config',
                        'owner'    => 'services-manager',
                        'group'    => 'services-manager'
                    },
                    'chef_client' => {
                        'interval' => 300,
                        'splay'    => 30
                    },
                    'nginx' => {
                        'static_assets' => false
                    }


run_list "role[base]",
         "recipe[chef-client::cron]",
         "recipe[build-essential]",
         "recipe[nginx]",
         "recipe[odi-users]",
         "recipe[odi-rvm]",
         "recipe[odi-xml]",
         "recipe[odi-nginx]",
         "recipe[xslt]",
         "recipe[libcurl]",
         "recipe[envbuilder]",
         "recipe[odi-simple-deployment]"
