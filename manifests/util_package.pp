# == Class: softwarecollectionsorg::util_package
#
# A class to make it easy to install Software Collections from
# https://softwarecollections.org/.
#
# === Parameters
#
# [*ensure*]
#   Basic present/absent behavior for the resources contained in this module
#
class softwarecollectionsorg::util_package (
  $ensure = present,
) {

  package { 'scl-utils':
    ensure  => $ensure,
  }

}
