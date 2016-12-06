#
# Cookbook Name:: duplicity_ng
# Provider:: boto
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

use_inline_resources

action :create do
  template '/etc/boto.cfg' do
    mode     0o640
    source   new_resource.source
    cookbook new_resource.cookbook

    if new_resource.variables.empty?
      variables aws_access_key_id: new_resource.aws_access_key_id,
                aws_secret_access_key: new_resource.aws_secret_access_key,
                gs_access_key_id: new_resource.gs_access_key_id,
                gs_secret_access_key: new_resource.gs_secret_access_key,
                options: new_resource.options
    else
      variables new_resource.variables
    end
  end
  new_resource.updated_by_last_action(true)
end

action :delete do
  file '/etc/boto.cfg' do
    action :delete
  end
  new_resource.updated_by_last_action(true)
end
