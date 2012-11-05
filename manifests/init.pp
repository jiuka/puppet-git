# == Class: git
#
# Install the git binary.
#
# === Parameters
#
# === Variables
#
# === Examples
#
#  class { git: }
#
# === Authors
#
# Marius Rieder <marius.rieder@nine.ch>
#
# === Copyright
#
# Copyright 2012 Nine Internet Solutions AG
#

class git {

  $pkg = $::operatingystem ? {
    /(?i:Debian|Ubuntu)/ => ['git-core'],
    default => ['git'],
  }

  package { $pkg: ensure => installed }

}
