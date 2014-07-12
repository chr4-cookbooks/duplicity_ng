#
# Cookbook Name:: duplicity_ng
# Recipe:: source
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

# Install duplicity, and backend-specific packages


package "librsync-devel"

python_bin = "python"

if Chef::Provider.const_defined?("PythonPip")
  python_pip "lockfile"
  python_pip "GnuPGInterface" do
    package_name node['duplicity_ng']['source']['gnupg']["url"]
    action :install
  end
  python_pip "paramiko"
  python_bin = node["python"]["binary"]
else
  package "python-devel"
  package "python-lockfile"
  package "python-GnuPGInterface"
  package "python-paramiko"
end

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
    #{python_bin} setup.py install
  EOH
  not_if do ::FileTest.exists?(new_resource.duplicity_path) end
end
