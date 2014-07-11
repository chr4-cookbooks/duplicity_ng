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
  # Install duplicity, and backend-specific packages
   if node['duplicity_ng']['install_method'].include? "source"
     package "librsync-devel"
     package "python-lockfile"
      remote_file "#{Chef::Config[:file_cache_path]}/duplicity-#{node['duplicity_ng']['source']['version']}.tar.gz" do
        source node['duplicity_ng']['source']['url']
        checksum node['duplicity_ng']['source']['checksum']
        action :create
      end
      bash "compile_duplicity_from_source" do
        cwd Chef::Config[:file_cache_path]
        code <<-EOH
          tar -xvf duplicity-#{node['duplicity_ng']['source']['version']}.tar.gz
          cd duplicity-#{node['duplicity_ng']['source']['version']}
          python setup install
        EOH
        not_if FileTest.exists?(new_resource.duplicity_path)
      end
    else
      package 'duplicity'
    end
  package 'ncftp' if new_resource.backend.include?('ftp://')
  package 'python-swiftclient' if new_resource.backend.include?('swift://')
  package 'python-boto' if new_resource.backend.include?('s3://') || new_resource.backend.include?('s3+http://')

  directory ::File.dirname(new_resource.logfile) do
    mode 00755
  end

  template "/etc/cron.#{new_resource.interval}/duplicity-#{new_resource.name}" do
    mode     '0750'
    source   new_resource.source
    cookbook new_resource.cookbook

    if new_resource.variables.empty?
      variables logfile: new_resource.logfile,
                backend: new_resource.backend,
                passphrase: new_resource.passphrase,
                include: new_resource.include,
                exclude: new_resource.exclude,
                archive_dir: new_resource.archive_dir,
                temp_dir: new_resource.temp_dir,
                full_backup_if_older_than: new_resource.full_backup_if_older_than,
                nice: new_resource.nice,
                ionice: new_resource.ionice,
                keep_full: new_resource.keep_full,
                swift_username: new_resource.swift_username,
                swift_password: new_resource.swift_password,
                swift_authurl: new_resource.swift_authurl,
                aws_access_key_id: new_resource.aws_access_key_id,
                aws_secret_access_key: new_resource.aws_secret_access_key,
                aws_eu: new_resource.aws_eu ? "--s3-use-new-style --s3-european-buckets" : "",
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
      command    %\expr $(date "+%s") - $(date --date "$(\ +
                 %(sudo duplicity collection-status --archive-dir #{new_resource.archive_dir} --tempdir #{new_resource.temp_dir} #{new_resource.backend} |) +
                 %#tail -n3 |head -n1 |sed -r 's/^\\s+\\S+\\s+(\\w+\\s+\\w+\\s+\\w+\\s+\\S+\\s+\\w+).*$/\\1/'# +
                 %\)" "+%s")\
    end

    # Zabbix user needs root access to check backup status (tmpfiles)
    sudo 'zabbix_duplicity' do
      user     'zabbix'
      nopasswd true
      commands ["#{new_resource.duplicity_path} collection-status *"]
    end
  end
end

action :delete do
  file "/etc/cron.#{new_resource.interval}/duplicity-#{new_resource.name}" do
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
end
