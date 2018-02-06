#require File.join(File.dirname(__FILE__), '../cnos')
#require 'uri'

class Puppet::Util::NetworkDevice::Cnos::Facts

  attr_reader :transport

  def initialize(transport)
    Puppet.debug(self.class.to_s.split("::").last + ": Inside Initialize of Facts!")
    #File.write('/etc/puppetlabs/code/environments/production/modules/Sheru', 'Some glorious content')
    @transport = transport
    #@url = url
  end

  def retrieve(url)
    Puppet.debug(self.class.to_s.split("::").last + ": Retrieving Facts from facts.rb!")
    #File.write('/etc/puppetlabs/code/environments/production/modules/Sheru', 'Some glorious content')
    facts = {}
    facts.merge(parse_device_facts)
    #facts = parse_device_facts()
  end

  def parse_device_facts
    facts = {
      :operatingsystem => :cnos
    }
    if response = @transport.call('/nos/api/system') and items = response['items']
      #File.write('/etc/puppetlabs/code/environments/production/modules/Sheru', 'Some glorious content')
      result = items.first
    else
      Puppet.warning("Did not receive device details. CNOS REST requires Administrator level access.")
      return facts
    end

    [ :switch_type,
      :fw_version
    ].each do |fact|
      facts[fact] = result[fact.to_s]
    end

    # Map CNOS names to expected standard names.
    facts[:switch_type]            = facts[:switch_type]
    facts[:fw_version]             = facts[:fw_version]
    return facts
  end
end
