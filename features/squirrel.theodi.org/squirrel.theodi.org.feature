@drupal-mysql-server
Feature: Build a functioning MySQL server

  In order to run database stuff
  As the ODI
  I want to install and configure MySQL

  Background:
    * I have a server called "drupal-mysql-server"
    * "drupal-mysql-server" is running "ubuntu" "precise"
    * "drupal-mysql-server" should be persistent
    * "drupal-mysql-server" has an IP address of "192.168.77.20"

    * the following environment has been uploaded:
      | environment | environment_path |
      | cucumber.rb | ./environments/  |

    * the following roles have been uploaded:
      | role | role_path |
      | *.rb | ./roles/  |

    * the following databags have been updated:
      | databag   | databag_path          |
      | databases | ./data_bags/databases |
      | envs      | ./data_bags/envs      |

    * "drupal-mysql-server" is in the "cucumber" environment
    * "drupal-mysql-server" has been provisioned

    * all of the cookbooks in "./cookbooks" have been uploaded
    * all of the cookbooks in "./site-cookbooks" have been uploaded

    * the "chef-client::cron" recipe has been added to the "drupal-mysql-server" run list
    * the "squirrel" role has been added to the "drupal-mysql-server" run list
    * the chef-client has been run on "drupal-mysql-server"

    * I ssh to "drupal-mysql-server" with the following credentials:
      | username | keyfile |
      | $lxc$    | $lxc$   |

  Scenario: Can connect to the provisioned server via SSH authentication
    When I run "hostname"
    Then I should see "drupal-mysql-server" in the output

  Scenario: MySQL is installed
    * package "mysql-server" should be installed

  Scenario: Can connect to database server
    When I run "mysql -ppasswordallthethings -e 'show databases'"
    Then I should not see "ERROR" in the output

  @restore
  Scenario: Database "theodi_org" exists
    When I run "mysql -ppasswordallthethings -e 'show databases'"
    Then I should see "theodi_org" in the output

  @user
  Scenario: hoppler user exists
    When I run "su - hoppler -c 'echo ${SHELL}'"
    Then I should see "/bin/bash" in the output

  @user
  Scenario: hoppler user has ruby 2
    When I run "su - hoppler -c 'ruby -v'"
    Then I should see "2.0.0" in the output

  @code
  Scenario: Hoppler is installed and cronned
    * path "/home/hoppler/hoppler" should exist
    * file "/home/hoppler/hoppler/lib/hoppler.rb" should exist
    * file "/etc/cron.d/hoppler" should contain
    """
    0 2 * * * hoppler cd /home/hoppler/hoppler && rake hoppler:backup
    0 3 * * 7 hoppler cd /home/hoppler/hoppler && rake hoppler:cleanup
    """

  @creds
  Scenario: passwords yaml file exists
    * file "/home/hoppler/hoppler/db.creds.yaml" should exist
    When I run "cat /home/hoppler/hoppler/db.creds.yaml"
    Then I should see "^theodi_org:" in the output

  @envfile
  Scenario: ~/.mysql.env is correct
    * file "/home/hoppler/hoppler/.mysql.env" should be owned by "hoppler:hoppler"
    * file "/home/hoppler/hoppler/.mysql.env" should contain
    """
    MYSQL_USERNAME='root'
    MYSQL_PASSWORD='passwordallthethings'
    """
    * symlink "/home/hoppler/hoppler/.env" should exist
    When I run "cat /home/hoppler/hoppler/.env"
    Then I should see "RACKSPACE_USERNAME: rax" in the output
    And I should see "RACKSPACE_API_KEY: 567" in the output
    And I should see "RACKSPACE_CONTAINER: dat" in the output
    And I should see "RACKSPACE_DIRECTORY_CONTAINER: theo" in the output
    And I should see "RACKSPACE_DIRECTORY_ASSET_HOST: http://3c15e47727" in the output
    And I should see "RACKSPACE_API_ENDPOINT: lon.auth.api.rackspacecloud.com" in the output

