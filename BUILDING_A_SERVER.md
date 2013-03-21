# Building a Chef 11 server
Add _chef_ to _/etc/hosts_ and _/etc/hostname_. If Linode, add _odi_ user, add to _sudo_, disable RootLogin.
   
    sudo apt-get update
    sudo apt-get upgrade
    sudo reboot
    
# Install it

    wget https://opscode-omnitruck-release.s3.amazonaws.com/ubuntu/12.04/x86_64/chef-server_11.0.6-1.ubuntu.12.04_amd64.deb
    sudo dpkg -i ./chef-server_11.0.6-1.ubuntu.12.04_amd64.deb
    sudo chef-server-ctl reconfigure
    
Something something FQDN. The embedded nginx does some kind of redirect-fu which makes things a bit brittle. We can try to understand this, or we can (from [this](http://serverfault.com/questions/483957/chef-connection-refused-for-cookbook-upload))	 just fix it by making a file _/etc/chef-server/chef-server.rb_:

    server_name = "ip.address.goes.here"
    api_fqdn server_name

    nginx['url'] = "https://#{server_name}"
    nginx['server_name'] = server_name
    lb['fqdn'] = server_name
    bookshelf['vip'] = server_name
    
and doing

    sudo chef-server-ctl reconfigure

again.
    
## Configure it
    
Point a browser at [https://chef.theodi.org/](https://chef.theodi.org/), change the damn password.

Make a client, _odi_, as an admin. Grab the private key.

In some local repo, make a _.chef/knife.rb_ file that looks like this:

    current_dir = File.dirname(__FILE__)

    log_level               :debug
    log_location            STDOUT
    node_name               "odi"
    client_key              "#{current_dir}/odi.pem"
    validation_client_name  "chef-validator"
    validation_key          "#{current_dir}/chef-validator.pem"
    chef_server_url         "https://chef.theodi.org"
    cache_type              "BasicFile"
    cookbook_path           [
                              '#{current_dir}/../cookbooks',
                              '#{current_dir}/../site-cookbooks'
                            ]
    
    cache_options(:path => "#{current_dir}/checksums")
    
    cookbook_copyright "The Open Data Institute"
    cookbook_license "mit"
    cookbook_email "tech@theodi.org"
    readme_format "md"
    
and paste the PK from above into _.chef/odi.pem_. Now this should work:

    knife client list
    
if so, things are looking good.

### Validator key

We need the validator key to provision new nodes. Easiest way is to copy _/etc/chef-server/chef-validator.pem_ from the new Chef server, and paste it into _.chef/chef-validator.pem_ locally.

## Populate it

On your now-correctly-configured laptop:

    for thing in environment role ; do for item in `ls ${thing}s` ; do knife ${thing} from file ${thing}s/${item} -c .live-chef/knife.rb ; done ; done
    for bag in `ls data_bags/` ; do items=`ls data_bags/${bag}` ; knife data bag create ${bag} -c .live-chef/knife.rb ; for item in ${items} ; do knife data bag from file ${bag} data_bags/${bag}/${item} -c .live-chef/knife.rb ; done ; done
    knife cookbook upload -a -c .live-chef/knife.rb
    
## Test it

With a Vagrant node.
