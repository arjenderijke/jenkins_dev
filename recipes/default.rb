#
# Cookbook Name:: jenkins_dev
# Recipe:: default
#
# Copyright 2016, Arjen de Rijke
#
# All rights reserved - Do Not Redistribute
#

node.default['jenkins']['master']['version'] = '1.658-1.1'

include_recipe 'jenkins::master'

jenkins_plugin 'greenballs'
