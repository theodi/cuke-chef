@logstash
Feature: Build a logstash node

  In order to run Logstash
  As the ODI
  I want to install and configure Logstash

  Background:
    * I have a server called "logstash-theodi-org-cucumber"
    * "logstash-theodi-org-cucumber" is running "ubuntu" "precise"
    * "logstash-theodi-org-cucumber" should be persistent
    * "logstash-theodi-org-cucumber" has an IP address of "192.168.77.41"


    * the following environment has been uploaded:
      | environment | environment_path |
      | cucumber.rb | ./environments/  |

    * the following roles have been uploaded:
      | role | role_path |
      | *.rb | ./roles/  |

    * "logstash-theodi-org-cucumber" is in the "cucumber" environment
    * "logstash-theodi-org-cucumber" has been provisioned

    * all of the cookbooks in "./cookbooks" have been uploaded
    * all of the cookbooks in "./site-cookbooks" have been uploaded

    * the following databags have been updated:
      | databag          | databag_path                 |
      | envs             | ./data_bags/envs             |

    * the "chef-client::cron" recipe has been added to the "logstash-theodi-org-cucumber" run list
    * the "logstash_server" role has been added to the "logstash-theodi-org-cucumber" run list
    * the chef-client has been run on "logstash-theodi-org-cucumber"

    * I ssh to "logstash-theodi-org-cucumber" with the following credentials:
      | username | keyfile |
      | $lxc$    | $lxc$   |

  Scenario: Can connect to the provisioned server via SSH authentication
    When I run "hostname"
    Then I should see "logstash-theodi-org-cucumber" in the output

  Scenario: java is installed
    When I run "java -version"
    Then I should not see "command not found" in the output

  @ls
  Scenario: logstash is running
    When I run "ps ax | grep logstash"
    Then I should see "logstash" in the output