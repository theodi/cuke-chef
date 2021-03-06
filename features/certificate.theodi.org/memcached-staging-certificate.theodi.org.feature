@staging-memcached-certificate-theodi-org-cucumber
Feature: Build a functioning memcached server

  In order to cache things across multiple nodes
  As the ODI
  I want to install and configure memcache

  Background:
    * I have a server called "staging-memcached-certificate-theodi-org-cucumber"
    * "staging-memcached-certificate-theodi-org-cucumber" is running "ubuntu" "precise"
    * "staging-memcached-certificate-theodi-org-cucumber" should be persistent
    * "staging-memcached-certificate-theodi-org-cucumber" has an IP address of "192.168.87.50"

    * the following environment has been uploaded:
      | environment | environment_path |
      | cucumber.rb | ./environments/  |

    * the following roles have been uploaded:
      | role | role_path |
      | *.rb | ./roles/  |

    * "staging-memcached-certificate-theodi-org-cucumber" is in the "cucumber-staging" environment
    * "staging-memcached-certificate-theodi-org-cucumber" has been provisioned

    * all of the cookbooks in "./cookbooks" have been uploaded
    * all of the cookbooks in "./site-cookbooks" have been uploaded

    * the "open-data-certificate-attrs" role has been added to the "staging-memcached-certificate-theodi-org-cucumber" run list
    * the "memcached" role has been added to the "staging-memcached-certificate-theodi-org-cucumber" run list
    * the chef-client has been run on "staging-memcached-certificate-theodi-org-cucumber"

    * I ssh to "staging-memcached-certificate-theodi-org-cucumber" with the following credentials:
      | username | keyfile |
      | $lxc$    | $lxc$   |

  @connect
  Scenario: Can connect to the provisioned server via SSH authentication
    When I run "hostname"
    Then I should see "staging-memcached-certificate-theodi-org-cucumber" in the output

  Scenario: memcached is installed
    * package "memcached" should be installed

  Scenario: Can connect to memcached server
    When I run "echo stats | nc 192.168.87.50 11211"
    Then I should see "STAT" in the output
    
  Scenario: Has allocated 768MB of memory memcached server
    When I run "echo stats | nc 192.168.87.50 11211"
    Then I should see "STAT limit_maxbytes 805306368" in the output