#
# Cookbook:: web
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.
apt_update

package 'nginx'


service 'nginx' do 
	supports status: true, restart: true, reload: true
	action [:enable, :start]	
end

template '/etc/nginx/sites-available/default' do
	source 'nginx.default.erb'
	notifies :reload, "service[nginx]"
end

remote_file "/tmp/nodesource_setup.sh" do
	source "https://deb.nodesource.com/setup_6.x"
	action :create
end

execute "update node resource" do
	command "sh /tmp/nodesource_setup.sh"
end

package "nodejs" do
	action :upgrade
end

execute "install npm" do
	command "npm install -g pm2"
end
