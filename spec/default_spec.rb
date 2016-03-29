require 'chefspec'

describe 'mycookbook::default' do
  let(:chef_run) {
    ChefSpec::Runner.new.converge(described_recipe)
  }  
end
