# == Class: softwarecollectionsorg::build_package
#
# A class to make it easy to install Software Collections from
# https://softwarecollections.org/.
#
# === Parameters
#
# [*ensure*]
#   Basic present/absent behavior for the resources contained in this module
#
class softwarecollectionsorg::build_package (
  $ensure = present,
) {

  package { 'scl-utils-build':
    ensure  => $ensure,
  }

}
