# -*- mode: ruby -*-
# vi: set ft=ruby :

required_plugins = %w( vagrant-hostsupdater )
required_plugins.each do |plugin|
    exec "vagrant plugin install #{plugin};vagrant #{ARGV.join(" ")}" unless Vagrant.has_plugin? plugin || ARGV[0] == 'plugin'
end

Vagrant.configure("2") do |config|
  

  config.vm.define "web" do |web|
    
  config.vm.box = "ubuntu/xenial64"
  config.vm.network "private_network", ip: "192.168.10.100"
  config.hostsupdater.aliases = ["development.local"]


  # synced app folder
  config.vm.synced_folder ".", "/home/ubuntu/app", owner: "app", group: "app"

  # Provisoning
  config.vm.provision "shell", path: "environment/provision.sh"
  end


  config.vm.define "db" do |db|
    db.vm.box = "mongodb"
  end
end
