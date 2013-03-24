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

dbi = data_bag_item "website", "credentials"

db = dbi["database"]

template "/var/www/theodi.org/sites/default/settings.php" do
  source "settings.php.erb"
  variables(
      :base_url => "http://theodi.org",
      :database => db["database"],
      :db_user => db["username"],
      :db_pass => db["password"],
      :db_host => db["host"]
  )
  user "www-data"
  group "www-data"
end

template "/etc/apache2/sites-available/theodi.org" do
  source "vhost.erb"
  variables(
      :server_name => "theodi.org",
      :server_alias => "www.theodi.org"
  )
end

apache_site "theodi.org" do
  action :enable
end