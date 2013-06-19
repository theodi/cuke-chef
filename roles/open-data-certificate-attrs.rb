name 'open-data-certificate-attrs'

default_attributes "git_project"   => "open-data-certificate",
                   'odi-memcached' => {
                       'memory' => 768
                   }

override_attributes "mysql" => {
    "tunable" => {
        "tmp_table_size" => "256M",
        "query_cache_size" => "32M"
    }
}