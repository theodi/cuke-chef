We've been kicking [cucumber-chef](https://github.com/Atalanta/cucumber-chef) 2.1 around for a couple of weeks, this should get you up and running with a text lab and a sample cucumber feature.

How to play
===========

    bundle
    librarian-chef install
    cucumber-chef setup

This takes ages, you should go and make some tea or something. When it's done, you can run the sample cuke with

    cucumber --tags @super_awesome_server
