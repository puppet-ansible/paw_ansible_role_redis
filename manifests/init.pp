# paw_ansible_role_redis
# @summary Manage paw_ansible_role_redis configuration
#
# @param ansible_managed
# @param redis_daemon
# @param redis_port
# @param redis_bind_interface
# @param redis_unixsocket
# @param redis_timeout
# @param redis_loglevel
# @param redis_logfile
# @param redis_databases
# @param save
# @param redis_rdbcompression
# @param redis_dbfilename
# @param redis_dbdir
# @param redis_maxmemory
# @param redis_maxmemory_policy
# @param redis_maxmemory_samples
# @param redis_appendonly
# @param redis_appendfsync
# @param include
# @param redis_requirepass Require authentication to Redis with a password.
# @param redis_disabled_command
# @param redis_extra_config
# @param redis_enablerepo Used for RHEL/CentOS/Fedora only. Allows the use of different repos.
# @param redis_enabled
# @param redis_save Set to an empty set to disable persistence (saving the DB to disk).
# @param redis_includes Add extra include files for local configuration/overrides.
# @param redis_disabled_commands Disable certain Redis commands for security reasons.
# @param par_vardir Base directory for Puppet agent cache (uses lookup('paw::par_vardir') for common config)
# @param par_tags An array of Ansible tags to execute (optional)
# @param par_skip_tags An array of Ansible tags to skip (optional)
# @param par_start_at_task The name of the task to start execution at (optional)
# @param par_limit Limit playbook execution to specific hosts (optional)
# @param par_verbose Enable verbose output from Ansible (optional)
# @param par_check_mode Run Ansible in check mode (dry-run) (optional)
# @param par_timeout Timeout in seconds for playbook execution (optional)
# @param par_user Remote user to use for Ansible connections (optional)
# @param par_env_vars Additional environment variables for ansible-playbook execution (optional)
# @param par_logoutput Control whether playbook output is displayed in Puppet logs (optional)
# @param par_exclusive Serialize playbook execution using a lock file (optional)
class paw_ansible_role_redis (
  Optional[String] $ansible_managed = undef,
  Optional[String] $redis_daemon = undef,
  Integer $redis_port = 6379,
  String $redis_bind_interface = '127.0.0.1',
  Optional[String] $redis_unixsocket = undef,
  Integer $redis_timeout = 300,
  String $redis_loglevel = 'notice',
  String $redis_logfile = '/var/log/redis/redis-server.log',
  Integer $redis_databases = 16,
  Optional[String] $save = undef,
  String $redis_rdbcompression = 'yes',
  String $redis_dbfilename = 'dump.rdb',
  String $redis_dbdir = '/var/lib/redis',
  Integer $redis_maxmemory = 0,
  String $redis_maxmemory_policy = 'noeviction',
  Integer $redis_maxmemory_samples = 5,
  String $redis_appendonly = 'no',
  String $redis_appendfsync = 'everysec',
  Optional[String] $include = undef,
  Optional[String] $redis_requirepass = undef,
  Optional[String] $redis_disabled_command = undef,
  Optional[String] $redis_extra_config = undef,
  String $redis_enablerepo = 'epel',
  Boolean $redis_enabled = true,
  Array $redis_save = ['900 1', '300 10', '60 10000'],
  Array $redis_includes = [],
  Array $redis_disabled_commands = [],
  Optional[Stdlib::Absolutepath] $par_vardir = undef,
  Optional[Array[String]] $par_tags = undef,
  Optional[Array[String]] $par_skip_tags = undef,
  Optional[String] $par_start_at_task = undef,
  Optional[String] $par_limit = undef,
  Optional[Boolean] $par_verbose = undef,
  Optional[Boolean] $par_check_mode = undef,
  Optional[Integer] $par_timeout = undef,
  Optional[String] $par_user = undef,
  Optional[Hash] $par_env_vars = undef,
  Optional[Boolean] $par_logoutput = undef,
  Optional[Boolean] $par_exclusive = undef
) {
# Execute the Ansible role using PAR (Puppet Ansible Runner)
# Playbook synced via pluginsync to agent's cache directory
# Check for common paw::par_vardir setting, then module-specific, then default
$_par_vardir = $par_vardir ? {
  undef   => lookup('paw::par_vardir', Stdlib::Absolutepath, 'first', '/opt/puppetlabs/puppet/cache'),
  default => $par_vardir,
}
$playbook_path = "${_par_vardir}/lib/puppet_x/ansible_modules/ansible_role_redis/playbook.yml"

par { 'paw_ansible_role_redis-main':
  ensure        => present,
  playbook      => $playbook_path,
  playbook_vars => {
        'ansible_managed' => $ansible_managed,
        'redis_daemon' => $redis_daemon,
        'redis_port' => $redis_port,
        'redis_bind_interface' => $redis_bind_interface,
        'redis_unixsocket' => $redis_unixsocket,
        'redis_timeout' => $redis_timeout,
        'redis_loglevel' => $redis_loglevel,
        'redis_logfile' => $redis_logfile,
        'redis_databases' => $redis_databases,
        'save' => $save,
        'redis_rdbcompression' => $redis_rdbcompression,
        'redis_dbfilename' => $redis_dbfilename,
        'redis_dbdir' => $redis_dbdir,
        'redis_maxmemory' => $redis_maxmemory,
        'redis_maxmemory_policy' => $redis_maxmemory_policy,
        'redis_maxmemory_samples' => $redis_maxmemory_samples,
        'redis_appendonly' => $redis_appendonly,
        'redis_appendfsync' => $redis_appendfsync,
        'include' => $include,
        'redis_requirepass' => $redis_requirepass,
        'redis_disabled_command' => $redis_disabled_command,
        'redis_extra_config' => $redis_extra_config,
        'redis_enablerepo' => $redis_enablerepo,
        'redis_enabled' => $redis_enabled,
        'redis_save' => $redis_save,
        'redis_includes' => $redis_includes,
        'redis_disabled_commands' => $redis_disabled_commands
              },
  tags          => $par_tags,
  skip_tags     => $par_skip_tags,
  start_at_task => $par_start_at_task,
  limit         => $par_limit,
  verbose       => $par_verbose,
  check_mode    => $par_check_mode,
  timeout       => $par_timeout,
  user          => $par_user,
  env_vars      => $par_env_vars,
  logoutput     => $par_logoutput,
  exclusive     => $par_exclusive,
}
}
