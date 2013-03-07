name 'members'

default_attributes 'user' => 'members',
                   'group' => 'members',
                   'ruby' => '1.9.3-p374',
                   'project_fqdn' => 'members.theodi.org',
                   'git_project' => 'member-directory'

run_list 'apt',
         'build-essential',
         'git',
         'odi-users',
         'odi-rvm',
         'odi-xml',
         'xslt',
         'libcurl',
         'nodejs',
         'mysql::client',
         'sqlite::dev',
         'redisio::install',
         'redisio::enable',
         'nginx',
         'odi-deployment'