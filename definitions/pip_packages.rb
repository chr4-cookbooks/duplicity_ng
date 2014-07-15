#
# Cookbook Name:: duplicity_ng
# Definition:: pip_packages
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

define :pip_packages do
  python_pip 'lockfile'
  gpg_source_file = "#{Chef::Config[:file_cache_path]}/GnuPGInterface-#{node['duplicity_ng']['source']['gnupg']['version']}.tar.gz"
  remote_file gpg_source_file do
    source   node['duplicity_ng']['source']['gnupg']['url']
    checksum node['duplicity_ng']['source']['gnupg']['checksum']
    action   :create
    notifies :install, 'python_pip[install_gnupginterface]', :immediately
  end
  python_pip 'install_gnupginterface' do
    package_name gpg_source_file
    action       :nothing
  end
  python_pip 'paramiko'
end
