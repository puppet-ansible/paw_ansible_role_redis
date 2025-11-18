# Example usage of paw_ansible_role_redis

# Simple include with default parameters
include paw_ansible_role_redis

# Or with custom parameters:
# class { 'paw_ansible_role_redis':
#   ansible_managed => undef,
#   redis_daemon => undef,
#   redis_port => 6379,
#   redis_bind_interface => '127.0.0.1',
#   redis_unixsocket => undef,
#   redis_timeout => 300,
#   redis_loglevel => 'notice',
#   redis_logfile => '/var/log/redis/redis-server.log',
#   redis_databases => 16,
#   save => undef,
#   redis_rdbcompression => 'yes',
#   redis_dbfilename => 'dump.rdb',
#   redis_dbdir => '/var/lib/redis',
#   redis_maxmemory => 0,
#   redis_maxmemory_policy => 'noeviction',
#   redis_maxmemory_samples => 5,
#   redis_appendonly => 'no',
#   redis_appendfsync => 'everysec',
#   include => undef,
#   redis_requirepass => undef,
#   redis_disabled_command => undef,
#   redis_extra_config => undef,
#   redis_enablerepo => 'epel',
#   redis_enabled => true,
#   redis_save => ['900 1', '300 10', '60 10000'],
#   redis_includes => [],
#   redis_disabled_commands => [],
# }
