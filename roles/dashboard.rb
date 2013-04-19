name 'dashboard'

default_attributes 'user'              => 'dashboard',
                   'group'             => 'dashboard',
                   'ruby'              => '1.9.3-p374',
                   'project_fqdn'      => 'dashboard.theodi.org',
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
                        'base_dir' => '/var/www/dashboard.theodi.org/shared/config',
                        'owner'    => 'dashboard',
                        'group'    => 'dashboard'
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
         "recipe[envbuilder]",
         "recipe[odi-deployment]",
         "recipe[odi-shim]"
