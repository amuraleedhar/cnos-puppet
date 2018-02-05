require 'puppet/util/network_device/base'
require File.join(File.dirname(__FILE__), '../cnos')
require File.join(File.dirname(__FILE__), '../cnos/facts')
require File.join(File.dirname(__FILE__), '../transport/cnos')

require "uri"

class Puppet::Util::NetworkDevice::cnos::Device
  attr_reader :connection
  attr_accessor :url, :transport

  def initialize(url, options = {})
    @url = URI.parse(url)

    @autoloader = Puppet::Util::Autoload.new(
      self,
      "puppet/util/network_device/transport"
    )
    if @autoloader.load("cnos")
      @transport = Puppet::Util::NetworkDevice::Transport::cnos.new(url, options[:debug])
      Puppet.debug(self.class.to_s.split("::").last + ": Inside Device Initialize")
    end
  end

  def facts
    Puppet.debug(self.class.to_s.split("::").last + ": Inside Device FACTS Initialize")
    @facts ||= Puppet::Util::NetworkDevice::cnos::Facts.new(@transport)

    return @facts.retrieve
  end

end