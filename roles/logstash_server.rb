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

#                    'logstash'    => {
#                        'kibana' => {
#                            'http_port' => 8080
#                        }
#                    }

run_list 'role[base]',
         #         'recipe[java]',
         'recipe[odi-logstash::server]'
#         'recipe[logstash::kibana]'