name 'squirrel'

run_list "role[base]",
         "recipe[envbuilder]",
         "recipe[odi-mysql::server]",
         "recipe[hoppler]"