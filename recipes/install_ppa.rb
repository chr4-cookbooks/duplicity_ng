#
# Cookbook Name:: duplicity_ng
# Recipe:: install_ppa
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

# Setup official duplicity PPA, which features newer versions of duplicity
apt_repository 'duplicity-ppa' do
  uri 'http://ppa.launchpad.net/duplicity-team/ppa/ubuntu'
  distribution node['lsb']['codename']
  components ['main']
  keyserver 'keyserver.ubuntu.com'
  key '7A86F4A2'
end

# The package python-swiftclient is not available on Ubuntu < 12.10.
# It's available in OpenStacks Folsom stable PPA, though
apt_repository 'openstack-ppa' do
  uri 'http://ppa.launchpad.net/openstack-ubuntu-testing/folsom-stable-testing/ubuntu'
  distribution node['lsb']['codename']
  components ['main']
  keyserver 'keyserver.ubuntu.com'
  key '3B6F61A6'
  only_if { node['platform'] == 'ubuntu' && node['platform_version'].to_f < 12.10 }
end
