name 'logstash_server'

override_attributes 'chef_client' => {
    'cron' => {
        'use_cron_d' => true,
        'hour'       => "*",
        'minute'     => "*/5",
        'log_file'   => "/var/log/chef/cron.log"
    }
}

run_list 'role[base]',
         'recipe[java]',
         'recipe[logstash::server]',
         'recipe[logstash::kibana]'