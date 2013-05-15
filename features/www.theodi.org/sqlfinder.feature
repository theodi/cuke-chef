Feature: We have search for the correct mysql server

  Background:
    Given I have a server called "theodi-org"
    And "theodi-org" is running "ubuntu" "precise"
    And "theodi-org" should be persistent
    And "theodi-org" has been provisioned
    And "theodi-org" is in the "cucumber" environment

    And all of the cookbooks in "./cookbooks" have been uploaded
    And all of the cookbooks in "./site-cookbooks" have been uploaded

    And the following databags have been updated:
      | databag | databag_path        |
      | website | ./data_bags/website |

    And the following environment has been uploaded:
      | environment | environment_path |
      | cucumber.rb | ./environments/  |

    And the following roles have been uploaded:
      | role | role_path |
      | *.rb | ./roles/  |

    And the "chef-client::service" recipe has been added to the "theodi-org" run list

    And the "git" recipe has been added to the "theodi-org" run list
    And the "apache2" recipe has been added to the "theodi-org" run list
    And the "apache2::mod_rewrite" recipe has been added to the "theodi-org" run list
    And the "apache2::mod_php5" recipe has been added to the "theodi-org" run list
    And the "odi-website-deploy" recipe has been added to the "theodi-org" run list

    And the chef-client has been run on "theodi-org"

    When I ssh to "theodi-org" with the following credentials:
      | username | keyfile |
      | $lxc$    | $lxc$   |

  Scenario: Can connect to the provisioned server via SSH authentication
    When I run "hostname"
    Then I should see "theodi-org" in the output

  Scenario: git should be installed
    * package "git" should be installed

  @settings
  Scenario: settings file has correct stuff
    When I run "cat /var/www/theodi.org/sites/default/settings.php"
    Then I should see "\$base_url = 'http://theodi.org';" in the output
    And I should see "\$conf\['cache_default_class'\] = 'MemCacheDrupal';" in the output
    And I should see "'host' => '192.168.77.19'," in the output
    And file "/var/www/theodi.org/sites/default/settings.php" should be owned by "www-data:www-data"