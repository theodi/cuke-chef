name 'members'

default_attributes 'user' => 'members',
                   'ruby' => '1.9.3-p374'

run_list 'apt',
         'build-essential',
         'git',
         'odi-users',
         'odi-rvm',
         'odi-xml',
         'xslt',
         'libcurl',
         'sqlite::dev',
         'redisio::install',
         'redisio::enable'