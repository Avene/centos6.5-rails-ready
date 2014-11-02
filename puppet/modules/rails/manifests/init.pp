class rails (
  $project_name = 'project',
  $user = "vagrant",
  $group = "vagrant"
){
  $project_path = "/vagrant/${project_name}"

  file { $project_path:
    ensure => "directory",
    owner  => $user,
    group  => $group,
    mode   => 775,
  }
  file { "${$project_path}/Gemfile":
    replace => no,
    ensure => present,
    content => "source 'https://rubygems.org'\n
                gem 'rails'\n",
    owner  => $user,
    group  => $group,
    mode   => 664,
  }~>
  exec{ 'bundle-install' :
    command => "bundle install --path ~/.bundle --jobs 4",
    unless => "test -d ~/.bundle",
    refreshonly => true,
  }~>
  exec{ 'rails-new' :
    command => "bundle exec rails new . -T -f",
    environment =>  'HOME=/home/vagrant',
    unless => "test -e ${$project_path}/bin/rails",
    refreshonly => true,
  }~>
  exec {'rubyracer-gem' :
    command => "echo 'gem \"therubyracer\",  platforms: :ruby\n' >> ${$project_path}/Gemfile",
    refreshonly => true,
    unless => "grep -e \"therubyracer\" Gemfile | grep -v \"^[:space:]*#.*gem\" 2>/dev/null"
  }~>
  exec{ 'bundle-update' :
    command => "bundle update",
    refreshonly => true,
  }

  Exec {
    cwd => $project_path,
    path => ['/usr/sbin', '/usr/bin', '/sbin', '/bin', '/usr/local/rbenv/shims',],
    user => $user,
    group => $group,
    timeout => 1500,
  }
}
