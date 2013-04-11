name 'squirrel'

run_list "role[base]",
         "recipe[odi-mysql::server]"