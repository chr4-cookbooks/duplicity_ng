#
# Cookbook Name:: duplicity_ng
# Resource:: boto
#
# Copyright (C) 2014 Alexander Merkulov
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
attribute :cookbook,         kind_of: String, default: 'duplicity_ng'
attribute :source,           kind_of: String, default: 'boto.cfg.erb'
attribute :variables,        kind_of: Hash,   default: {}
attribute :params,           kind_of: Hash,   default: {}

# S3 backend parameters
attribute :aws_access_key_id,     kind_of: String, default: nil
attribute :aws_secret_access_key, kind_of: String, default: nil

# Google Cloud Storage backend parameters
attribute :gs_access_key_id,     kind_of: String, default: nil
attribute :gs_secret_access_key, kind_of: String, default: nil
