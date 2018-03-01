require 'spec_helper'

describe 'vlan_demo' do
  it 'creates a vlan called vlan20' do
    pp=<<-EOS
    cnos_vlan { '20':
      ensure                 => 'present',
      vlan_name              => 'vlan20',
      admin_state            => 'up',
      vlan_id                => '20',
    }
    EOS
    make_site_pp(pp)
    run_device(:allow_changes => true)
    run_device(:allow_changes => false)
  end
end
