provider                        :vagrant
librarian_chef                  true
artifacts                       ({ "chef-client-log" => "/var/log/chef/client.log",
                                   "chef-client-stacktrace" => "/var/chef/cache/chef-stacktrace.out" })
vagrant.merge!(                 :identity_file => "#{ENV['HOME']}/.vagrant.d/insecure_private_key",
                                :lab_user => "vagrant",
                                :lxc_user => "root" )
