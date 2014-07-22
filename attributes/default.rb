#
# Cookbook Name:: duplicity_ng
# Attributes:: default
#
# Copyright (C) 2014 Chris Aumann
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

default['duplicity_ng']['install_method'] = 'package' # Can be "source" or "package"
default['duplicity_ng']['binary'] = '/usr/bin/duplicity'

# Path to duplicity executeable
default['duplicity_ng']['path'] = '/usr/bin/duplicity'
default['duplicity_ng']['source']['use_pip'] = false # If true then we try to use pip
default['duplicity_ng']['source']['checksum'] = '5d4e9329a6d793880909d18b0736ff06'
default['duplicity_ng']['source']['version'] = '0.6.24'
default['duplicity_ng']['source']['url'] = "https://launchpad.net/duplicity/0.6-series/#{node['duplicity_ng']['source']['version']}/+download/duplicity-#{node['duplicity_ng']['source']['version']}.tar.gz" # rubocop:disable Style/LineLength
default['duplicity_ng']['source']['gnupg']['version'] = '0.3.2'
default['duplicity_ng']['source']['gnupg']['url'] = "http://switch.dl.sourceforge.net/project/py-gnupg/GnuPGInterface/#{node['duplicity_ng']['source']['gnupg']['version']}/GnuPGInterface-#{node['duplicity_ng']['source']['gnupg']['version']}.tar.gz" # rubocop:disable Style/LineLength
default['duplicity_ng']['source']['gnupg']['checksum'] = 'd4627d83446f96bd8c22f8d15db3f7c2'

case node['platform_family']
when 'debian'
  python_dev = 'python-dev'
  default['duplicity_ng']['source']['dev']['packages'] = %w( librsync-dev )
  default['duplicity_ng']['source']['python']['dev'] = python_dev
  default['duplicity_ng']['source']['python']['packages'] = [python_dev, 'python-lockfile', 'python-gnupginterface', 'python-paramiko']
when 'rhel', 'fedora', 'suse'
  python_dev = 'python-devel'
  default['duplicity_ng']['source']['use_pip'] = true # Because here old packages
  default['duplicity_ng']['source']['dev']['packages'] = %w( librsync-devel )
  default['duplicity_ng']['source']['python']['dev'] = python_dev
  default['duplicity_ng']['source']['python']['packages'] = [python_dev, 'python-lockfile', 'python-GnuPGInterface', 'python-paramiko']
end
