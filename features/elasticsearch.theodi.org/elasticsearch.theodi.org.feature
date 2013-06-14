@elasticsearch
Feature: Build an elasticsearch node

  In order to support Logstash
  As the ODI
  I want to install and configure Elasticsearch

  Background:
    * I have a server called "elasticsearch-theodi-org-cucumber"
    * "elasticsearch-theodi-org-cucumber" is running "ubuntu" "precise"
    * "elasticsearch-theodi-org-cucumber" should be persistent
    * "elasticsearch-theodi-org-cucumber" has an IP address of "192.168.77.40"


    * the following environment has been uploaded:
      | environment | environment_path |
      | cucumber.rb | ./environments/  |

    * the following roles have been uploaded:
      | role | role_path |
      | *.rb | ./roles/  |

    * "elasticsearch-theodi-org-cucumber" is in the "cucumber" environment
    * "elasticsearch-theodi-org-cucumber" has been provisioned

    * all of the cookbooks in "./cookbooks" have been uploaded
    * all of the cookbooks in "./site-cookbooks" have been uploaded

    * the following databags have been updated:
      | databag          | databag_path                 |
      | envs             | ./data_bags/envs             |

    * the "chef-client::cron" recipe has been added to the "elasticsearch-theodi-org-cucumber" run list
    * the "elasticsearch_server" role has been added to the "elasticsearch-theodi-org-cucumber" run list
    * the chef-client has been run on "elasticsearch-theodi-org-cucumber"

    * I ssh to "elasticsearch-theodi-org-cucumber" with the following credentials:
      | username | keyfile |
      | $lxc$    | $lxc$   |

  Scenario: Can connect to the provisioned server via SSH authentication
    When I run "hostname"
    Then I should see "elasticsearch-theodi-org-cucumber" in the output

  Scenario: java is installed
    When I run "java -version"
    Then I should not see "command not found" in the output

  @es
  Scenario: elasticsearch is installed and running
    When I run "service elasticsearch status --verbose"
    Then I should not see "unrecognized service" in the output

