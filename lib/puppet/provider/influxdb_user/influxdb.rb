# Copyright (C) 2018 Binero
#
# Author: Tobias Urdin <tobias.urdin@binero.se>
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

require 'puppet'
require 'json'

require File.expand_path(File.join(File.dirname(__FILE__), '..', 'influxdb'))

Puppet::Type.type(:influxdb_user).provide(:influxdb, :parent => Puppet::Provider::InfluxDB) do
  desc "Provider for influxdb_user type"

  defaultfor :kernel => 'Linux'

  # @method base_url
  #   The base URL used by Puppet::Provider::InfluxDB
  def self.base_url
    'http://localhost:8086'
  end

  # @method create
  #   Create the user and set privileges
  def create
    q = "CREATE USER #{resource[:name]} WITH PASSWORD \'#{resource[:password]}\'"
    response = self.class.query(q)
    if response.code.to_i != 200
      raise Puppet::Error, "Failed to create InfluxDB User: #{resource[:name]} (HTTP response: #{response.code})"
    end
    q = "GRANT #{resource[:privileges]} TO #{resource[:name]}"
    response = self.class.query(q)
    if response.code.to_i != 200
      raise Puppet::Error, "Failed to set privileges for InfluxDB User: #{resource[:name]} (HTTP response: #{response.code})"
    end
  end

  # @method destroy
  #   Delete the user and revoke privileges
  def destroy
    q = "DROP USER #{resource[:name]}"
    response = self.class.query(q)
    if response.code.to_i != 200
      raise Puppet::Error, "Failed to delete InfluxDB user: #{resource[:name]} (HTTP response: #{response.code})"
    end
  end

  # @method exists?
  #   Check if the user exists
  def exists?
    unless @instances
      @instances = self.class.instances
    end
    @instances.any? {|prov| prov.name == resource[:name]}
  end

  # @method instances
  #   Get all InfluxDB user and create resources
  def self.instances
    users = self.users
    ret = users.collect do |user_name|
      new(:name => user_name)
    end
    ret
  end

  # @method prefetch
  #   Associate all the InfluxDB user resource with a resource
  def self.prefetch(resources)
    users = instances
    resources.keys.each do |name|
      if provider = users.find{ |user| user.name == name }
        resources[name].provider = provider
      end
    end
  end
end