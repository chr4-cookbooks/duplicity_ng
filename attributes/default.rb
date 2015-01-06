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

# Path to duplicity executeable
default['duplicity_ng']['path'] = '/usr/bin/duplicity'

# Path where duplicity configuration (credential environment variables, etc) are stored
default['duplicity_ng']['confdir'] = value_for_platform_family(
 'debian' => '/etc/default',
 'rhel' => '/etc/sysconfig',
 'default' => '/etc',
)

# Set this to true to use pip to install duplicity dependencies
default['duplicity_ng']['use_pip'] = false

# Variables for installing duplicity from source
default['duplicity_ng']['source']['checksum'] = '5d4e9329a6d793880909d18b0736ff06'
default['duplicity_ng']['source']['version'] = '0.6.24'
default['duplicity_ng']['source']['url'] = "https://launchpad.net/duplicity/0.6-series/#{node['duplicity_ng']['source']['version']}/+download/duplicity-#{node['duplicity_ng']['source']['version']}.tar.gz" # rubocop:disable Metrics/LineLength

default['duplicity_ng']['source']['gnupg']['version'] = '0.3.2'
default['duplicity_ng']['source']['gnupg']['url'] = "http://switch.dl.sourceforge.net/project/py-gnupg/GnuPGInterface/#{node['duplicity_ng']['source']['gnupg']['version']}/GnuPGInterface-#{node['duplicity_ng']['source']['gnupg']['version']}.tar.gz" # rubocop:disable Metrics/LineLength
default['duplicity_ng']['source']['gnupg']['checksum'] = 'd4627d83446f96bd8c22f8d15db3f7c2'

case node['platform_family']
when 'debian'
  default['duplicity_ng']['source']['dev']['packages'] = %w(python-dev librsync-dev)
  default['duplicity_ng']['source']['python']['packages'] = %w(python-lockfile python-setuptools python-gnupginterface python-paramiko)
when 'rhel', 'fedora', 'suse'
  # Use pip by default on rhel, as the packages are outdated
  default['duplicity_ng']['use_pip'] = true
  default['duplicity_ng']['source']['dev']['packages'] = %w(python-devel librsync-devel)
  default['duplicity_ng']['source']['python']['packages'] = %w(python-lockfile python-setuptools python-GnuPGInterface python-paramiko)
end
