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
#require 'cnos-rbapi'
#require 'cnos-rbapi/lacp'
require File.join(File.dirname(__FILE__), '../cnos')
require 'json'

Puppet::Type.type(:cnos_lacp).provide(:gem, parent: Puppet::Provider::Cnos) do
  desc 'Manage Lacp on Lenovo CNOS. Requires cnos-rbapi'

  #confine operatingsystem: [:ubuntu]
  mk_resource_methods

  def sys_prio
    #conn = Connect.new('./config.yml')
    #resp = Lacp.get_lacp(conn)
    resp = Puppet::Provider::Cnos.get_lacp()
    resp['sys_prio']
  end

  def sys_prio=(value)
    #conn = Connect.new('./config.yml')
    params = { 'sys_prio' => resource[:sys_prio] }
    #resp = Lacp.update_lacp(conn, params)
    resp = Puppet::Provider::Cnos.update_lacp(params)
  end
end