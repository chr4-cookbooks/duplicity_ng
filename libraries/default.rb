#
# Cookbook Name:: duplicity_ng
# Library:: default
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
#

include Chef::Mixin::ShellOut

class Chef
  #
  # Base helpers to cleanup recipe logic.
  #
  class Recipe
    #
    # Determine if the current node using old RHEL.
    #
    # @return [Boolean]
    #
    def rhel510?
      platform_family?('rhel') && node['platform_version'].to_f < 6.0
    end

    #
    # Determine if the current node is use Python from sources.
    #
    # @return [Boolean]
    #
    def python_source?
      node['recipes'].include?('python::source') || node['python']['install_method'].include?('source')
    end

    #
    # Determine if the current node is use Python PIP.
    #
    # @return [Boolean]
    #
    def pip?
      node['duplicity_ng']['use_pip']
    end
  end
end
