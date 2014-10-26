class rails (
  $projectroot = '/home/vagrant/project',
){
  rbenv::gem{ 'rails': ruby_version => '2.1.3', timeout => 1500 }
  rbenv::gem{ 'therubyracer': ruby_version => '2.1.3', timeout => 1500 }

  file { $projectroot:
    ensure => "directory",
    owner  => "vagrant",
    group  => "vagrant",
    mode   => 775,
  }
  file { "${projectroot}/Gemfile":
    replace => no,
    ensure => present,
    content => "source 'https://rubygems.org'\n
                gem 'rails'\n",
    owner  => "vagrant",
    group  => "vagrant",
    mode   => 664,
  }
  exec{ 'initialize-project' :
    command => "rails new ${projectroot} -T -B -f",
    environment =>  'HOME=/home/vagrant',
    path => ['/usr/sbin', '/usr/bin', '/sbin', '/bin', '/usr/local/rbenv/shims',]
  }~>
  exec{ 'bundle-install' :
    command => "bundle install --path vendor/bundle",
    cwd => $projectroot,
    path => ['/usr/sbin', '/usr/bin', '/sbin', '/bin', '/usr/local/rbenv/shims',]
  }~>
  exec {'rubyracer-gem' :
    command => "echo 'gem \"therubyracer\"\n' >> ${projectroot}/Gemfile",
    user => "vagrant"
  }~>
  exec{ 'bundle-update' :
    command => "bundle update",
    cwd => $projectroot,
    path => ['/usr/sbin', '/usr/bin', '/sbin', '/bin', '/usr/local/rbenv/shims',]
  }
}
