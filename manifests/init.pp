# == Class: groovy
#
# Supported operating systems are:
#   - Ubuntu Linux
#   - Fedora Linux
#   - Debian Linux
#   - CentOS Linux
#
# Support puppet versions are:
#   - Puppet > 2.6.2
#
#
class groovy (
  $version  = $groovy::params::version,
  $base_url = $groovy::params::base_url,
  $target   = $groovy::params::target,
  $timeout  = $groovy::params::timeout,
) inherits groovy::params {

  include stdlib

  validate_string($version)
  validate_string($base_url)

  $groovy_filename = "groovy-binary-${version}.zip"
  $groovy_dir = "${target}/groovy-${version}"

  file { '/etc/profile.d/groovy.sh':
    ensure  => file,
    mode    => '0644',
    content => template("${module_name}/groovy.sh.erb"),
  }

  staging::file { $groovy_filename:
    source  => "${base_url}/${groovy_filename}",
    timeout => $timeout,
  }

  staging::extract { $groovy_filename:
    target  => $target,
    creates => $groovy_dir,
    require => [
      Staging::File[$groovy_filename],
      Package['unzip'],
      File[$target],
    ],
  }
}
