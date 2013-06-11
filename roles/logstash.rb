name 'logstash'

override_attributes 'chef_client' => {
    'cron' => {
        'use_cron_d' => true,
        'hour'       => "*",
        'minute'     => "*/5",
        'log_file'   => "/var/log/chef/cron.log"
    }
},
                    'logstash'    => {
                        'elasticsearch_role'    => 'elasticsearch',
                        'elasticsearch_cluster' => 'logstash',
                        'server'                => {
                            'enable_embedded_es' => false
                        }
                    }

run_list 'role[base]',
         'recipe[java]',
         'recipe[logstash::server]'