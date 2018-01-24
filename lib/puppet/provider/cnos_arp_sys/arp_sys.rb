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
require 'cnos-rbapi'
require 'cnos-rbapi/arp'

Puppet::Type.type(:cnos_arp_sys).provide :arp_sys do
  desc 'Manage Arp_sys on Lenovo CNOS. Requires cnos-rbapi'

  confine operatingsystem: [:ubuntu]

  def ageout_time
    conn = Connect.new('./config.yml')
    resp = Arp.get_arp_sys_prop(conn)
    resp['ageout_time']
  end

  def ageout_time=(value)
    conn = Connect.new('./config.yml')
    params = { 'ageout_time' => resource[:ageout_time] }
    resp = Arp.set_arp_sys_prop(conn, params)
  end
end
