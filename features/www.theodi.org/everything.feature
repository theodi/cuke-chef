@theodi-org
Feature: We have a functioning website

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

    And the "odi-drupal" role has been added to the "theodi-org" run list

    And the chef-client has been run on "theodi-org"

    When I ssh to "theodi-org" with the following credentials:
      | username | keyfile |
      | $lxc$    | $lxc$   |

  Scenario: Can connect to the provisioned server via SSH authentication
    When I run "hostname"
    Then I should see "theodi-org" in the output

  Scenario: git should be installed
    * package "git" should be installed

  Scenario: Apache2 is installed
    * package "apache2" should be installed

  Scenario: apache modules are enabled
    * "mod_php5" should be enabled
    * "mod_rewrite" should be enabled

  Scenario: php5-gd is installed
    * package "php5-gd" should be installed

  Scenario: php5-mysql is installed
    * package "php5-mysql" should be installed

  Scenario: memcached is installed
    * package "php5-memcached" should be installed

  Scenario: postfix is installed
    * package "postfix" should be installed

  Scenario: drush is installed
    When I run "drush -v | grep version"
    Then I should see "5." in the output

  Scenario: code is deployed
    * directory "/var/www/theodi.org" should exist
    * directory "/var/www/theodi.org" should be owned by "www-data:www-data"
    * directory "/var/www/theodi.org/sites/all/modules/course_list" should exist

  Scenario: settings file has correct stuff
    When I run "cat /var/www/theodi.org/sites/default/settings.php"
    Then I should see "\$base_url = 'http://theodi.org';" in the output
    And I should see "'database' => 'theodi_org'" in the output
    And I should see "'username' => 'theodi_org'" in the output
    And I should see "\$conf\['cache_default_class'\] = 'MemCacheDrupal';" in the output

  Scenario: vhost exists
    * file "/etc/apache2/sites-available/theodi.org" should exist
    * file "/etc/apache2/sites-available/theodi.org" should contain
    """
<VirtualHost *:80>
  ServerName theodi.org
  ServerAlias www.theodi.org
  DocumentRoot /var/www/theodi.org
  <Directory /var/www/theodi.org>
    Options +FollowSymLinks
    AllowOverride All
    Order allow,deny
    Allow from all
  </Directory>
  ErrorLog /var/log/apache2/theodi.org.err
  CustomLog /var/log/apache2/theodi.org.log Combined
</VirtualHost>
    """
    * symlink "/etc/apache2/sites-enabled/theodi.org" should exist

  @icinga
  Scenario: icinga is installed
#    * package "icinga-client" should be installed
# This maybe: https://github.com/Bigpoint/icinga