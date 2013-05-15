@memcache
Feature: Build a functioning Memcache server

  In order to cache things across multiple nodes
  As the ODI
  I want to install and configure Memcache

  Background:
    * I have a server called "memcache"
    * "memcache" is running "ubuntu" "precise"
    * "memcache" should be persistent
    * "memcache" has an IP address of "192.168.77.42"

    * the following environment has been uploaded:
      | environment | environment_path |
      | cucumber.rb | ./environments/  |

    * the following roles have been uploaded:
      | role | role_path |
      | *.rb | ./roles/  |

    * "memcache" is in the "cucumber" environment
    * "memcache" has been provisioned

    * all of the cookbooks in "./cookbooks" have been uploaded
    * all of the cookbooks in "./site-cookbooks" have been uploaded

    * the "chef-client::cron" recipe has been added to the "memcache" run list
    * the "memcache" role has been added to the "memcache" run list
    * the chef-client has been run on "memcache"

    * I ssh to "memcache" with the following credentials:
      | username | keyfile |
      | $lxc$    | $lxc$   |

  Scenario: Can connect to the provisioned server via SSH authentication
    When I run "hostname"
    Then I should see "memcache" in the output

  Scenario: Memcached is installed
    * package "memcached" should be installed

  Scenario: Can connect to memcache server
    When I run "echo STATS | nc 192.168.77.42 11211"
    Then I should see "STAT" in the output
    
  Scenario: Has allocated 768MB of memory memcache server
    When I run "echo stats | nc 192.168.77.42 11211"
    Then I should see "STAT limit_maxbytes 805306368" in the output