# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure('2') do |config|
  config.vm.box = 'debian/jessie64'
  config.vm.network 'public_network'

  config.vm.synced_folder '.', '/vagrant', type: 'virtualbox'

  config.vm.provider 'virtualbox' do |vb|
     vb.memory = '2048'
  end

  config.vm.provision 'shell', inline: <<-SHELL
    apt-get update
    apt-get install -y git

    # Profile & SSH
    sudo -u vagrant bash -c '
      mv /vagrant/.ssh/* ~/.ssh
      rm -rf /vagrant/.ssh
      chmod 600 ~/.ssh/*
      git clone git@github.com:DarrellMozingo/dotfiles.git ~/.dotfiles
      ~/.dotfiles/setup.sh
    '

    chsh -s $(which zsh) vagrant

    # Docker
    apt-get install -y apt-transport-https ca-certificates software-properties-common
    curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
    apt-get update
    apt-get install -y docker-ce
    usermod -aG docker vagrant
    systemctl enable docker

    # Docker Compose
    curl -L https://github.com/docker/compose/releases/download/1.11.2/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose

    # Python
    curl -O https://bootstrap.pypa.io/get-pip.py
    python get-pip.py && rm get-pip.py
    pip install awscli
    pip install cookiecutter

    # Java
    echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu xenial main" >> /etc/apt/sources.list.d/webupd8team-java.list
    echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu xenial main" >> /etc/apt/sources.list.d/webupd8team-java.list
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886
    apt-get update
    echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
    apt-get install -y oracle-java8-installer oracle-java8-set-default

    # Ruby
    git clone https://github.com/rbenv/rbenv.git /home/vagrant/.rbenv
    git clone https://github.com/rbenv/ruby-build.git /home/vagrant/.rbenv/plugins/ruby-build
    apt-get install -y libssl-dev libreadline-dev zlib1g-dev

    # Node
    curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.2/install.sh | bash

    echo "Commands to run:"
    echo "\taws configure --profile developer"
  SHELL
end