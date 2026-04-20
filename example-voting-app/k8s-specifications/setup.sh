#!/bin/bash
# setup.sh - Installs k3s and deploys the Voting App
# ── 1. Add Swap (needed for t2.micro) ──────
fallocate -l 1G /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
echo '/swapfile none swap sw 0 0' >> /etc/fstab
# ── 2. Update & Install Git ─────────────────
apt-get update -y
apt-get install -y git
# ── 3. Install k3s ──────────────────────────
curl -sfL https://get.k3s.io | sh -
# Wait for k3s to be ready
sleep 30
# ── 4. Set kubeconfig for ubuntu user ───────
mkdir -p /home/ubuntu/.kube
cp /etc/rancher/k3s/k3s.yaml /home/ubuntu/.kube/config
chown ubuntu:ubuntu /home/ubuntu/.kube/config
echo 'export KUBECONFIG=/home/ubuntu/.kube/config' >> /home/ubuntu/.bashrc
# ── 5. Clone the Voting App ──────────────────
cd /home/ubuntu
git clone https://github.com/LikhithaRajgopal2001/Voting-App.git
cd Voting-App
# ── 6. Deploy to k3s ────────────────────────
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
kubectl apply -f k8s-specifications/
