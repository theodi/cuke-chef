#
# Cookbook Name:: odi-nginx
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

#[
#    'available',
#    'enabled'
#].each do |dir|
#  directory "/etc/nginx/sites-%s" % [
#      dir
#  ] do
#    recursive true
#    action :create
#  end
#end

template "/etc/nginx/sites-available/%s" % [
    node["project_fqdn"]
] do
  source "vhost.erb"
  variables(
      :fqdn         => node["project_fqdn"],
      :project_name => node["git_project"]
  )
  action :create
end

link "/etc/nginx/sites-enabled/%s" % [
    node["project_fqdn"]
] do
  to "/etc/nginx/sites-available/%s" % [
      node["project_fqdn"]
  ]

  notifies :restart, "service[nginx]"
end

if node["301_redirects"]
  node["301_redirects"].each do |r|
    template "/etc/nginx/sites-available/%s" % [
        r
    ] do
      source "redirect.erb"
      variables(
          :this => node["project_fqdn"],
          :that => r
      )
    end

    link "/etc/nginx/sites-enabled/%s" % [
        r
    ] do
      to "/etc/nginx/sites-available/%s" % [
          r
      ]

      notifies :restart, "service[nginx]"
    end
  end
end