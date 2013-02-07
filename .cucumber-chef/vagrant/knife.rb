current_dir = File.dirname(__FILE__)

log_level               :debug
log_location            STDOUT
node_name               "sam"
client_key              "#{current_dir}/sam.pem"
validation_client_name  "chef-validator"
validation_key          "#{current_dir}/validation.pem"
chef_server_url         "http://127.0.0.1:4000"
cache_type              "BasicFile"
cookbook_path           ['#{current_dir}/../cookbooks']

cache_options(:path => "#{current_dir}/checksums")

require 'librarian/chef/integration/knife'
cookbook_path Librarian::Chef.install_path, "#{current_dir}/../site-cookbooks"
