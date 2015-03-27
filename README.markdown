##Overview

A Puppet module to install software collections from softwarecollections.org.

These collections only currently work on Fedora and RHEL/CentOS.

##Usage

To include a SCL repository and its packages:

    softwarecollectionsorg { 'ruby200': }

To disable the SCL repository, but not remove it or related packages

    softwarecollectionsorg { 'ruby200': enabled => 0 }

To remove the repository and related base package (See limitation #2)

    softwarecollectionsorg { 'ruby200': ensure => absent }

To install the scl-utils-build package

    include softwarecollectionsorg::build_package


##Limitations

* Software collection from softwarecollections.org are not currently GPG signed.
* This packages instals the base package for a collection, and removes it when set to absent. This does not remove all the packages brought in by the base package.  You can do this by running:
    yum remove <name of collection>*
