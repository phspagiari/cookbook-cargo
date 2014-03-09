#
# Cookbook Name:: cargo
# Recipe:: default
#
# Copyright 2014
#
# All rights reserved - Do Not Redistribute
# Author: Pedro H. Spagiari (github/phspagiari)
# Description: Installs and configure cargo and their dependencies

apt_repository 'docker' do
  uri 'https://get.docker.io/ubuntu'
  distribution 'docker'
  components ['main']
  key 'https://get.docker.io/gpg'
end


node[:cargo][:os][:packages].each do |pkg|
  options "--force-yes"
  action :upgrade
end

package 'lxc-docker' do
  options '--force-yes -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold"'
  action :install
end


node[:cargo][:docker][:images].each do |image|
  execute "Pull latest image of #{image}" do
    command "docker pull #{image}"
  end
end

cookbook_file "/etc/default/docker" do
  source "etc/default/docker"
  owner "root"
  group "root"
  mode 0664
end

bash "Install golang" do
  cwd "/tmp"
  user "root"
  code <<-EOH
  curl -sL https://go.googlecode.com/files/go1.2.linux-amd64.tar.gz | tar xzC /usr/local
  export PATH=/usr/local/go/bin:$PATH
  export GOROOT=/usr/local/go
  export GOPATH=/go
  EOH
end

## TODO: CREATE A RESOURCE/PROVIDER FOR GO GET
node[:cargo][:go][:packages].each do |pkg|
  execute "Get the go package #{pkg}" do
    command "go get -v #{pkg}"
  end
end

user node[:cargo][:user] do
  comment "Cargo/git user"
  home node[:cargo][:home]
  shell "/bin/bash"
  gid node[:cargo][:group]
  supports :manage_home => true
end

node[:cargo][:dirs].each do |dir|
  directory "#{node[:cargo][:home]}/#{dir}" do
    user node[:cargo][:user]
    group node[:cargo][:group]
    mode 0775
    action :create
    recursive true
end

execute "Grant sudo for sbin/nginx to #{node[:cargo][:user]}" do
  command "echo 'git ALL=(ALL:ALL) NOPASSWD: /usr/sbin/nginx' > '/etc/sudoers.d/#{node[:cargo][:user]}-sbin-nginx'; chmod 440 '/etc/sudoers.d/#{node[:cargo][:user]}-sbin-nginx'"
  not_if "test -f /etc/sudoers.d/#{node[:cargo][:user]}-sbin-nginx"
end

bash "Create RSA Key for Cargo" do
  cwd "#{node[:cargo][:home]}/.ssh"
  user node[:cargo][:user]
  code <<-EOH
  ssh-keygen -t rsa -f #{node[:cargo][:home]}/.ssh/id_rsa -N
  EOH
end

template "/etc/init/cargo.conf" do
  source "etc/init/cargo.conf.erb"
  owner "root"
  group "root"
  mode 0664
  variables({
    :port => node[:cargo][:port],
    :home => node[:cargo][:home],
    :bucket => node[:cargo][:bucket],
    :aws_key => node[:cargo][:aws_access_key],
    :aws_secret => node[:cargo][:aws_secret_key],
    :base_domain => node[:cargo][:base_domain]
  })
end  

template "/etc/nginx/nginx.conf" do
  source "etc/nginx/nginx.conf.erb"
  owner "root"
  group "root"
  mode 0664
  variables({
    :server_location => node[:cargo][:nginx][:server_location]
  })
end

service "cargo" do
  provider Chef::Provider::Service::Upstart
  supports [:status]
  action :stop
end

service "cargo" do
  provider Chef::Provider::Service::Upstart
  supports [:status]
  action :start
end

service "nginx" do
  supports [:status]
  action :stop
end

service "nginx" do
  supports [:status]
  action :start
end