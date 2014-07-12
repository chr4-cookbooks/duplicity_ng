#
# Cookbook Name:: duplicity_ng
# Recipe:: install_boto
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

# Install Boto library

if node['duplicity_ng']['install_method'].include? "source"
  if Chef::Provider.const_defined?("PythonPip")
    python_pip "boto"
  else
    package "python-boto"
  end
else
  package 'python-boto'
end
