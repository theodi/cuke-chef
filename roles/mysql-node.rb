name 'mysql-node'

default_attributes 'user'  => 'hoppler',
                   'group' => 'hoppler',
                   'ruby'  => '2.0.0-p0'

override_attributes "envbuilder" => {
    "base_dir" => "/home/hoppler/",
    "filename" => ".env",
    "owner"    => "hoppler",
    "group"    => "hoppler"
}

run_list "role[base]",
         "recipe[odi-mysql::server]",
         "recipe[hoppler]"
#         "recipe[envbuilder]"
