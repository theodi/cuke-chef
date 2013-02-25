First cut at a workflow
-----------------------

* Cook up your cukes and run them against your test lab, iterate until they pass
* Upload the working cookbooks to the live Chef server:
  * ```b knife cookbook upload -a -o cookbooks -c .live-chef/knife.rb```
  * ```b knife cookbook upload -a -o site-cookbooks -c .live-chef/knife.rb```
  * Don't forget your databags (I forgot the databags this afternoon and swore a lot):
    * ```b knife data bag from file users data_bags/users/ -c .live-chef/knife.rb```
  * Right about now, you'll also want to upload any *environments* or *roles* (but we're not using those yet)
* In another directory (away from all of this cuke-chef stuff) set up a Vagrantfile to be provisioned with your *wrapper cookbook* from *your live Chef server*, like:
  * ```chef.chef_server_url = "https://chef.theodi.org"```
  * ```"recipe[odi-queue-master]"```
* Fire up the Vagrant node
* Watch everything work
  
There are undoubtedly a bunch of assumptions I've made here, I need some feedback...