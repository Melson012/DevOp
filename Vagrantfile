# -*- mode: ruby -*-
# vi: set ft=ruby :

required_plugins = %w( vagrant-hostsupdater )
required_plugins.each do |plugin|
    exec "vagrant plugin install #{plugin};vagrant #{ARGV.join(" ")}" unless Vagrant.has_plugin? plugin || ARGV[0] == 'plugin'
end

Vagrant.configure("2") do |config|
  

  config.vm.define "web" do |web|
    
  web.vm.box = "ubuntu/xenial64"
  web.vm.network "private_network", ip: "192.168.10.100"
  web.hostsupdater.aliases = ["development.local"]


  # synced app folder
  web.vm.synced_folder ".", "/home/ubuntu/app"

  # Provisoning
  web.vm.provision "shell", inline: 'echo "export DB_HOST=mongodb://192.168.10.200/posts" >> .bashrc'
  web.vm.provision "shell", path: "environment/provision.sh"
  end


  config.vm.define "db" do |db|
	  
    db.vm.box = "ubuntu/xenial64"
	  db.vm.network "private_network", ip: "192.168.10.200"
	  db.hostsupdater.aliases = ["database.local"]


	  # synced app folder
	  db.vm.synced_folder ".", "/home/ubuntu/app"

	  # Provisoning
	  db.vm.provision "shell", path: "environment/mogodb.sh"
  end
end
