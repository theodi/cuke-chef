name 'memcache'

run_list "role[base]",
         "recipe[odi-memcached]"
