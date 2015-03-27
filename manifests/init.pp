# == Class: softwarecollectionsorg
#
# A class to make it easy to install Software Collections from
# https://softwarecollections.org/.
#
# === Parameters
#
# [*title*]
#   The name of the Software Collection to install.
# [*ensure*]
#   Basic present/absent behavior for the resources contained in this module
# [*enabled*]
#   Even if present, should the repository be enabled?
# [*scl_url*]
#   The URL to the repository for the Software Collection. This can be
#   automatically calculated based on the name of the Software Collection.
# [*os_version*]
#   The version of Fedora or EL (6 or 7) that this SCL should be used with. This
#   parameter defaults to the value of the 'operatingsystemmajrelease' fact.
# [*epel_version*]
#   DEPRECATED, but takes precedence for backward compatability! The version
#   of EPEL (6 or 7) that this SCL should be used with. This parameter defaults
#   to the value of the 'operatingsystemmajrelease' fact.
#
define softwarecollectionsorg (
  $ensure       = present,
  $enabled      = 1,
  $scl_url      = undef,
  $epel_version = undef,
  $os_version   = $::operatingsystemmajrelease,
) {
  case $::osfamily {
    'RedHat': {
    }
    default: {
      fail("Software Collections from softwarecollections.org cannot be installed on ${::operatingsystem}.")
    }
  }

  case $::architecture {
    'x86_64': {
    }
    default: {
      fail("Software Collections from softwarecollections.org cannot be installed on ${::architecture}.")
    }
  }

  # change to $os_version when removing epel_version
  if $os_version == undef and $epel_version == undef {
    fail("The release of Fedora/RHEL/CentOS you are on is unknown to Puppet. Please set the 'os_version' parameter.")
  }
  if $epel_version != undef {
    $dist_version = $epel_version
  } else {
    $dist_version = $os_version
  }

  if $::operatingsystem == 'Fedora' {
    $dist = downcase($::operatingsystem)
  } else {
    $dist = 'epel'
  }

  include ::softwarecollectionsorg::util_package

  if $scl_url == undef {
    $baseurl = "https://www.softwarecollections.org/repos/rhscl/${title}/${dist}-${dist_version}-x86_64"
  }
  else {
    $baseurl = $scl_url
  }

  $repo_name = "rhscl-${title}-${dist}-${dist_version}-x86_64"
  yumrepo { $repo_name:
    ensure   => $ensure,
    descr    => $repo_name,
    baseurl  => $baseurl,
    enabled  => $enabled,
    gpgcheck => 0,
    require  => Class['::softwarecollectionsorg::util_package']
  }

  package { $title:
    ensure  => $ensure,
    require => Yumrepo[$repo_name],
  }

  if $ensure == absent {
    file { "/etc/yum.repos.d/${repo_name}.repo":
      ensure => absent,
    }
    notify { 'SCL Removal':
      message => 'Ensuring that this SCL is absent does not necessarily remove all the packages it installed'
    }
  }

}
