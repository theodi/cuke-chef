#
# Cookbook Name:: odi-logstash
# Recipe:: agent
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

#node.default['logstash']['elasticsearch_query'] = 'nonesuch'
#node.default['logstash']['elasticsearch_role'] = nil
#
#es_box = search(:node, "role:elasticsearch_server AND chef_environment:#{node.chef_environment}")[0]
#es_ip  = es_box["ipaddress"]
#if es_box["rackspace"]
#  es_ip = es_box["rackspace"]["private_ip"]
#end

#node.set['logstash']['elasticsearch_ip'] = es_ip

include_recipe 'logstash::agent'

#template "/opt/logstash/agent/etc/shipper.conf" do
#  source "shipper.conf.erb"
#  owner 'logstash'
#  group 'logstash'

#  notifies :restart, "service[logstash_agent]"
#end

ls_box = search(:node, "role:logstash_server AND chef_environment:#{node['logstash_env']}")[0]
ls_ip  = ls_box["ipaddress"]
if ls_box["rackspace"]
  ls_ip = ls_box["rackspace"]["private_ip"]
end

begin
  t = resources(:template => "/opt/logstash/agent/etc/shipper.conf")
  t.source "shipper.conf.erb"
  t.cookbook "odi-logstash"
  t.variables(
      "logstash_box" => ls_ip,
      "fqdn"         => node['project_fqdn'],
      "git_project"  => node['git_project']
  )
rescue Chef::Exceptions::ResourceNotFound
  Chef::Log.warn "could not find template /opt/logstash/agent/etc/shipper.conf to modify"
end