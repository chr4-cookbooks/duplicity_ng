#
# Cookbook Name:: duplicity_ng
# Resource:: cronjob
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

actions        :create, :delete
default_action :create

attribute :name,             kind_of: String, name_attribute: true
attribute :interval,         kind_of: String, default: 'daily'
attribute :cookbook,         kind_of: String, default: 'duplicity_ng'
attribute :source,           kind_of: String, default: 'cronjob.sh.erb'
attribute :variables,        kind_of: Hash,   default: {}
attribute :duplicity_path,   kind_of: String, default: '/usr/bin/duplicity'
attribute :configure_zabbix, kind_of: [TrueClass, FalseClass], default: false
attribute :logfile,          kind_of: String, default: '/dev/null'

# Duplicity parameters
attribute :backend,     kind_of: String,  required: true
attribute :passphrase,  kind_of: String,  required: true
attribute :include,     kind_of: Array,   default: %w(/etc/ /root/ /var/log/)
attribute :exclude,     kind_of: Array,   default: %w()
attribute :archive_dir, kind_of: String,  default: '/tmp/duplicity-archive'
attribute :temp_dir,    kind_of: String,  default: '/tmp/duplicity-tmp'
attribute :keep_full,   kind_of: Integer, default: 5
attribute :nice,        kind_of: Integer, default: 10
attribute :ionice,      kind_of: Integer, default: 3
attribute :full_backup_if_older_than, kind_of: String, default: '7D'

# Swift backend parameters
attribute :swift_username, kind_of: String, default: nil
attribute :swift_password, kind_of: String, default: nil
attribute :swift_authurl,  kind_of: String, default: nil

# S3 backend parameters
attribute :aws_access_key_id,     kind_of: String, default: nil
attribute :aws_secret_access_key, kind_of: String, default: nil

# Google Cloud Storage backend parameters
attribute :gs_access_key_id,     kind_of: String, default: nil
attribute :gs_secret_access_key, kind_of: String, default: nil

# Shell scripts that will be appended at the beginning/end of the cronjob
attribute :exec_pre,    kind_of: [String, Array], default: []
attribute :exec_before, kind_of: [String, Array], default: []
attribute :exec_after,  kind_of: [String, Array], default: []
