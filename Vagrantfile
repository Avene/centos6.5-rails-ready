# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  # Every Vagrant virtual environment requires a box to build off of.
  # config.vm.box = "centos6.5_x86_64"
  config.vm.box = "centos6.5_base"
  
  config.vm.box_url = "https://vagrantcloud.com/nrel/boxes/CentOS-6.5-x86_64/versions/4/providers/virtualbox.box"

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"
  config.vm.network "forwarded_port", guest: 3000, host: 23000
  config.vm.hostname = "vagrant.example.com"

  config.vm.provider "virtualbox" do |vb|
    vb.customize ["modifyvm", :id, "--natdnsproxy1", "off"]
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "off"]
  end
  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # If true, then any SSH connections made will enable agent forwarding.
  # Default value: false
  # config.ssh.forward_agent = true

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  # config.vm.provider "virtualbox" do |vb|
  #   # Don't boot with headless mode
  #   vb.gui = true
  #
  #   # Use VBoxManage to customize the VM. For example to change memory:
  #   vb.customize ["modifyvm", :id, "--memory", "1024"]
  # end
  #
  # View the documentation for the provider you're using for more
  # information on available options.

  # Enable provisioning with Puppet stand alone.  Puppet manifests
  # are contained in a directory path relative to this Vagrantfile.
  # You will need to create the manifests directory and a manifest in
  # the file default.pp in the manifests_path directory.
  #
  REMOTE_PUPPET_MODULE_DIR = '/etc/puppet/modules'
  REMOTE_PUPPET_TMP_DIR = '/tmp/vagrant/puppet'
  config.vm.provision :shell do |shell|
    cmd = "mkdir -p #{REMOTE_PUPPET_MODULE_DIR};"
    mod_names=['jdowning-rbenv','puppetlabs-firewall']
    mod_names.each do | mod_name |
      cmd << "{ puppet module list | grep #{mod_name} > /dev/null; } || puppet module install -i #{REMOTE_PUPPET_MODULE_DIR} #{mod_name};"
    end

    cmd << "rm -fr #{REMOTE_PUPPET_TMP_DIR};"

    shell.inline = cmd
  end

  config.vm.provision :file,
                      source: "puppet/modules",
                      destination: "#{REMOTE_PUPPET_TMP_DIR}/."

  config.vm.provision :shell do |shell|
    shell.inline = "cp -fpr #{REMOTE_PUPPET_TMP_DIR}/modules/* #{REMOTE_PUPPET_MODULE_DIR}"
  end

  config.vm.provision "puppet" do |puppet|
    puppet.options = "--verbose --debug"

    puppet.manifests_path = "puppet/manifests"
    puppet.manifest_file = "default.pp"
  end
end
