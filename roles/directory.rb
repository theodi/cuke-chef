name 'directory'

default_attributes 'user'              => 'directory',
                   'group'             => 'directory',
                   'ruby'              => '1.9.3-p374',
                   'project_fqdn'      => 'directory.theodi.org',
                   'git_project'       => 'member-directory',
                   'migration_command' => 'bundle exec rake db:migrate:with_data'

override_attributes 'envbuilder'  => {
    'base_dir' => '/var/www/directory.theodi.org/shared/config',
    'owner'    => 'directory',
    'group'    => 'directory'
},
                    'chef_client' => {
                        'interval' => 1800,
                        'splay'    => 300
                        'interval' => 300,
                         'splay'     => 30
                    }


run_list 'apt',
         'chef-client',
         'chef-client::config',
         'build-essential',
         'git',
         'imagemagick',
         'nginx',
         'odi-users',
         'odi-rvm',
         'odi-xml',
         'odi-nginx',
         'xslt',
         'libcurl',
         'nodejs',
         'mysql::client',
         'sqlite::dev',
         'redisio::install',
         'redisio::enable',
         'envbuilder',
         'odi-deployment'