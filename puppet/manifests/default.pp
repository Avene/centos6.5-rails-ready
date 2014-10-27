# initialize path environment variables
Exec {
  path => ['/usr/sbin', '/usr/bin', '/sbin', '/bin']
}

# pre-install stage
stage { 'preinstall':
  before => Stage['main']
}

class ruby {
  include rbenv
  rbenv::plugin { [ 'sstephenson/rbenv-vars', 'sstephenson/ruby-build' ]: }
  rbenv::build { '2.1.3': global => true }

}

class { 'ruby' : }
class { 'rails' :
  require => Class['ruby']
}

resources { "firewall":
  purge => true
}
Firewall {
  require => Class['firewall-config::pre'],
  before  => Class['firewall-config::post'],
}
include firewall-config::pre, firewall-config::post
include firewall

