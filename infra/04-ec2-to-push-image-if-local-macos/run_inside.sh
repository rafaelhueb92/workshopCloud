sudo usermod -aG docker $(whoami)
sudo systemctl enable --now docker
sudo -iu $(whoami)

git clone https://github.com/rafaelhueb92/workshopCloud.git