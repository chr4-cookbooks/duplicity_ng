#
# Cookbook Name:: duplicity_ng
# Recipe:: install_azure
#
# Copyright (C) 2015 Alexander Merkulov
# Copyright (C) 2015 Chris Aumann
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

# Install Azure-specific packages
node['duplicity_ng']['source']['azure']['packages'].each { |n| package n }

# Install Azure library

if pip? && min_python_version('2.7.0')
  python_pip 'azure'
elsif min_python_version('2.7.0')
  remote_file "#{Chef::Config[:file_cache_path]}/azure-v#{node['duplicity_ng']['source']['azure']['version']}.tar.gz" do
    source   node['duplicity_ng']['source']['azure']['url']
    checksum node['duplicity_ng']['source']['azure']['checksum']
    action   :create
    notifies :run, 'bash[install_azure_from_source]', :immediately
  end

  bash 'install_azure_from_source' do
    cwd Chef::Config[:file_cache_path]
    code <<-EOH
      tar -xvf azure-v#{node['duplicity_ng']['source']['azure']['version']}.tar.gz
      cd azure-sdk-for-python-#{node['duplicity_ng']['source']['azure']['version']}
      python setup.py install
      cd ..
      rm -rf ./azure-sdk-for-python-#{node['duplicity_ng']['source']['azure']['version']}
    EOH
    action :nothing
  end
end
