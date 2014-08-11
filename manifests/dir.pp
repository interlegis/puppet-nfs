# dir.pp

define nfs::dir ( $server_ip,
                  $server_dir,
                  $nfs_version = 3,
                  $client_dir = $name,
                  $client_dir_owner = 'root',
                  $client_dir_group = 'root',
                  $client_dir_mode = '640',
                  $client_dir_recurse = false,
                  $client_dir_recurse_limit = 1,
                  $ensure = 'mounted',
                ) {

  if !defined(Package["nfs-common"]) {
    package { "nfs-common" : ensure => installed }
  }

  if !defined(File["$client_dir"]) {
    file { "$client_dir":
      ensure       => 'directory',
      owner        => $client_dir_owner,
      group        => $client_dir_group,
      mode         => $client_dir_mode,
      recurse      => $client_dir_recurse,
      recurselimit => $client_dir_recurse_limit,
    }
  }
 
  ## Mount NFS directory
  mount { "${client_dir}":
    device => "${server_ip}:${server_dir}",
    fstype => "nfs",
    ensure => $ensure,
    options => "nfsvers=${nfs_version}",
    require => [ Package["nfs-common"],
                 File["$client_dir"],
               ]
  }
}

