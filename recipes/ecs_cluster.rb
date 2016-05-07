#
# Cookbook Name:: jenkins_dev
# Recipe:: ecs_cluster
#
# Copyright 2016, Arjen de Rijke
#
# All rights reserved - Do Not Redistribute
#

node.default['jenkins']['master']['version'] = '1.658-1.1'

include_recipe 'jenkins::master'

jenkins_plugin 'greenballs'
jenkins_plugin 'amazon-ecs'

jenkins_plugin 'aws-credentials' do
  version '1.10'
end

jenkins_plugin 'aws-java-sdk' do
  version '1.10.45'
end

serverinstance = search("aws_opsworks_instance", "self:true").first

template "#{node['jenkins']['master']['home']}/jenkins.model.JenkinsLocationConfiguration.xml" do
  source 'default/jenkins.model.JenkinsLocationConfiguration.xml.erb'
  owner 'jenkins'
  group 'jenkins'
  mode '0644'
  variables :location => {
              'admin-address' => 'me@example.com',
              'public-dns' => serverinstance['public_dns']
            }
  notifies :reload, 'service[jenkins]', :delayed
end

ecs_cluster = search("aws_opsworks_ecs_cluster").first

template "#{node['jenkins']['master']['home']}/config.xml" do
  source 'default/config.xml.erb'
  owner 'jenkins'
  group 'jenkins'
  mode '0644'
  variables :config => {
              'account-id' => node['account_id'],
              'cluster-arn' => ecs_cluster['ecs_cluster_arn']
            }
  notifies :reload, 'service[jenkins]', :delayed
end

cookbook_file "#{node['jenkins']['master']['home']}/com.cloudbees.jenkins.plugins.amazonecs.ECSTaskTemplate.xml" do
  source 'com.cloudbees.jenkins.plugins.amazonecs.ECSTaskTemplate.xml'
  owner 'jenkins'
  group 'jenkins'
  mode '0644'
  action :create
  notifies :reload, 'service[jenkins]', :delayed
end

service 'jenkins' do
  action [:reload]
end

xml = File.join(Chef::Config[:file_cache_path], 'cookbooks/jenkins_dev/files/default/test3.xml')

jenkins_job 'test3' do
  config xml
  notifies :reload, 'service[jenkins]', :delayed
end

service 'jenkins' do
  action [:reload]
end
