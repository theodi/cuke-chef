@envcookbook
Feature: Construct an environment-dependent, machine-wide .env file

  In order to use canonical env stuff
  As the ODI
  I want to configure a .env file

  Background:
    * I have a server called "env-test"
    * "env-test" is running "ubuntu" "precise"
    * "env-test" should be persistent

    * the following environment has been uploaded:
      | environment | environment_path |
      | vagrant.rb  | ./environments/  |

    * the following roles have been uploaded:
      | role       | role_path |
      | members.rb | ./roles/  |

    * "env-test" is in the "vagrant" environment
    * "env-test" has been provisioned

    * all of the cookbooks in "./cookbooks" have been uploaded
    * all of the cookbooks in "./site-cookbooks" have been uploaded

    * the following databags have been updated:
      | databag | databag_path     |
      | envs    | ./data_bags/envs |

    * the "chef-client::service" recipe has been added to the "env-test" run list
    * the "envbuilder" recipe has been added to the "env-test" run list
    * the chef-client has been run on "env-test"

    * I ssh to "env-test" with the following credentials:
      | username | keyfile |
      | $lxc$    | $lxc$   |

  Scenario: Can connect to the provisioned server via SSH authentication
    When I run "hostname"
    Then I should see "env-test" in the output

  Scenario: The env file exists
    * file "/home/env/env" should exist

  Scenario: The env file contains the correct stuff
    When I run "cat /home/env/env"
    Then I should see "JENKINS_URL: http://jenkins.theodi.org" in the output
    And I should not see "CONTENT_" in the output
    And I should see "RESQUE_REDIS_HOST: localhost" in the output
    And I should see "LEFTRONIC_GITHUB_OUTGOING_PRS: d" in the output
    And I should see "COURSES_TARGET_URL: http://151" in the output
    And I should see "TRELLO_DEV_KEY: a1" in the output
    And I should see "GITHUB_OUATH_TOKEN: 18" in the output
    And I should not see "GOOGLE_ANALYTICS_TRACKER" in the output

