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

}
