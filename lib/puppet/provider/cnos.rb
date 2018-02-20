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

  def self.get_all_vlan()
    #return Vlan.get_all_vlan(transport.connection)

  end

  def self.call(url,args={})
    transport.call(url,args)
  end

  def self.call_items(url,args={'expandSubcollections'=>'true'})
    if call = transport.call(url,args)
      #Puppet.notice("Reaching here"+call)
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