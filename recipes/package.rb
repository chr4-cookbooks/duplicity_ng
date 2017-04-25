#
# Cookbook Name:: duplicity_ng
# Recipe:: package
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

# for package + pip addons install
if pip?
  python_runtime 'system' do
    provider :system
    version '2'
    options dev_package: true
  end

  package node['duplicity_ng']['source']['dev']['packages'] do
    action :install
  end
end

package 'duplicity'
