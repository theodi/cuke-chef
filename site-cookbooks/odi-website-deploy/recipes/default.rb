#
# Cookbook Name:: odi-website-deploy
# Recipe:: default
#
# Copyright 2013, The Open Data Institute
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#

directory "/var/www/theodi.org" do
  user "www-data"
  group "www-data"
end

git "/var/www/theodi.org" do
  repository "git://github.com/theodi/odi-website-drupal.git"
  user "www-data"
  group "www-data"
  action :sync
end

dbi  = data_bag_item "website", "credentials"
site = data_bag_item "website", "site"

db     = dbi["database"]
drupal = site["drupal"]

script 'Set up a less restrictive php.ini for Drush to use' do
  interpreter 'bash'
  user "root"
  code <<-EOF
  mkdir -p /root/.drush/
  echo "disable_functions =" > /root/.drush/php.ini
  echo "magic_quotes_gpc = Off" >> /root/.drush/php.ini
  echo "magic_quotes_gpc = 0" >> /root/.drush/php.ini
  echo "magic_quotes_runtime = 0" >> /root/.drush/php.ini
  echo "magic_quotes_sybase = 0" >> /root/.drush/php.ini
  EOF
end

cookbook_file "/var/www/vanilla_drupal.sqlite" do
  source "vanilla_drupal.sqlite"
  user "www-data"
  group "www-data"
end

cron "drupal_cron" do
  minute "10"
  hour "*"
  day "*"
  month "*"
  weekday "*"
  user "root"
  command <<-EOF
    COLUMNS=72 /usr/bin/drush --root=/var/www/theodi.org --uri=theodi.org --quiet cron
  EOF
  action :create
end

mysql_node = search(:node, "name:drupal-mysql-server* AND chef_environment:#{node.chef_environment}")[0]

mysql_address = mysql_node["ipaddress"]
if mysql_node["rackspace"]
  mysql_address = mysql_node["rackspace"]["private_ip"]
end

memcache_nodes = search(:node, "name:drupal-memcache-server* AND chef_environment:#{node.chef_environment}")
memcache_servers = memcache_nodes.map do |node|
  if node["rackspace"]
    node ["rackspace"]["private_ip"]
  else
    node["ipaddress"]
  end
end
if memcache_servers.empty?
  memcache_servers = ['localhost']
end

template "/var/www/theodi.org/sites/default/settings.php" do
  source "settings.php.erb"
  variables(
      :base_url  => drupal[node.chef_environment]["base_url"],
      :database  => db[node.chef_environment]["database"],
      :db_user   => db[node.chef_environment]["username"],
      :db_pass   => db[node.chef_environment]["password"],
  #    :db_host   => db[node.chef_environment]["host"],
      :db_host  => mysql_address,
      :db_driver => db[node.chef_environment]["driver"],
      :memcache_servers => memcache_servers,
  )
  user "www-data"
  group "www-data"
end

template "/etc/apache2/sites-available/theodi.org" do
  source "vhost.erb"
  variables(
      :server_name  => drupal[node.chef_environment]["server_name"],
      :server_alias => drupal[node.chef_environment]["server_alias"]
  )
end

apache_site "theodi.org" do
  action :enable
  notifies :restart, "service[apache2]"
end