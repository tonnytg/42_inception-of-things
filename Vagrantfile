Vagrant.configure("2") do |config|
  # Configurações comuns para as máquinas
  config.vm.box = "ubuntu/focal64"

  # Compartilhar a pasta onde a chave SSH foi gerada
  config.vm.synced_folder ".", "/vagrant_data"

  # Máquina Master (wilS)
  config.vm.define "wilS" do |control|
    control.vm.hostname = "wilS"
    control.vm.network "private_network", ip: "192.168.56.110"
    control.vm.provider "virtualbox" do |v|
      v.memory = 1024
      v.cpus = 2
    end
    # Provisionamento da máquina Master
    control.vm.provision "shell", inline: <<-SHELL
      # Criar diretório .ssh e copiar as chaves
      sudo mkdir -p /home/vagrant/.ssh
      sudo cp /vagrant_data/id_rsa /home/vagrant/.ssh/id_rsa
      sudo cp /vagrant_data/id_rsa.pub /home/vagrant/.ssh/id_rsa.pub
      sudo chmod 600 /home/vagrant/.ssh/id_rsa

      # Adicionar a chave pública no authorized_keys
      cat /home/vagrant/.ssh/id_rsa.pub >> /home/vagrant/.ssh/authorized_keys
      sudo chown -R vagrant:vagrant /home/vagrant/.ssh

      # Instalar K3S no master
      curl -sfL https://get.k3s.io | sh -
      echo "K3S Master instalado com sucesso!"
    SHELL
  end

  # Máquina Worker (wilSW)
  config.vm.define "wilSW" do |control|
    control.vm.hostname = "wilSW"
    control.vm.network "private_network", ip: "192.168.56.111"
    control.vm.provider "virtualbox" do |v|
      v.memory = 1024
      v.cpus = 2
    end
    # Provisionamento da máquina Worker
    control.vm.provision "shell", inline: <<-SHELL
      # Criar diretório .ssh e copiar as chaves
      sudo mkdir -p /home/vagrant/.ssh
      sudo cp /vagrant_data/id_rsa /home/vagrant/.ssh/id_rsa
      sudo cp /vagrant_data/id_rsa.pub /home/vagrant/.ssh/id_rsa.pub
      sudo chmod 600 /home/vagrant/.ssh/id_rsa

      # Adicionar a chave pública no authorized_keys
      cat /home/vagrant/.ssh/id_rsa.pub >> /home/vagrant/.ssh/authorized_keys
      sudo chown -R vagrant:vagrant /home/vagrant/.ssh

      # Obter o token do master via SSH
      MASTER_IP=192.168.56.110
      TOKEN=$(ssh -o StrictHostKeyChecking=no vagrant@$MASTER_IP "sudo cat /var/lib/rancher/k3s/server/node-token")

      # Conectar o worker ao master
      curl -sfL https://get.k3s.io | K3S_URL=https://$MASTER_IP:6443 K3S_TOKEN=$TOKEN sh -
      echo "K3S Worker conectado ao Master!"
    SHELL
  end
end
