name 'memcached'

run_list "role[base]",
         "recipe[odi-memcached]"
