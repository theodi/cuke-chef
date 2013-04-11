name 'calendar'

default_attributes 'user'              => 'calendar',
                   'group'             => 'calendar',
                   'ruby'              => '1.9.3-p374',
                   'project_fqdn'      => 'calendar.theodi.org',
                   'git_project'       => 'office-calendar',
                   'migration_command' => 'bundle exec rake db:migrate',
                   'chef_client'       => {
                       'cron' => {
                           'use_cron_d' => true,
                           'hour'       => "*",
                           'minute'     => "*/5",
                           'log_file'   => "/var/log/chef/cron.log"
                       }
                   },
                   'cert'              => {
                       'name' => 'googleapps',
                       'file' => 'privatekey.p12'
                   }

override_attributes 'envbuilder'  => {
    'base_dir' => '/var/www/calendar.theodi.org/shared/config',
    'owner'    => 'calendar',
    'group'    => 'calendar'
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
         "recipe[odi-cert-deployer]",
         "recipe[xslt]",
         "recipe[libcurl]",
         "recipe[nodejs::install_from_package]",
         "recipe[mysql::client]",
         "recipe[sqlite::dev]",
         "recipe[envbuilder]",
         "recipe[odi-deployment]",
         "recipe[odi-shim]"
