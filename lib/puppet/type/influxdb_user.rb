#
# Author: Sven Johansson <sven.johansson@ionos.com>
# 
# Current Status :
# Right now, only user's presence is managed. 
# If a user is going to be created, password and privileges will be set initially.
# Changes on password and privileges are not yet tracked.
# Not yet implemented at all:
# admin => true/false
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License. You may obtain
# a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations
# under the License.

Puppet::Type.newtype(:influxdb_user) do
  @doc = "Manage User in InfluxDB"

  ensurable do
    defaultvalues
    defaultto :present
  end

  newparam(:name, :namevar => true) do
    desc "The name of the User."
    newvalues(/^[\S]+$/)
  end

  newparam(:password) do
      desc "The User's password"
  end

  newparam(:privileges) do
      desc "The User's privileges"
  end

  newparam(:admin) do
      desc "Admin User"
      defaultto false
  end

  autorequire(:service) do
    'influxdb'
  end

end
