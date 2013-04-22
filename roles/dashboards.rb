name 'dashboards'

default_attributes 'user'              => 'dashboards',
                   'group'             => 'dashboards',
                   'ruby'              => '1.9.3-p374',
                   'project_fqdn'      => 'dashboards.theodi.org',
                   'git_project'       => 'dashboards',
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
                        'base_dir' => '/var/www/dashboards.theodi.org/shared/config',
                        'owner'    => 'dashboards',
                        'group'    => 'dashboards'
                    },
                    'chef_client' => {
                        'interval' => 300,
                        'splay'    => 30
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
         "recipe[nodejs::install_from_package]",
         "recipe[sqlite::dev]",
         "recipe[odi-simple-deployment]",
         "recipe[odi-shim]"
