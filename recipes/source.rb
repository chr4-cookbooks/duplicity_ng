#
# Cookbook Name:: duplicity_ng
# Recipe:: source
#
# Copyright (C) 2014 Alexander Merkulov
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

# Install build tools
include_recipe 'build-essential'

if pip?
  # Install duplicity, and backend-specific packages
  package node['duplicity_ng']['source']['dev']['packages'] do
    action :install
  end

  python_bin = 'system'

  python_runtime python_bin do
    provider :system
    version '2'
  end

  template "#{Chef::Config[:file_cache_path]}/duplicity_requirements.txt" do
    source 'duplicity_requirements.txt.erb'
    owner 'root'
    group 'root'
    mode 0o0644
  end

  pip_requirements "#{Chef::Config[:file_cache_path]}/duplicity_requirements.txt" do
    python python_bin
  end
else
  package node['duplicity_ng']['source']['python']['packages'] do
    action :install
  end

  remote_file "#{Chef::Config[:file_cache_path]}/duplicity-#{node['duplicity_ng']['source']['version']}.tar.gz" do
    source   node['duplicity_ng']['source']['url']
    checksum node['duplicity_ng']['source']['checksum']
    action   :create
    notifies :run, 'bash[compile_duplicity_from_source]', :immediately
  end

  bash 'compile_duplicity_from_source' do
    cwd Chef::Config[:file_cache_path]
    code <<-EOH
      tar -xvf duplicity-#{node['duplicity_ng']['source']['version']}.tar.gz
      cd duplicity-#{node['duplicity_ng']['source']['version']}
      #{python_bin} setup.py install
    EOH
    action :nothing
  end
end
