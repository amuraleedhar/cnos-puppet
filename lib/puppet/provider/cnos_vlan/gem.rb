# Copyright (c) 2017, Lenovo. All rights reserved.
#
# This program and the accompanying materials are licensed and made available
# under the terms and conditions of the 3-clause BSD License that accompanies
# this distribution. The full text of the license may be found at
#
# https://opensource.org/licenses/BSD-3-Clause
#
# THE PROGRAM IS DISTRIBUTED UNDER THE BSD LICENSE ON AN "AS IS" BASIS, WITHOUT
# WARRANTIES OR REPRESENTATIONS OF ANY KIND, EITHER EXPRESS OR IMPLIED.

require 'puppet/type'
require 'cnos-rbapi/vlan'
require File.join(File.dirname(__FILE__), '../cnos')
require 'json'


Puppet::Type.type(:cnos_vlan).provide(:vlan, parent: Puppet::Provider::Cnos) do
  desc 'Manage Vlan on Lenovo CNOS. Requires cnos-rbapi'

  #confine operatingsystem: [:ubuntu]

  #mk_resource_methods

  def self.instances
    instances = []
    vlan_total = {}
    #conn = Connect.new('./cnos/config.yml')
    #resp = Vlan.get_all_vlan(conn)
    #resp = get_all_vlan()
    vlans = Puppet::Provider::Cnos.call_items("/nos/api/cfg/vlan")
    #resp = Puppet::Provider::Cnos.call("/nos/api/cfg/vlan")
    #Puppet.notice("Vlans are "+vlans.to_s)
    return [] if vlans.nil?
    vlans.each do |item|
      Puppet.notice("Vlan Id is "+ item['vlan_id'].to_s)
      Puppet.notice("Vlan name is "+ item['vlan_name'].to_s)
      Puppet.notice("Admin State is "+ item['admin_state'].to_s)
      instances << new(name: item['vlan_id'].to_s,
                       vlan_name: item['vlan_name'],
                       ensure: :present,
                       admin_state: item['admin_state'])
    end
    return instances

  end

  def self.prefetch(resources)
    Puppet.notice("I am coming prefetch")
    vlans = instances
    Puppet.notice("prefetch vlans "+vlans.to_s)
    Puppet.notice("prefetch resource keys"+resources.keys.to_s)
    resources.keys.each do |name|
      Puppet.notice("prefetch vlan "+ vlans.first.to_s)
      if provider = vlans.find { |vlan| vlan.name == name }
        Puppet.notice("Prefetch data coming here is"+provider)
        resources[name].provider = provider
      end
    end
  end

  def flush
    Puppet.notice("I am coming flush")
    params = {}
    if @property_hash != {}
      #conn = Connect.new('./cnos/config.yml')
      if resource[:vlan_name] != nil
        params['vlan_name'] = resource[:vlan_name]
      end
      if resource[:admin_state] != nil
        params['admin_state'] = resource[:admin_state]
      end
      #resp = Vlan.update_vlan(conn, resource[:vlan_id], params)
    end
    @property_hash = resource.to_hash
  end

  def create
    #conn = Connect.new('./cnos/config.yml')
    Puppet.notice("I am coming create")
    params = { "vlan_id" => resource[:vlan_id].to_i,
               "vlan_name" => resource[:vlan_name],
               "admin_state" => resource[:admin_state] }
    #Vlan.create_vlan(conn, params)
    @property_hash.clear
  end

  def exists?
    Puppet.notice("I am coming exists")
    @property_hash[:ensure] == :present
  end

  def destroy
    Puppet.notice("I am coming destroy")
    #Vlan.delete_vlan(conn, resource[:vlan_id])
    @property_hash.clear
  end
end
