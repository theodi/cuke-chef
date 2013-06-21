name 'logstash_server'

override_attributes 'chef_client' => {
    'cron' => {
        'use_cron_d' => true,
        'hour'       => "*",
        'minute'     => "*/5",
        'log_file'   => "/var/log/chef/cron.log"
    }
},
                    'logstash'    => {
                        'server'              => {
                            'enable_embedded_es' => false
                        },
                        'elasticsearch_query' => nil,
                        'elasticsearch_role'  => nil
                    }

run_list 'role[base]',
         "recipe[chef-client::cron]",
         'recipe[odi-logstash::server]'
