#Vagrant::Config.run do |config|
Vagrant.configure("1") do |config|
  config.vm.box = "precise64"
#  config.vm.box = "cuke-chef-test-lab"
#  config.vm.box_url = "http://files.vagrantup.com/precise64.box"
  config.vm.customize ["modifyvm", :id, "--memory", "2048"]
  config.vm.forward_port 4000, 4000
  config.vm.forward_port 4040, 4040
  config.vm.forward_port 8787, 8787
end
