# Class: p4ruby
# ===========================
#
# Manages the Perforce Ruby (P4RUBY) client API.
#
# Authors
# -------
#
# Alan Petersen <alanpetersen@mac.com>
#
# Copyright
# ---------
#
# Copyright 2016 Alan Petersen, unless otherwise noted.
#
class p4ruby (
  $ensure           = 'present',
  $p4api_dir        = undef,
  $gcc_package      = $p4ruby::params::gcc_package,
  $ruby_dev_package = $p4ruby::params::ruby_dev_package,
) inherits p4ruby::params {

  ensure_resource('package', $ruby_dev_package, {
    ensure => present,
  })

  ensure_resource('package', 'rubygems', {
    ensure => present,
  })

  ensure_resource("package", $gcc_package, {
    ensure => "installed",
  })

  if ($p4api_dir) {
    package {'p4ruby':
      ensure          => $ensure,
      provider        => 'gem',
      install_options => ['--', "--with-p4api-dir=${p4api_dir}"],
      require         => Package[$ruby_dev_package, 'rubygems', $gcc_package],
    }
  } else {
    package {'p4ruby':
      ensure   => $ensure,
      provider => 'gem',
      require  => Package[$ruby_dev_package, 'rubygems', $gcc_package],
    }
  }
}
