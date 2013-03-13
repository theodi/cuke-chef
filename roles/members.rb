name 'members'

default_attributes 'user'              => 'members',
                   'group'             => 'members',
                   'ruby'              => '1.9.3-p374',
                   'project_fqdn'      => 'members.theodi.org',
                   'git_project'       => 'member-directory',
                   'migration_command' => 'bundle exec rake db:migrate:with_data'

override_attributes 'envbuilder'  => {
    'base_dir' => '/var/www/members.theodi.org/shared/config',
    'owner'    => 'members',
    'group'    => 'members'
},
                    'chef_client' => {
                        'interval' => 600
                    }


run_list 'apt',
         'chef-client',
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