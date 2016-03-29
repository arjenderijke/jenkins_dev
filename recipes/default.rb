#
# Cookbook Name:: jenkins_dev
# Recipe:: default
#
# Copyright 2016, Arjen de Rijke
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'jenkins::master'

jenkins_plugin 'greenballs'
