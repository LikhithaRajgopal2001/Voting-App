# 🗳️ Distributed Voting App — Docker, Kubernetes & Terraform

A distributed multi-container voting application deployed on Kubernetes (AWS EKS) using Docker, Docker Compose, Docker Swarm, and Terraform for infrastructure provisioning.

---

## 🏗️ Architecture

The application is composed of multiple microservices running as separate containers:

```
[ Voting UI (Python) ]
        ↓
  [ Redis Queue ]
        ↓
  [ Worker (.NET) ]
        ↓
  [ PostgreSQL DB ]
        ↓
  [ Result UI (Node.js) ]
```

| Service | Technology | Description |
|---------|------------|-------------|
| `vote` | Python / Flask | Frontend voting interface (Cats vs Dogs) |
| `redis` | Redis | In-memory queue for incoming votes |
| `worker` | .NET / C# | Processes votes from Redis to PostgreSQL |
| `db` | PostgreSQL | Persistent storage for vote counts |
| `result` | Node.js | Real-time results dashboard |

---

## 🚀 Deployment Options

### 1. Docker Compose (Local)

```bash
docker-compose up
```

- Vote UI: http://localhost:5000
- Result UI: http://localhost:5001

---

### 2. Kubernetes on AWS EKS

**Prerequisites:**
- AWS CLI configured
- kubectl installed
- Terraform installed

**Step 1 — Provision Infrastructure with Terraform**

```bash
cd terraform
terraform init
terraform plan
terraform apply
```

**Step 2 — Configure kubectl**

```bash
aws eks --region <your-region> update-kubeconfig --name <cluster-name>
```

**Step 3 — Deploy Application**

```bash
kubectl apply -f example-voting-app/k8s-specifications/
```

**Step 4 — Access the App**

```bash
kubectl get services
```

- Vote UI: `<EXTERNAL-IP>:31000`
- Result UI: `<EXTERNAL-IP>:31001`

---

### 3. Docker Swarm

```bash
docker swarm init
docker stack deploy --compose-file docker-stack.yml vote
```

---

## 🛠️ Tech Stack

| Category | Tools |
|----------|-------|
| Containerization | Docker, Docker Compose |
| Orchestration | Kubernetes, Docker Swarm |
| Cloud | AWS EKS, EC2 |
| Infrastructure as Code | Terraform (HCL) |
| CI/CD | GitHub Actions |
| Backend | Python, .NET / C#, Node.js |
| Database | PostgreSQL, Redis |
| Frontend | HTML, CSS, JavaScript |

---

## 📁 Project Structure

```
Voting-App/
├── example-voting-app/
│   ├── vote/               # Python voting frontend
│   ├── result/             # Node.js results frontend
│   ├── worker/             # .NET vote processor
│   ├── k8s-specifications/ # Kubernetes manifests
│   └── docker-compose.yml
├── terraform/              # AWS EKS infrastructure
├── automation/             # Automation scripts
├── .github/workflows/      # CI/CD pipelines
└── screenshots/            # App screenshots
```

---

## 🔍 Key Learnings

- Deploying and managing multi-container applications with Kubernetes on AWS EKS
- Writing Terraform configurations to provision cloud infrastructure
- Understanding container networking and inter-service communication
- Troubleshooting real-world issues: NotReady nodes, Pending pods, service access failures
- Setting up CI/CD pipelines with GitHub Actions

---
