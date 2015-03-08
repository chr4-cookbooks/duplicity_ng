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
    # Determine whether the current node has the "use_pip" attribute set.
    #
    # @return [Boolean]
    #
    def pip?
      node['duplicity_ng']['use_pip']
    end

    def min_python_version(version)
      Gem::Version.new(version) <= Gem::Version.new(node['python']['version'])
    end
  end
end
