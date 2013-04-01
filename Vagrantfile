Vagrant.configure("2") do |config|
  config.vm.box       = 'precise32'
  config.vm.box_url   = 'http://files.vagrantup.com/precise32.box'
  config.vm.hostname  = 'tsl-dev-box'
  config.vm.network :forwarded_port, guest: 3000, host: 3000
  config.vm.synced_folder '.', '/site'
  config.vm.provision :puppet, :manifests_path => 'puppet/manifests'
end
