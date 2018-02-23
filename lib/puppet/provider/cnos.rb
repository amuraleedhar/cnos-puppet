require File.join(File.dirname(__FILE__), '../util/network_device/cnos')
require File.join(File.dirname(__FILE__), '../util/network_device/transport/cnos')
require 'cnos-rbapi/vlan'
require 'json'

class Puppet::Provider::Cnos < Puppet::Provider
  def self.device(url)
    Puppet::Util::NetworkDevice::Cnos::Device.new(url)
  end

  def self.transport
    if Puppet::Util::NetworkDevice.current
      #we are in `puppet device`
      Puppet::Util::NetworkDevice.current.transport
    else
      #we are in `puppet resource`
      Puppet::Util::NetworkDevice::Transport::Cnos.new(Facter.value(:url))
    end
  end

  def self.device_url
    Puppet::Util::NetworkDevice.current ? Puppet::Util::NetworkDevice.current.url.to_s : Facter.value(:url)
  end

  def self.connection
    transport.connection
  end

  # VRRP Methods start here
  def self.get_vrrp_prop_all()
    resp = Vrrp.get_vrrp_prop_all(connection)
    return resp
  end

  def self.create_vrrp_intf(if_name, params)
    resp = Vrrp.create_vrrp_intf(connection, if_name, params)
    return resp
  end

  def self.update_vrrp_intf_vrid(if_name,vr_id, params)
    resp = Vrrp.update_vrrp_intf_vrid(connection, if_name, vr_id, params)
    return resp
  end

  def self.del_vrrp_intf_vrid(if_name, vr_id)
    resp = Vrrp.del_vrrp_intf_vrid(connection, if_name, vr_id)
    return resp
  end

  # VLAN Methods Starts here

  def self.get_all_vlan()
    resp = Vlan.get_all_vlan(connection)
    return resp

  end

  def self.create_vlan(params)
    resp = Vlan.create_vlan(connection, params)
    #Puppet.debug("Reaching here :"+resp)
    return resp
  end

  def self.update_vlan(vlan_id, params)
    resp = Vlan.update_vlan(connection,vlan_id, params)
    return resp
  end

  def self.delete_vlan(vlan_id)
    resp = Vlan.delete_vlan(connection, vlan_id)
    return resp
  end

  def self.call(url,args={})
    transport.call(url,args)
  end

  def self.call_items(url,args={'expandSubcollections'=>'true'})
    if call = transport.call(url,args)
      #Puppet.debug("Reaching here"+call)
      call
      #call['item']
    else
      nil
    end
  end

  def self.post(url, message)
    transport.post(url, message)
  end

  def self.put(url, message)
    transport.put(url, message)
  end

  def self.delete(url)
    transport.delete(url)
  end

  def self.find_availability(string)
    transport.find_availability(string)
  end

  def self.find_monitors(string)
    transport.find_monitors(string)
  end

end #End of class
