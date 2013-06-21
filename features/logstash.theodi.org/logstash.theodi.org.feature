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
      | databag | databag_path     |
      | envs    | ./data_bags/envs |

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

  @running
  Scenario: logstash is running
    When I run "ps ax"
    Then I should see "/opt/logstash/server/lib/logstash.jar" in the output

  @es_config
  Scenario: elasticsearch target is correct
    * file "/opt/logstash/server/etc/logstash.conf" should contain
    """
output {
  elasticsearch { host => "192.168.77.40" cluster => "logstash" }

}
    """

  @chef-client
  Scenario: chef-client is cronned
    When I run "cat /etc/cron.d/chef-client"
    Then I should see "/usr/bin/chef-client &> /var/log/chef/cron.log" in the output