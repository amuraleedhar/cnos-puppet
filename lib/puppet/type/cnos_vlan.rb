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

Puppet::Type.newtype(:cnos_vlan) do
  desc ' = {
            Manage Vlans on Lenovo cnos.

            Example:
             cnos_vlan {1:
                     vlan_name => vlan1,
                     admin_state => up,
              }
           }'
  apply_to_device
  ensurable

  # Parameters
  #newproperty(:vlan_id, namevar: true) do
  newparam(:vlan_id, namevar: true) do
    desc 'vlan_id an integer from 2-3999'

=begin    munge do |value|
      value.to_i
    end
=end
    validate do |value|
      unless value.to_i.between?(1, 3999)
        fail "value not within limit (2-3999)"
      end
    end
    isnamevar
  end

  # Properties
  newproperty(:vlan_name) do
 # newparam(:vlan_name) do
    desc 'string 32 characters long'
  end

  newproperty(:admin_state) do
  #newparam(:admin_state) do
    desc 'one of up or down'
  end
end
