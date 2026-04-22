#!/bin/bash
set -e

# Exit on any error and print the command that failed
trap 'echo "Error occurred at line $LINENO"; exit 1' ERR

echo "=========================================="
echo "Starting Voting App Setup on EC2"
echo "=========================================="

# ── 1. Add Swap (needed for t2.micro) ──────
echo "[1/6] Setting up swap space..."
sudo fallocate -l 1G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab > /dev/null
echo "✅ Swap configured"

# ── 2. Update & Install Git ─────────────────
echo "[2/6] Updating system and installing Git..."
sudo apt-get update -y
sudo apt-get install -y git curl
echo "✅ System updated and Git installed"

# ── 3. Install k3s ──────────────────────────
echo "[3/6] Installing k3s..."
curl -sfL https://get.k3s.io | sh -
echo "✅ k3s installed"

# Wait for k3s to be ready
echo "[4/6] Waiting for k3s to be ready..."
sleep 30

# ── 4. Set kubeconfig for ubuntu user ───────
echo "[5/6] Configuring kubectl access for ubuntu user..."
sudo mkdir -p /home/ubuntu/.kube
sudo cp /etc/rancher/k3s/k3s.yaml /home/ubuntu/.kube/config
sudo chown ubuntu:ubuntu /home/ubuntu/.kube/config
sudo chmod 644 /home/ubuntu/.kube/config
echo 'export KUBECONFIG=/home/ubuntu/.kube/config' | sudo tee -a /home/ubuntu/.bashrc > /dev/null
export KUBECONFIG=/home/ubuntu/.kube/config
echo "✅ kubeconfig configured"

# Wait for k3s to be fully ready
echo "Waiting for k3s to be fully operational..."
for i in {1..30}; do
  if sudo /usr/local/bin/k3s kubectl get nodes > /dev/null 2>&1; then
    echo "✅ k3s is ready"
    break
  fi
  echo "Waiting... ($i/30)"
  sleep 2
done

# ── 5. Clone the Voting App ──────────────────
echo "[6/6] Cloning and deploying Voting App..."
cd /home/ubuntu
sudo git clone https://github.com/LikhithaRajgopal2001/Voting-App.git
cd Voting-App

# ── 6. Deploy to k3s ────────────────────────
echo "Deploying application to k3s..."
sudo /usr/local/bin/k3s kubectl apply -f example-voting-app/k8s-specifications/
echo "✅ Application deployed"

# Display deployment status
echo ""
echo "=========================================="
echo "Deployment Complete!"
echo "=========================================="
echo ""
sudo /usr/local/bin/k3s kubectl get pods
echo ""
echo "Voting App will be available at:"
echo "  Vote:    http://$(hostname -I | awk '{print $1}'):8080"
echo "  Results: http://$(hostname -I | awk '{print $1}'):8081"
echo ""
