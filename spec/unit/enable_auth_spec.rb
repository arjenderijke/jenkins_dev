require 'spec_helper'

describe 'jenkins_dev::default' do
  let(:chef_run) {
    ChefSpec::SoloRunner.new.converge(described_recipe)
  }

  it 'include recipe jenkins master' do
    expect(chef_run).to include_recipe('jenkins::master')
  end

  it 'install jenkins_plugin greenballs' do
    expect(chef_run).to install_jenkins_plugin('greenballs')
  end
end
