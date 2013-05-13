#
# Cookbook Name:: hoppler
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

hoppler = "hoppler"

group "%s" % [
    hoppler
] do
  action :create
end

user "%s" % [
    hoppler
] do
  gid hoppler
  shell "/bin/bash"
  home "/home/%s" % [
      hoppler
  ]
  supports :manage_home => true
  action :create
end

file "/etc/sudoers.d/%s" % [
    hoppler
] do
  content "%s ALL=NOPASSWD:ALL" % [
      hoppler
  ]
  mode "0440"
  action :create
end

node.set['rvm']['user_installs'] = [
    { 'user'         => hoppler,
      'default_ruby' => "2.0.0",
      'rubies'       => [
          "2.0.0"
      ]
    }
]

include_recipe "rvm::user_install"

dbi = data_bag_item 'databases', 'www'

node.set['mysql']['server_root_password'] = dbi[node.chef_environment]['password']

template "/home/%s/.mysql.env" % [
    hoppler
] do
  source "mysql.env.erb"
  variables(
      :username => "root",
      :password => node['mysql']['server_root_password']
  )
end

git "/home/%s/hoppler" % [
    hoppler
] do
  repository "git://github.com/theodi/hoppler.git"
  user hoppler
  group hoppler
  action :sync
end

script "bundle" do
  interpreter 'bash'
#  cwd "/home/%s/hoppler" % [
#      hoppler
#  ]
#  user hoppler
  code <<-EOF
  su - hoppler -c "cd /home/hoppler/hoppler && bundle install --quiet"
  EOF
end

template "/etc/cron.d/hoppler" do
  source "cron.erb"
end