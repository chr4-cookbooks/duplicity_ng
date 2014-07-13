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

node['duplicity_ng']['source']['dev']['packages'].each do |name|
  package name
end

python_bin = "python"

if Chef::Provider.const_defined?("PythonPip")
  python_pip "lockfile"
  gpg_source = "GnuPGInterface-#{node['duplicity_ng']['source']['gnupg']['version']}.tar.gz"
  remote_file "#{Chef::Config[:file_cache_path]}/#{gpg_source}" do
    source node['duplicity_ng']['source']['gnupg']['url']
    action :create
    notifies :install, "python_pip[install_gnupginterface]", :immediately
  end
  python_pip "install_gnupginterface" do
    package_name "#{Chef::Config[:file_cache_path]}/#{gpg_source}"
    action :nothing
  end
  python_pip "paramiko"
  python_bin = node["python"]["binary"]
else
  node['duplicity_ng']['source']['python']['packages'].each do |name|
    package name
  end
end

remote_file "#{Chef::Config[:file_cache_path]}/duplicity-#{node['duplicity_ng']['source']['version']}.tar.gz" do
  source node['duplicity_ng']['source']['url']
  checksum node['duplicity_ng']['source']['checksum']
  action :create
  notifies :run, "bash[compile_duplicity_from_source]", :immediately
end

bash "compile_duplicity_from_source" do
  cwd Chef::Config[:file_cache_path]
  code <<-EOH
    tar -xvf duplicity-#{node['duplicity_ng']['source']['version']}.tar.gz
    cd duplicity-#{node['duplicity_ng']['source']['version']}
    #{python_bin} setup.py install
  EOH
  action :nothing
end
