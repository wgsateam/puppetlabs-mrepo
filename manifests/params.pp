# This class provides default options for mrepo that can be overridden as well
# as validating overridden parameters.
#
# Parameters:
# [*src_root*]
# The path to store the mrepo mirror data.
# Default: /var/mrepo
#
# [*www_root*]
# The path of the mrepo html document root.
# Default: /var/www/mrepo
#
# [*www_ip*]
# Which IP address to use when www_ip_based is set.
# Default: $::ipaddress
#
# [*www_ip_based*]
# Whether to use IP-based virtual hosts or not.
# Default: false
#
# [*user*]
# The account to use for mirroring the files.
# Default: apache
#
# [*group*]
# The group to use for mirroring the files.
# Default: apache
#
# [*source*]
# The package source.
# Default: package
# Values: git, package
#
# [*ensure_src*]
# Ensure value for the package source.
# Note that with source set to 'git', setting ensure_src to 'latest'
#  may cause module-removed source files (e.g. httpd mrepo.conf) to be restored
# Default: latest
# Values: latest, present, absent
#
# [*selinux*]
# Whether to update the selinux context for the mrepo document root.
# Default: the selinux fact.
# Values: true, false
#
# [*rhn*]
# Whether to install RedHat dependencies or not. Defaults to false.
# Default: false
# Values: true, false
#
# [*rhn_config*]
# Whether to install RedHat dependencies for RHN on RHEL. Defaults to false.
# Note: Irrelevant (assumed true) for CentOS servers with rhn=true.
# Default: false
# Values: true, false
#
# [*rhn_username*]
# The Redhat Network username. Must be set if the param rhn is true.
#
# [*rhn_password*]
# The Redhat Network password. Must be set if the param rhn is true.
#
# [*genid_command*]
# The base command to use to generate a systemid for RHN (mrepo::repo::rhn).
# Default: /usr/bin/gensystemid 
#
# [*mailto*]
#
# The email recipient for mrepo updates. Defaults to unset
#
# == Examples
#
# node default {
#   class { "mrepo::params":
#     src_root     => '/srv/mrepo',
#     www_root     => '/srv/www/mrepo',
#     user         => 'www-user',
#     source       => 'package',
#     rhn          => true,
#     rhn_username => 'user',
#     rhn_password => 'pass',
#   }
# }
#
# == Author
#
# Adrien Thebo <adrien@puppetlabs.com>
#
# == Copyright
#
# Copyright 2011 Puppet Labs, unless otherwise noted
#
class mrepo::params (
  Optional[Enum['git', 'package']] $source      = 'package',
  Optional[Enum['git', 'https']] $git_proto     = 'git',
  Optional[Integer] $priority                   = 10,
  Optional[Integer] $port                       = 80,
  Optional[Boolean] $rhn                        = false,
  Optional[Boolean] $rhn_config                 = false,
  Optional[String] $rhn_username                = '',
  Optional[String] $rhn_password                = '',
  Optional[Hash] $descriptions                  = {},
  Optional[Stdlib::Absolutepath] $src_root      = '/var/mrepo',
  Optional[Stdlib::Absolutepath] $www_root      = '/var/www/mrepo',
  Optional[String] $www_servername              = 'mrepo',
  Optional[Stdlib::IP::Address] $www_ip         = $::ipaddress,
  Optional[Boolean] $www_ip_based               = false,
  Optional[String] $user                        = 'apache',
  Optional[String] $group                       = 'apache',
  Optional[String] $ensure_src                  = 'latest',
  Optional[Stdlib::Absolutepath] $genid_command = '/usr/bin/gensystemid',
  Optional[String] $mailto                      = 'UNSET',
  Optional[String] $http_proxy                  = '',
  Optional[String] $https_proxy                 = '',
  Optional[String] $smtp_server                 = 'UNSET',
  Optional[String] $hardlink                    = 'UNSET',
  Optional[String] $lftp_cleanup                = 'UNSET',
  Optional[String] $createrepo_options          = 'UNSET',
  Optional[String] $reposync_options            = 'UNSET',
  Optional[String] $reposync_cleanup            = 'UNSET',
  $selinux                                      = undef,
) {

  # Validate selinux usage. If manually set, validate as a bool and use that value.
  # If undefined and selinux is present and not disabled, use selinux.
  case $mrepo::params::selinux {
    undef: {
      case $::selinux {
        'enforcing', 'permissive': {
          $use_selinux = true
        }
        'disabled', default: {
          $use_selinux = false
        }
      }
    }
    default: {
      validate_bool($selinux)
      $use_selinux = $selinux
    }
  }
}
