#
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
# require 'cnos-rbapi'
# require 'cnos-rbapi/vlag'
require File.join(File.dirname(__FILE__), '../cnos')
require 'json'

Puppet::Type.type(:cnos_vlag).provide(:gem, parent: Puppet::Provider::Cnos) do
  desc 'Manage Vlag on Lenovo CNOS. Requires cnos-rbapi'

  # confine operatingsystem: [:ubuntu]

  mk_resource_methods

  def self.instances
    instances = []
    # conn = Connect.new('./config.yml')
    # resp = Vlag.get_all_vlag(conn)
    resp = Puppet::Provider::Cnos.get_all_vlag
    return 'no vlags' unless resp
    resp.each do |item|
      Puppet.debug('VLag Id is ' + item['inst_id'].to_s)
      Puppet.debug('port_aggregator is ' + item['port_aggregator'].to_s)
      Puppet.debug('status is ' + item['status'].to_s)
      instances << new(name: item['inst_id'].to_s,
                       port_aggregator: item['port_aggregator'],
                       ensure: :present,
                       status: item['status'])
    end
    instances
  end

  def self.prefetch(resources)
    Puppet.debug('I am inside prefetch')
    vlags = instances
    resources.keys.each do |name|
      if provider = vlags.find { |vlag| vlag.name == name }
        Puppet.debug("Prefetch data coming here is #{provider}")
        resources[name].provider = provider
      end
    end
  end

  def params_setup
    params = {}
    # conn = Connect.new('./config.yml')
    params['status'] = resource[:status] unless resource[:status].nil?
    unless resource[:port_aggregator].nil?
      params['port_aggregator'] = resource[:port_aggregator]
    end
    params
  end

  def flush
    if @property_hash
      # conn = Connect.new('./config.yml')
      Puppet.debug('I am inside flush')
      params = params_setup
      # resp = Vlag.update_vlag_inst(conn, resource[:inst_id], params)
      resp = Puppet::Provider::Cnos.update_vlag_inst(resource[:inst_id], params)
    end
    @property_hash = resource.to_hash
  end

  def create
    Puppet.debug('I am inside create')
    # conn = Connect.new('./config.yml')
    params = { 'inst_id' => resource[:inst_id].to_i,
               'port_aggregator' => resource[:port_aggregator],
               'status' => resource[:status] }
    # Vlag.create_vlag_inst(conn, params)
    Puppet::Provider::Cnos.create_vlag_inst(params)
    @property_hash.clear
  end

  def exists?
    Puppet.debug('I am inside exists')
    @property_hash[:ensure] == :present
  end

  def destroy
    # conn = Connect.new('./config.yml')
    Puppet.debug('I am inside destroy' + :inst_id.to_s)
    # Vlag.delete_vlag_inst(conn, resource[:inst_id])
    Puppet::Provider::Cnos.delete_vlag_inst(resource[:inst_id])
    @property_hash.clear
  end
end
