name 'odi-drupal'

# default_attributes

override_attributes 'chef_client' => {
    'interval' => 0,
    'splay'    => 30
},
                    'php'         => {
                        'ini_settings' => {
                            'memory_limit' => '128M'
                        }
                    }

run_list "role[base]",
         "recipe[apache2::mod_php5]",
         "recipe[apache2::mod_rewrite]",
         "recipe[php::apache2]",
         "recipe[php::module_gd]",
         "recipe[php::module_mysql]",
         "recipe[odi-php-memcached]",
         "recipe[memcached]",
         "recipe[git]",
         "recipe[postfix]",
         "recipe[drush]",
         "recipe[odi-website-deploy]",
         "recipe[odi-fileconveyor]"