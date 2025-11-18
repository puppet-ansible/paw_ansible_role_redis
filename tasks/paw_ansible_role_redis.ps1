# Puppet task for executing Ansible role: ansible_role_redis
# This script runs the entire role via ansible-playbook

$ErrorActionPreference = 'Stop'

# Determine the ansible modules directory
if ($env:PT__installdir) {
  $AnsibleDir = Join-Path $env:PT__installdir "lib\puppet_x\ansible_modules\ansible_role_redis"
} else {
  # Fallback to Puppet cache directory
  $AnsibleDir = "C:\ProgramData\PuppetLabs\puppet\cache\lib\puppet_x\ansible_modules\ansible_role_redis"
}

# Check if ansible-playbook is available
$AnsiblePlaybook = Get-Command ansible-playbook -ErrorAction SilentlyContinue
if (-not $AnsiblePlaybook) {
  $result = @{
    _error = @{
      msg = "ansible-playbook command not found. Please install Ansible."
      kind = "puppet-ansible-converter/ansible-not-found"
    }
  }
  Write-Output ($result | ConvertTo-Json)
  exit 1
}

# Check if the role directory exists
if (-not (Test-Path $AnsibleDir)) {
  $result = @{
    _error = @{
      msg = "Ansible role directory not found: $AnsibleDir"
      kind = "puppet-ansible-converter/role-not-found"
    }
  }
  Write-Output ($result | ConvertTo-Json)
  exit 1
}

# Detect playbook location (collection vs standalone)
# Collections: ansible_modules/collection_name/roles/role_name/playbook.yml
# Standalone: ansible_modules/role_name/playbook.yml
$CollectionPlaybook = Join-Path $AnsibleDir "roles\paw_ansible_role_redis\playbook.yml"
$StandalonePlaybook = Join-Path $AnsibleDir "playbook.yml"

if ((Test-Path (Join-Path $AnsibleDir "roles")) -and (Test-Path $CollectionPlaybook)) {
  # Collection structure
  $PlaybookPath = $CollectionPlaybook
  $PlaybookDir = Join-Path $AnsibleDir "roles\paw_ansible_role_redis"
} elseif (Test-Path $StandalonePlaybook) {
  # Standalone role structure
  $PlaybookPath = $StandalonePlaybook
  $PlaybookDir = $AnsibleDir
} else {
  $result = @{
    _error = @{
      msg = "playbook.yml not found in $AnsibleDir or $AnsibleDir\roles\paw_ansible_role_redis"
      kind = "puppet-ansible-converter/playbook-not-found"
    }
  }
  Write-Output ($result | ConvertTo-Json)
  exit 1
}

# Build extra-vars from PT_* environment variables
$ExtraVars = @{}
if ($env:PT_ansible_managed) {
  $ExtraVars['ansible_managed'] = $env:PT_ansible_managed
}
if ($env:PT_redis_daemon) {
  $ExtraVars['redis_daemon'] = $env:PT_redis_daemon
}
if ($env:PT_redis_port) {
  $ExtraVars['redis_port'] = $env:PT_redis_port
}
if ($env:PT_redis_bind_interface) {
  $ExtraVars['redis_bind_interface'] = $env:PT_redis_bind_interface
}
if ($env:PT_redis_unixsocket) {
  $ExtraVars['redis_unixsocket'] = $env:PT_redis_unixsocket
}
if ($env:PT_redis_timeout) {
  $ExtraVars['redis_timeout'] = $env:PT_redis_timeout
}
if ($env:PT_redis_loglevel) {
  $ExtraVars['redis_loglevel'] = $env:PT_redis_loglevel
}
if ($env:PT_redis_logfile) {
  $ExtraVars['redis_logfile'] = $env:PT_redis_logfile
}
if ($env:PT_redis_databases) {
  $ExtraVars['redis_databases'] = $env:PT_redis_databases
}
if ($env:PT_save) {
  $ExtraVars['save'] = $env:PT_save
}
if ($env:PT_redis_rdbcompression) {
  $ExtraVars['redis_rdbcompression'] = $env:PT_redis_rdbcompression
}
if ($env:PT_redis_dbfilename) {
  $ExtraVars['redis_dbfilename'] = $env:PT_redis_dbfilename
}
if ($env:PT_redis_dbdir) {
  $ExtraVars['redis_dbdir'] = $env:PT_redis_dbdir
}
if ($env:PT_redis_maxmemory) {
  $ExtraVars['redis_maxmemory'] = $env:PT_redis_maxmemory
}
if ($env:PT_redis_maxmemory_policy) {
  $ExtraVars['redis_maxmemory_policy'] = $env:PT_redis_maxmemory_policy
}
if ($env:PT_redis_maxmemory_samples) {
  $ExtraVars['redis_maxmemory_samples'] = $env:PT_redis_maxmemory_samples
}
if ($env:PT_redis_appendonly) {
  $ExtraVars['redis_appendonly'] = $env:PT_redis_appendonly
}
if ($env:PT_redis_appendfsync) {
  $ExtraVars['redis_appendfsync'] = $env:PT_redis_appendfsync
}
if ($env:PT_include) {
  $ExtraVars['include'] = $env:PT_include
}
if ($env:PT_redis_requirepass) {
  $ExtraVars['redis_requirepass'] = $env:PT_redis_requirepass
}
if ($env:PT_redis_disabled_command) {
  $ExtraVars['redis_disabled_command'] = $env:PT_redis_disabled_command
}
if ($env:PT_redis_extra_config) {
  $ExtraVars['redis_extra_config'] = $env:PT_redis_extra_config
}
if ($env:PT_redis_enablerepo) {
  $ExtraVars['redis_enablerepo'] = $env:PT_redis_enablerepo
}
if ($env:PT_redis_enabled) {
  $ExtraVars['redis_enabled'] = $env:PT_redis_enabled
}
if ($env:PT_redis_save) {
  $ExtraVars['redis_save'] = $env:PT_redis_save
}
if ($env:PT_redis_includes) {
  $ExtraVars['redis_includes'] = $env:PT_redis_includes
}
if ($env:PT_redis_disabled_commands) {
  $ExtraVars['redis_disabled_commands'] = $env:PT_redis_disabled_commands
}

$ExtraVarsJson = $ExtraVars | ConvertTo-Json -Compress

# Execute ansible-playbook with the role
Push-Location $PlaybookDir
try {
  ansible-playbook playbook.yml `
    --extra-vars $ExtraVarsJson `
    --connection=local `
    --inventory=localhost, `
    2>&1 | Write-Output
  
  $ExitCode = $LASTEXITCODE
  
  if ($ExitCode -eq 0) {
    $result = @{
      status = "success"
      role = "ansible_role_redis"
    }
  } else {
    $result = @{
      status = "failed"
      role = "ansible_role_redis"
      exit_code = $ExitCode
    }
  }
  
  Write-Output ($result | ConvertTo-Json)
  exit $ExitCode
}
finally {
  Pop-Location
}
