class rails (
  $projectroot = '/home/vagrant/project',
  $user = "vagrant",
  $group = "vagrant"
){

  file { $projectroot:
    ensure => "directory",
    owner  => $user,
    group  => $group,
    mode   => 775,
  }
  file { "${projectroot}/Gemfile":
    replace => no,
    ensure => present,
    content => "source 'https://rubygems.org'\n
                gem 'rails'\n",
    owner  => $user,
    group  => $group,
    mode   => 664,
  }~>
  exec{ 'bundle-install' :
    command => "bundle install --path vendor/bundle",
    unless => "test -d ${projectroot}/vendor/bundle",
    refreshonly => true,
  }~>
  exec{ 'rails-new' :
    command => "bundle exec rails new . -T -f",
    environment =>  'HOME=/home/vagrant',
    refreshonly => true,
  }~>
  exec {'rubyracer-gem' :
    command => "echo 'gem \"therubyracer\"\n' >> ${projectroot}/Gemfile",
    refreshonly => true,
  }~>
  exec{ 'bundle-update' :
    command => "bundle update",
    refreshonly => true,
  }

  Exec {
    cwd => $projectroot,
    path => ['/usr/sbin', '/usr/bin', '/sbin', '/bin', '/usr/local/rbenv/shims',],
    user => $user,
    group => $group,
    timeout => 1500,
  }
}
