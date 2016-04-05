#
# Cookbook Name:: jenkins_dev
# Recipe:: enable_auth
#
# Copyright 2016, Arjen de Rijke
#
# All rights reserved - Do Not Redistribute
#

ssh_private_key_file = File.join(Chef::Config[:file_cache_path], 'cookbooks/jenkins_dev/files/default/id_rsa')
ssh_private_key = File.read(ssh_private_key_file)

ssh_public_key_file = File.join(Chef::Config[:file_cache_path], 'cookbooks/jenkins_dev/files/default/id_rsa.pub')
ssh_public_key = File.read(ssh_public_key_file)

node.run_state[:jenkins_private_key] = ssh_private_key

include_recipe 'jenkins::master'

# Create the Jenkins user with the public key
jenkins_user 'Chef' do
  public_keys [ssh_public_key]
end

jenkins_plugin 'greenballs'

jenkins_user 'admin' do
  full_name 'admin'
  email     'me@example.com'
  password  'admin'
end

template "#{node['jenkins']['master']['home']}/config.xml" do
  source 'default/config.xml'
  notifies :reload, 'service[jenkins]', :delayed
end

template "#{node['jenkins']['master']['home']}/jenkins.model.DownloadSettings.xml" do
  source 'default/jenkins.model.DownloadSettings.xml'
  notifies :reload, 'service[jenkins]', :delayed
end

template "#{node['jenkins']['master']['home']}/jenkins.security.QueueItemAuthenticatorConfiguration.xml" do
  source 'default/jenkins.security.QueueItemAuthenticatorConfiguration.xml'
  notifies :reload, 'service[jenkins]', :delayed
end

service 'jenkins' do
  action [:reload]
end
