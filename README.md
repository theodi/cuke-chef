We've been kicking [cucumber-chef](https://github.com/Atalanta/cucumber-chef) 2.1 around for a couple of weeks and finally achieved full end-to-end-ness with the latest rc releases the other day (thanks @zpatten). This should get you up and running with a test lab and a sample cucumber feature (with a bit of [librarian](https://github.com/applicationsonline/librarian) thrown in for free).

Dependencies
============

You'll need Oracle's [VirtualBox](https://www.virtualbox.org/), and [Vagrant](http://www.vagrantup.com/). I'm assuming you're using [RVM](https://rvm.io/), too.

How to play
===========

    git clone git://github.com/theodi/cuke-chef.git
    cd cuke-chef
    bundle
    librarian-chef install
    cucumber-chef setup

This takes ages, you should go and make some tea or something (you can watch the logs with ```tail -f .cucumber-chef/cucumber-chef.log``` if you're into that sort of thing).

When it's done, you can run the sample cuke with

    cucumber --tags @super_awesome_server

Everything should be green. If you see red, _I really want to hear about it, please_.

Remember to ```cucumber-chef destroy``` your test lab before attempting to provision another one or Vagrant will sulk and refuse to play.
