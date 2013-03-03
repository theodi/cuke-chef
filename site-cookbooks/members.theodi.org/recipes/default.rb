#
# Cookbook Name:: members.theodi.org
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

node.set['project'] = 'members'
node.set['user'] = node['project']
node.set['group'] = node['project']
node.set['ruby'] = '1.9.3-p374'
node.set['project_fqdn'] = "%s.theodi.org" % [
  node['project']
]
node.set['git_project'] = 'member-directory'
node.set['mysql']['server_root_password'] = 'rawprawn'

include_recipe "apt"
include_recipe "odi-xml"
include_recipe "xslt"
include_recipe "git"
include_recipe "nginx"
include_recipe "mysql::server"
include_recipe "nodejs"
include_recipe "redisio"
include_recipe "redisio::install"
include_recipe "redisio::enable"
include_recipe "libcurl"
include_recipe "sqlite::dev"
include_recipe "odi-users"
include_recipe "odi-rvm"
include_recipe "odi-deployment"