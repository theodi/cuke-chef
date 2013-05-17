#
# Cookbook Name:: odi-fileconveyor
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

package "python" do
  action :install
end

package "php5-sqlite" do
  action :install
end

package "python-setuptools" do
  action :install
end

directory "/var/fileconveyor" do
  user "www-data"
  group "www-data"
end

git "/var/fileconveyor" do
  repository "git://github.com/theodi/fileconveyor.git"
  revision "mysql"
  user "www-data"
  group "www-data"
  action :sync
end

dbi = data_bag_item "website", "credentials"

rackspace = dbi["rackspace"]

# Install dependencies - cd into the /var/fileconveyor directory and run 'setup.py install'

script 'Install Fileconveyor dependencies' do
    interpreter 'bash'
    cwd '/var/fileconveyor'
    user "root"
    code <<-EOF
    python ./setup.py install
    EOF
end

template "/var/fileconveyor/fileconveyor/config.xml" do
  source "config.xml.erb"
  variables(
    :username   => rackspace[node.chef_environment]["username"],
    :api_key    => rackspace[node.chef_environment]["api_key"],
    :container => rackspace[node.chef_environment]["container"]
  )
  user "www-data"
  group "www-data"
end

template "/var/fileconveyor/fileconveyor/settings.py" do
  source "settings.py.erb"
  user "www-data"
  group "www-data"
end

script 'Download CDN if not already there' do
  interpreter 'bash'
  cwd '/var/www/theodi.org'
  user "root"
  code <<-EOF
  drush dl cdn --y
  EOF
  not_if { ::File.exists?("/var/www/theodi.org/sites/all/modules/cdn/cdn.module") }
end

# Set up various things in Drupal
script 'Drush CDN stuff' do
  interpreter 'bash'
  cwd '/var/www/theodi.org'
  user "root"
  code <<-EOF
  drush en cdn --y
  drush ev 'variable_set("cdn_advanced_pid_file", "/var/fileconveyor/fileconveyor/fileconveyor.pid");'
  drush ev 'variable_set("cdn_advanced_synced_files_db", "/var/fileconveyor/fileconveyor/synced_files.db");'
  drush ev 'variable_set("cdn_mode", "advanced");'
  drush ev 'variable_set("cdn_status", "2");'
  EOF
end

# Get the arbitrator running as a background task
template "/etc/init/arbitrator.conf" do
  source "arbitrator.conf.erb"
  variables(
    :path   => "/var/fileconveyor/fileconveyor",
    :user   => "www-data"
  )
  user "www-data"
  group "www-data"
end

service 'arbitrator' do
  provider Chef::Provider::Service::Upstart
  action :start
end