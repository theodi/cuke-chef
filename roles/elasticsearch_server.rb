name 'elasticsearch_server'

default_attributes 'elasticsearch' => {
    'cluster_name' => 'logstash',
    'mlockall'     => false
}

override_attributes 'chef_client' => {
    'cron' => {
        'use_cron_d' => true,
        'hour'       => "*",
        'minute'     => "*/5",
        'log_file'   => "/var/log/chef/cron.log"
    }
}

run_list "role[base]",
         "recipe[java]",
         "recipe[elasticsearch]"
