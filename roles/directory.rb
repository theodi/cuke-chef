name 'directory'

default_attributes 'user'              => 'directory',
                   'group'             => 'directory',
                   'ruby'              => '1.9.3-p374',
                   'project_fqdn'      => 'directory.theodi.org',
                   'git_project'       => 'member-directory',
                   'migration_command' => 'bundle exec rake db:migrate data:migrate',
                   '301_redirects'     => [
                       'members.theodi.org'
                   ],
                   'chef_client' => {
                       'cron' => {
                           'use_cron_d' => true,
                           'hour' => "*",
                           'minute' => "*/5",
                           'log_file' => "/var/log/chef/cron.log"
                       }
                   }

override_attributes 'envbuilder'  => {
    'base_dir' => '/var/www/directory.theodi.org/shared/config',
    'owner'    => 'directory',
    'group'    => 'directory'
},
                    'chef_client' => {
                        'interval' => 300,
                        'splay'    => 30
                    }


run_list "role[base]",
         "recipe[chef-client::cron]",
         "recipe[build-essential]",
         "recipe[imagemagick]",
         "recipe[nginx]",
         "recipe[odi-users]",
         "recipe[odi-rvm]",
         "recipe[odi-xml]",
         "recipe[odi-nginx]",
         "recipe[xslt]",
         "recipe[libcurl]",
         "recipe[nodejs::install_from_package]",
         "recipe[mysql::client]",
         "recipe[sqlite::dev]",
         #         "recipe[redisio::install]",
         #         "recipe[redisio::enable]",
         "recipe[redis]",
         "recipe[envbuilder]",
         "recipe[odi-deployment]",
         "recipe[odi-shim]"
