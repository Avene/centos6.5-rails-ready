class firewall-config::pre {
  Firewall {
    require => undef,
  }

# Default firewall rules
  firewall { '000 accept all icmp':
    proto   => 'icmp',
    action  => 'accept',
  }->
  firewall { '001 accept all to lo interface':
    proto   => 'all',
    iniface => 'lo',
    action  => 'accept',
  }->
  firewall { '002 accept related established rules':
    proto   => 'all',
    state   => ['RELATED', 'ESTABLISHED'],
    action  => 'accept',
  }
  firewall { '003 accept ssh':
    port   => [22],
    proto  => tcp,
    action => accept,
  }
  firewall { '004 accept rails':
    port   => [3000],
    proto  => tcp,
    action => accept,
  }
}

class firewall-config::post {
  firewall { '999 drop all':
    proto   => 'all',
    action  => 'drop',
    before  => undef,
  }
}
