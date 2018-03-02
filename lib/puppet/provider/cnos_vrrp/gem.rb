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
require File.join(File.dirname(__FILE__), '../cnos')
require 'json'


Puppet::Type.type(:cnos_vrrp).provide(:gem, parent: Puppet::Provider::Cnos) do
  desc 'Manage VRRP on Lenovo CNOS. Requires cnos-rbapi'

  #confine operatingsystem: [:ubuntu]

  #mk_resource_methods

  def self.instances
    instances = []
    #conn = Connect.new('./config.yml')
    #resp = Vrrp.get_vrrp_prop_all(conn)
    resp = Puppet::Provider::Cnos.get_vrrp_prop_all()
    return 'no vrrp' if !resp
    resp.each do |item|
      Puppet.debug("VRRP Id is "+ item['vr_id'].to_s)
      Puppet.debug("If name is "+ item['if_name'].to_s)
      Puppet.debug("Ip Address is "+ item['ip_addr'].to_s)
      instances << new(name: item['vr_id'].to_s,
                       vr_id: item['vr_id'],
                       if_name: item['if_name'],
                       ensure: :present,
                       ip_addr: item['ip_addr'],
                       ad_intvl: item['ad_intvl'],
                       preempt: item['preempt'],
                       prio: item['prio'],
                       admin_state: item['admin_state'],
                       track_if: item['track_if'],
                       accept_mode: item['accept_mode'],
                       switch_back_delay: item['switch_back_delay'],
                       v2_compt: item['v2_compt'])
    end
    return instances
  end

  def self.prefetch(resources)
    Puppet.debug("I am inside prefetch")
    vrrps = instances
    resources.keys.each do |name|
      Puppet.debug("prefetch vrrps "+ vrrps.first.to_s)
      if provider = vrrps.find { |vrrp| vrrp.name == name }
        Puppet.debug("prefetch vrrp "+ vlans.first.to_s)
        resources[name].provider = provider
      end
    end
  end

  def params_setup
    params = {}
    params['if_name'] = resource[:if_name]
    params['vr_id'] = resource[:vr_id].to_i
    if resource[:ad_intvl] != nil
      params['ad_intvl'] = resource[:ad_intvl]
    end
    if resource[:ip_addr] != nil
      params['ip_addr'] = resource[:ip_addr]
    end
    if resource[:preempt] != nil
      params['preempt'] = resource[:preempt]
    end
    if resource[:prio] != nil
      params['prio'] = resource[:prio]
    end
    if resource[:admin_state] != nil
      params['admin_state'] = resource[:admin_state]
    end
    if resource[:track_if] != nil
      params['track_if'] = resource[:track_if]
    end
    if resource[:accept_mode] != nil
      params['accept_mode'] = resource[:accept_mode]
    end
    if resource[:switch_back_delay] != nil
      params['switch_back_delay'] = resource[:switch_back_delay]
    end
    if resource[:v2_compt] != nil
      params['v2_compt'] = resource[:v2_compt]
    end
    return params
  end

  def flush
    Puppet.debug("I am inside flush")
    if @property_hash != {}
      #conn = Connect.new('./config.yml')
      params = params_setup
      #resp = Vrrp.update_vrrp_intf_vrid(conn, resource[:if_name], resource[:vr_id], params)
      resp = Puppet::Provider::Cnos.update_vrrp_intf_vrid(resource[:if_name], resource[:vr_id], params)
    end
    @property_hash = resource.to_hash
  end

  def create
    #conn = Connect.new('./config.yml')
    Puppet.debug("I am inside create")
    params = params_setup
    #Vrrp.create_vrrp_intf(conn, resource[:if_name], params)
    resp = Puppet::Provider::Cnos.create_vrrp_intf(resource[:if_name], params)
    @property_hash.clear
  end

  def exists?
    Puppet.debug("I am inside exists")
    @property_hash[:ensure] == :present
  end

  def destroy
    Puppet.debug("I am inside destroy")
    #conn = Connect.new('./config.yml')
    #Vrrp.del_vrrp_intf_vrid(conn, resource[:if_name], resource[:vr_id])
    resp = Puppet::Provider::Cnos.del_vrrp_intf_vrid(resource[:if_name], resource[:vr_id])
    @property_hash.clear
  end
end
