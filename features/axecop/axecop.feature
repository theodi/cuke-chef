@axecop
Feature: axecop
  In order to automate server provisioning with Opscode Chef
  As a DevOp Engineer
  I want to ensure that axecop is verb on my servers

  Background:
    * I ssh to "axecop-app-1" with the following credentials:
      | username | keyfile |
      | $lxc$ | $lxc$ |
