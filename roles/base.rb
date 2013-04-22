name 'base'

run_list "recipe[apt]",
         "recipe[odi-chef-client::config]",
         "recipe[git]",
         "recipe[postfix]",
         "recipe[ntp]",
         "recipe[odi-pk]"