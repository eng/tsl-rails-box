$as_vagrant   = 'sudo -u vagrant -H bash -l -c'
$home         = '/home/vagrant'

Exec {
  path => ['/usr/sbin', '/usr/bin', '/sbin', '/bin']
}

# --- Preinstall Stage ---------------------------------------------------------

stage { 'preinstall':
  before => Stage['main']
}

class apt_get_update {
  exec { 'apt-get -y update':
    unless => "test -e ${home}/.rvm"
  }
}
class { 'apt_get_update':
  stage => preinstall
}

# --- SQLite -------------------------------------------------------------------

package { ['sqlite3', 'libsqlite3-dev']:
  ensure => installed;
}

# --- Packages -----------------------------------------------------------------

package { 'curl':
  ensure => installed
}

package { 'build-essential':
  ensure => installed
}

package { 'git-core':
  ensure => installed
}

# Nokogiri dependencies.
package { ['libxml2', 'libxml2-dev', 'libxslt1-dev']:
  ensure => installed
}

# ExecJS runtime.
package { 'nodejs':
  ensure => installed
}

# --- Ruby ---------------------------------------------------------------------

exec { 'install_rvm':
  command => "${as_vagrant} 'curl -L https://get.rvm.io | bash -s stable'",
  creates => "${home}/.rvm",
  require => Package['curl']
}

exec { 'install_ruby':
  command => "${as_vagrant} '${home}/.rvm/bin/rvm install 2.1.1 --autolibs=enabled && rvm --fuzzy alias create default 2.1.0'",
  creates => "${home}/.rvm/rubies/ruby-2.1.0/bin/ruby",
  require => Exec['install_rvm']
}

exec { 'install_rails':
  command => "${as_vagrant} 'gem install rails --no-rdoc --no-ri'",
  creates => "${home}/.rvm/gems/ruby-2.1.1/bin/rails",
  require => Exec['install_ruby']
}

exec { 'update_bundler':
  command => "${as_vagrant} 'gem update bundler'",
  require => Exec['install_rails']
}

# --- Files ---------------------------------------------------------------------

file { '/etc/motd':
  content => 'Welcome to The Starter League!'
}

file { '/home/vagrant/.gemrc':
  content => 'gem: --no-ri --no-rdoc'
}

file { '/etc/profile.d/startup.sh':
  content => 'cd /home/vagrant/code'
}

file { '/etc/profile.d/aliases.sh':
  source => '/home/vagrant/code/puppet/files/aliases.sh'
}
