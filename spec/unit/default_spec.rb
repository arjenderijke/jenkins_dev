require_relative '../spec_helper'

describe 'jenkins_dev::default' do
  let(:chef_run) {
    ChefSpec::SoloRunner.new.converge(described_recipe)
  }
  it 'include recipe jenkins master' do
    expect(chef_run).to include_recipe('jenkins::master')
  end
end
