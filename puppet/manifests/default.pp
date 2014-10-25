# initialize path environment variables
Exec {
  path => ['/usr/sbin', '/usr/bin', '/sbin', '/bin']
}

# pre-install stage
stage { 'preinstall':
  before => Stage['main']
}

include rbenv
rbenv::plugin { [ 'sstephenson/rbenv-vars', 'sstephenson/ruby-build' ]: }
rbenv::build { '2.1.2': global => true }

resources { "firewall":
  purge => true
}

Firewall {
  require => Class['firewall-config::pre'],
  before  => Class['firewall-config::post'],
}
include firewall-config::pre, firewall-config::post
include firewall