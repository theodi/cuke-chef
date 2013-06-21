@kibana
Feature: Build a kibana node

  In order to run Logstash
  As the ODI
  I want to install and configure kibana

  Background:
    * I have a server called "kibana-theodi-org-cucumber"
    * "kibana-theodi-org-cucumber" is running "ubuntu" "precise"
    * "kibana-theodi-org-cucumber" should be persistent
    * "kibana-theodi-org-cucumber" has an IP address of "192.168.77.42"


    * the following environment has been uploaded:
      | environment | environment_path |
      | cucumber.rb | ./environments/  |

    * the following roles have been uploaded:
      | role | role_path |
      | *.rb | ./roles/  |

    * "kibana-theodi-org-cucumber" is in the "cucumber" environment
    * "kibana-theodi-org-cucumber" has been provisioned

    * all of the cookbooks in "./cookbooks" have been uploaded
    * all of the cookbooks in "./site-cookbooks" have been uploaded

    * the following databags have been updated:
      | databag          | databag_path                 |
      | envs             | ./data_bags/envs             |

    * the "kibana" role has been added to the "kibana-theodi-org-cucumber" run list
    * the chef-client has been run on "kibana-theodi-org-cucumber"

    * I ssh to "kibana-theodi-org-cucumber" with the following credentials:
      | username | keyfile |
      | $lxc$    | $lxc$   |

  Scenario: Can connect to the provisioned server via SSH authentication
    When I run "hostname"
    Then I should see "kibana-theodi-org-cucumber" in the output

  @config
  Scenario: config is correct
     * file "/opt/kibana/KibanaConfig.rb" should contain
    """
    Elasticsearch = ["192.168.77.40:9200"]
    """
    And file "/opt/kibana/KibanaConfig.rb" should contain
    """
    KibanaHost = '192.168.77.42'
    """
#    And file "/opt/kibana/KibanaConfig.rb" should contain
#    """
#    Time_format = 'isoDateTime'
#    """

  @apache
  Scenario: apache vhost exists
    * symlink "/etc/apache2/sites-enabled/kibana" should exist

  @chef-client
  Scenario: chef-client is cronned
    When I run "cat /etc/cron.d/chef-client"
    Then I should see "/usr/bin/chef-client &> /var/log/chef/cron.log" in the output

