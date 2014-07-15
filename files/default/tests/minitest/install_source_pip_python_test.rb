#
# Cookbook Name:: duplicity_ng
# Test:: install_package
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

require File.expand_path('../support/helpers', __FILE__)

describe 'duplicity_ng::install' do
  include Helpers::TestHelper

  it 'installs duplicity package from source using pip via python' do
    cmd = shell_out('/usr/local/bin/pip list |grep -q duplicity')
    cmd.exitstatus.to_s.must_include('0')
  end

end
