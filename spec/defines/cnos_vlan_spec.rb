require 'spec_helper'

type_class = Puppet::Type.type(:cnos_vlan)

describe type_class do
  let :params do
    [
      :vlan_id
    ]
  end

  let :properties do
    %i[
      vlan_name
      admin_state
    ]
  end

  it 'should have expected properties' do
    properties.each do |property|
      expect(type_class.properties.map(&:vlan_id)).to be_include(property)
    end
  end

  it 'should have expected parameters' do
    params.each do |param|
      expect(type_class.parameters).to be_include(param)
    end
  end

  it 'should require a vlan_id' do
    expect do
      type_class.new({})
    end.to raise_error(Puppet::Error, 'Title or name must be provided')
  end

  it 'should support :present as a value to :ensure' do
    type_class.new(vlan_id: '20', ensure: :present)
  end
end
