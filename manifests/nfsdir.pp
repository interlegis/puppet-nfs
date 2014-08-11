# nfsdir.pp

define nfsdir ( $server_ip,
                $server_dir,
                $nfsversion = 3,
                $client_dir,
                $ensure = 'mounted',
              ) {

  if !defined(Package["nfs-common"]) {
    package { "nfs-common" : ensure => installed }
  }
 
  ## Mount NFS directory
  mount { "${client_dir}":
    device => "${server_ip}:${server_dir}",
    fstype => "nfs",
    ensure => $ensure,
    options => "nfsvers=3",
    require => Package["nfs-common"],
  }
}

