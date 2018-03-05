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
#require 'cnos-rbapi/arp'
require File.join(File.dirname(__FILE__), '../cnos')
require 'json'

Puppet::Type.type(:cnos_arp_sys).provide(:gem, parent: Puppet::Provider::Cnos) do
  desc 'Manage Arp_sys on Lenovo CNOS. Requires cnos-rbapi'

  #confine operatingsystem: [:ubuntu]
  mk_resource_methods

  def ageout_time
    #conn = Connect.new('./config.yml')
    #resp = Arp.get_arp_sys_prop(conn)
    resp = Puppet::Provider::Cnos.get_arp_sys_prop()
    resp['ageout_time']
  end

  def ageout_time=(value)
    #conn = Connect.new('./config.yml')
    params = { 'ageout_time' => resource[:ageout_time] }
    #resp = Arp.set_arp_sys_prop(conn, params)
    resp = Puppet::Provider::Cnos.set_arp_sys_prop(params)
  end
end
