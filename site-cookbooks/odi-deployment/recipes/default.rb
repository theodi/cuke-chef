#
# Cookbook Name:: odi-deployment
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

include_recipe 'git'

root_dir = "/var/www/%s" % [
  node['project_fqdn']
]

[
  "",
  "shared",
  "shared/config",
  "shared/pids",
  "shared/log",
  "shared/system"
].each do |d|
  directory "%s/%s" % [
    root_dir,
    d
  ] do
    owner node['user']
    group node['group']
    action :create
    recursive true
  end
end

[
  "database.yml",
  "env"
].each do |f|
  p = "%s/%s/%s" % [
    root_dir,
    "shared/config",
    f
  ]
  file p do
    action :create
    begin
      dbi = data_bag_item("%s" % [
        node['git_project']
      ], f.split('.').first)
#      dbi = data_bag_item('member-directory', f.split('.').first)

    content dbi["content"].to_yaml
    rescue Net::HTTPServerException
    end
  end
end

deploy_revision "memberstheodiorg" do
  deploy_to root_dir
  user node['user']
  group node['group']
  repo 'git://github.com/theodi/member-directory.git'
#  revision 'feature-production-deploy'
  symlink_before_migrate(
    {
      "config/database.yml" => "config/database.yml",
      "config/env" => ".env"
    }
  )
  before_migrate do
#    execute "bundle" do
#      command "su - members -c 'cd #{root_dir}/current && bundle'"
#    end
    current_release_directory = release_path
    running_deploy_user = new_resource.user
    bundler_depot = new_resource.shared_path + '/bundle'
    excluded_groups = %w(development test)

    script 'Bundling the gems' do
      interpreter 'bash'
      cwd current_release_directory
      user running_deploy_user
      code <<-EOS
    bundle install --quiet --deployment --path #{bundler_depot} \
      --without #{excluded_groups.join(' ')}
      EOS
    end
  end
#  migrate true
# RAILS_ENV=production rake db:migrate ???
# rake assets:precompile ???
# also RAILS_ENV issues, also had to set
#      config.serve_static_assets = true
# nginx should really be doing this
#  before_restart "rvmsudo foreman export upstart /etc/init"
#  restart_command "service member-directory restart"
  action :force_deploy
end