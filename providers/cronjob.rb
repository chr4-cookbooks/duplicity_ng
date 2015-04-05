#
# Cookbook Name:: duplicity_ng
# Provider:: cronjob
#
# Copyright (C) 2014 Chris Aumann
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

action :create do
  # Check for dependencies
  run_context.include_recipe 'duplicity_ng::install_boto'  if boto?(new_resource.backend)
  run_context.include_recipe 'duplicity_ng::install_ftp'   if ftp?(new_resource.backend)
  run_context.include_recipe 'duplicity_ng::install_swift' if swift?(new_resource.backend)
  run_context.include_recipe 'duplicity_ng::install_azure' if azure?(new_resource.backend)

  directory ::File.dirname(new_resource.logfile) do
    mode 00755
  end

  # Deploy configuration
  template "#{node['duplicity_ng']['confdir']}/duplicity-#{new_resource.name}" do
    mode      00600
    source    'environment.erb'
    cookbook  'duplicity_ng'
    sensitive true
    variables backend: new_resource.backend,
              duplicity_path: new_resource.duplicity_path,
              passphrase: new_resource.passphrase,
              archive_dir: new_resource.archive_dir,
              temp_dir: new_resource.temp_dir,
              swift_username: new_resource.swift_username,
              swift_password: new_resource.swift_password,
              swift_authurl: new_resource.swift_authurl,
              aws_access_key_id: new_resource.aws_access_key_id,
              aws_secret_access_key: new_resource.aws_secret_access_key,
              gs_access_key_id: new_resource.gs_access_key_id,
              gs_secret_access_key: new_resource.gs_secret_access_key,
              azure_account_name: new_resource.azure_account_name,
              azure_account_key: new_resource.azure_account_key,
              cipher_algo: new_resource.cipher_algo,
              digest_algo: new_resource.digest_algo,
              compress_algo: new_resource.compress_algo,
              compress_level: new_resource.compress_level
  end

  # Deploy cronjob
  template "/etc/cron.#{new_resource.interval}/duplicity-#{new_resource.name}" do
    mode     00750
    source   new_resource.source
    cookbook new_resource.cookbook

    if new_resource.variables.empty?
      variables configfile: "#{node['duplicity_ng']['confdir']}/duplicity-#{new_resource.name}",
                archive_dir: new_resource.archive_dir,
                temp_dir: new_resource.temp_dir,
                logfile: new_resource.logfile,
                include: new_resource.include,
                exclude: new_resource.exclude,
                full_backup_if_older_than: new_resource.full_backup_if_older_than,
                nice: new_resource.nice,
                ionice: new_resource.ionice,
                keep_full: new_resource.keep_full,
                exec_pre: new_resource.exec_pre,
                exec_before: new_resource.exec_before,
                exec_after: new_resource.exec_after
    else
      variables new_resource.variables
    end
  end

  if new_resource.configure_zabbix
    zabbix_agent_userparam "duplicity-#{new_resource.name}" do
      identifier "duplicity.#{new_resource.name}.last_backup"

      command <<-EOS
        expr $(date "+%s") - $(date --date "$( \
          sudo duplicity collection-status \
            --archive-dir #{new_resource.archive_dir} \
            --tempdir #{new_resource.temp_dir} #{new_resource.backend} \
          |tail -n3 |head -n1 |sed -r 's/^\\s+\\S+\\s+(\\w+\\s+\\w+\\s+\\w+\\s+\\S+\\s+\\w+).*$/\\1/' \
        )" "+%s")
      EOS
    end

    # Zabbix user needs root access to check backup status (tmpfiles)
    sudo 'zabbix_duplicity' do
      user     'zabbix'
      nopasswd true
      commands ["#{new_resource.duplicity_path} collection-status *"]
    end
  end
  new_resource.updated_by_last_action(true)
end

action :delete do
  file "/etc/cron.#{new_resource.interval}/duplicity-#{new_resource.name}" do
    action :delete
  end

  file "#{node['duplicity_ng']['confdir']}/duplicity-#{new_resource.name}" do
    action :delete
  end

  if new_resource.configure_zabbix
    zabbix_agent_userparam "duplicity-#{new_resource.name}" do
      action :delete
    end

    sudo 'zabbix_duplicity' do
      action  :remove
      only_if 'ls /etc/zabbix/zabbix_agentd.conf.d/duplicity_*.conf &> /dev/null'
    end
  end
  new_resource.updated_by_last_action(true)
end

def boto?(backend)
  backend.include?('s3://') || backend.include?('s3+http://') || backend.include?('gs://')
end

def ftp?(backend)
  backend.include?('ftp://')
end

def swift?(backend)
  backend.include?('swift://')
end

def azure?(backend)
  backend.include?('azure://')
end
