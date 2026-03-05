# 🚀 Kubernetes on AWS – Complete Workload & Storage Lab

![Kubernetes](https://img.shields.io/badge/Kubernetes-1.33-blue?logo=kubernetes)
![AWS](https://img.shields.io/badge/AWS-EC2%20%7C%20EBS%20%7C%20EFS-orange?logo=amazonaws)
![Storage](https://img.shields.io/badge/Storage-HostPath%20%7C%20EBS%20%7C%20EFS-yellow)
![Workloads](https://img.shields.io/badge/Workloads-Jenkins%20%7C%20Nginx%20%7C%20Tomcat-green)
![CNI](https://img.shields.io/badge/CNI-Calico-blue)
![Containerd](https://img.shields.io/badge/Runtime-Containerd-5c4ee5)

🚀 Kubernetes DevOps Lab – Jenkins, Storage, Scheduling & Workloads

📌 Overview

This repository is a hands-on Kubernetes DevOps lab that demonstrates how real production workloads are deployed and managed.

It includes examples for:

Jenkins deployments

Nginx workloads

Kubernetes scheduling

Persistent storage (EBS / EFS / HostPath)

ConfigMaps & Secrets

Private Docker registry authentication

Kubernetes workload types

The goal is to practice real-world Kubernetes infrastructure patterns used in DevOps environments.

🧠 Concepts Covered
Category	Topics
Workloads	Pod, ReplicaSet, Deployment, DaemonSet
Storage	HostPath, Static PV, Dynamic EBS, Dynamic EFS
Configuration	ConfigMaps
Security	Secrets
Registry	imagePullSecrets
Networking	Services
Scheduling	NodeSelector, NodeAffinity, PodAffinity, PodAntiAffinity
Cloud	AWS Storage Drivers
📂 Repository Structure
k8s/
│
├── config_secrets/
│   ├── tomcat-config/
│   ├── config-fgpod.yaml
│   ├── config_deployment_pod.yaml
│   ├── config_map.yaml
│   ├── economic-app-deploy.yaml
│   └── secret-pod-registry.yaml
│
├── dynamic-ebs/
│   ├── ebs-sc.yaml
│   ├── ebs-test-pod.yaml
│   └── ebs-test-pvc.yaml
│
├── dynamic-efs/
│   ├── efs-sc.yaml
│   ├── efs-test-pod.yaml
│   ├── efs-test-pod-2.yaml
│   ├── efs-test-pvc.yaml
│   ├── jen-sc-pvc-test-pod.yaml
│   ├── jen-test-pod-antiaffy.yaml
│   └── jenkins-efs-test.yaml
│
├── hostpath/
│   ├── jen_host.yaml
│   ├── pv.yaml
│   ├── pvc.yaml
│   └── pvc_mnt.yaml
│
├── static-ebs/
│   └── ebs-static.yaml
│
├── static-efs/
│   └── efs-static.yaml
│
├── nginx/
│   ├── nginx-daemonset.yaml
│   ├── nginx-deployment.yaml
│   ├── nginx-rs.yaml
│   ├── nginx-pod.yaml
│   ├── nginx-service_lb.yaml
│   ├── nginx_backend.yaml
│   ├── nginx_deploy_nodeaff.yaml
│   ├── nginx_deploy_podantiaff.yaml
│   ├── nginx_deploy_podaff.yaml
│   └── nginx_deploy_nodeselector.yaml
│
├── tomcat/
│   ├── tomcat-daemonset.yaml
│   ├── tomcat-deployment.yaml
│   ├── tomcat-pod.yaml
│   └── tomcat-service_lb.yaml
│
├── jenkins-pod.yaml
├── jenkins-deployment.yaml
├── jenkins-daemonset.yaml
├── jenkins-service.yaml
├── aws-ccm-values.yaml
└── README.md
🧱 Kubernetes Workload Examples

This repo includes examples for all major Kubernetes workloads.

Workload	Example
Pod	jenkins-pod.yaml
ReplicaSet	nginx-rs.yaml
Deployment	nginx-deployment.yaml
DaemonSet	jenkins-daemonset.yaml
Service	nginx-service_lb.yaml
Kubernetes Workload Flow
Deployment
   ↓
ReplicaSet
   ↓
Pod
   ↓
Container
💾 Storage Labs

This repository demonstrates multiple Kubernetes storage strategies.

🖥 HostPath Storage

Location:

hostpath/

Example files:

jen_host.yaml
pv.yaml
pvc.yaml
pvc_mnt.yaml

HostPath mounts a node filesystem directly inside a pod.

Worker Node Disk
      ↓
HostPath
      ↓
PersistentVolume
      ↓
Pod

⚠ Recommended only for development environments.

💾 Dynamic AWS EBS

Location:

dynamic-ebs/

Files:

ebs-sc.yaml
ebs-test-pvc.yaml
ebs-test-pod.yaml

EBS provides block storage for single pod access.

Workflow:

StorageClass
     ↓
PVC
     ↓
EBS CSI Driver
     ↓
AWS EBS Volume
     ↓
Pod Mounts Volume

Access Mode:

ReadWriteOnce
📂 Dynamic AWS EFS

Location:

dynamic-efs/

Files:

efs-sc.yaml
efs-test-pvc.yaml
efs-test-pod.yaml
efs-test-pod-2.yaml
jenkins-efs-test.yaml

EFS provides shared storage across multiple pods.

Workflow:

Pod A
   ↓
PVC
   ↓
EFS CSI Driver
   ↓
AWS EFS
   ↑
Pod B

Access Mode:

ReadWriteMany
⚙ ConfigMaps

Location:

config_secrets/

Files:

config_map.yaml
config_deployment_pod.yaml
config-fgpod.yaml

ConfigMaps allow externalizing configuration from container images.

Example flow:

ConfigMap
   ↓
Environment Variables
   ↓
Pod / Deployment
🔐 Kubernetes Secrets

File:

secret-pod-registry.yaml

Secrets store sensitive data such as:

Docker registry credentials

passwords

tokens

certificates

Check secrets:

kubectl get secrets
📦 Private Docker Registry

Create registry secret:

kubectl create secret docker-registry regcred \
--docker-server=https://index.docker.io/v1/ \
--docker-username=<username> \
--docker-password=<password> \
--docker-email=<email>

Pod example:

imagePullSecrets:
- name: regcred
🌐 Kubernetes Scheduling Examples

Located inside:

nginx/

Concepts demonstrated:

Feature	Purpose
NodeSelector	Schedule pod to specific node
NodeAffinity	Advanced node scheduling
PodAffinity	Place pods together
PodAntiAffinity	Spread pods across nodes
🚀 Running the Lab
Check cluster
kubectl get nodes
kubectl get pods -A
Deploy Jenkins
kubectl apply -f jenkins-deployment.yaml
kubectl apply -f jenkins-service.yaml
Deploy Nginx Example
kubectl apply -f nginx/nginx-deployment.yaml
Check pods
kubectl get pods
Check storage
kubectl get pv
kubectl get pvc
⚠ Common Issues
PVC Pending

Possible causes:

missing CSI driver

wrong StorageClass

missing AWS IAM permissions

CrashLoopBackOff

Possible causes:

incorrect mount path

permission issues

Cannot Access Service

Possible causes:

wrong service type

NodePort blocked in security group

🎯 Learning Goals

This repository helps understand:

✔ Kubernetes workloads
✔ Storage provisioning
✔ AWS EBS & EFS integration
✔ ConfigMaps and Secrets
✔ Container registry authentication
✔ Pod scheduling strategies

👨‍💻 Author

Vinayak

DevOps | Kubernetes | AWS

GitHub
https://github.com/vinayak432


=====================================================
====================================================
========================================================
---

# 📌 Overview

This repository is a **comprehensive Kubernetes lab project** built on AWS EC2 using `kubeadm`.

It demonstrates:

* 📦 Static & Dynamic Persistent Volumes
* 💾 AWS EBS (Block Storage)
* 📂 AWS EFS (Shared RWX Storage)
* 🧑‍💻 Jenkins deployments (multiple patterns)
* 🌐 Nginx scheduling & affinity rules
* ☕ Tomcat deployments
* 🔄 ReplicaSets, Deployments, DaemonSets
* 🎯 NodeSelector, Node Affinity, Pod Affinity/Anti-Affinity
* 🌍 LoadBalancer Services (AWS integration)

This repo is ideal for:

* DevOps practice
* Kubernetes interviews
* Storage deep dive
* Scheduling strategies lab
* AWS + Kubernetes integration learning

---

# 🏗 High-Level Architecture

```
                         ┌────────────────────────┐
                         │        AWS Cloud       │
                         └────────────────────────┘
                                      │
                    ┌─────────────────────────────────┐
                    │              VPC                │
                    └─────────────────────────────────┘
                          │                     │
                ┌─────────┴─────────┐   ┌───────┴─────────┐
                │  Control Plane    │   │   Worker Nodes   │
                │  (kubeadm)        │   │ (EC2 Instances)  │
                └────────────────────┘   └──────────────────┘
                           │                       │
                 ┌───────────────┐       ┌────────────────────┐
                 │  Scheduler    │       │ kubelet + containerd│
                 │  API Server   │       │ Calico CNI          │
                 └───────────────┘       └────────────────────┘
                                                │
                        ┌───────────────────────┼────────────────────────┐
                        │                       │                        │
                    HostPath                  EBS CSI                 EFS CSI
                    (local)                   (RWO)                   (RWX)
                        │                       │                        │
                Jenkins / Nginx / Tomcat Workloads using PV/PVC
```

---

# 📂 Repository Structure

## 🔹 Jenkins

* `jenkins-pod.yaml`
* `jenkins-rs.yaml`
* `jenkins-deployment.yaml`
* `jenkins-daemonset.yaml`
* `jenkins-service.yaml`
* `jenkins-efs-test.yaml`
* `jen_host.yaml` (HostPath version)

### Demonstrates:

* Pod vs ReplicaSet vs Deployment
* DaemonSet behavior
* Persistent storage
* Service exposure

---

## 🔹 Nginx

Located under `nginx/`

Includes:

* `nginx-pod.yaml`
* `nginx-rs.yaml`
* `nginx-rs-toleration.yaml`
* `nginx-daemonset.yaml`
* `nginx_deployment.yaml`
* `nginx_service_lb.yaml`
* `nginx_backend.yaml`

### Advanced Scheduling Examples

* `nginx_deploy_nodeselector.yaml`
* `nginx_deploy_nodeaff_hard_rule.yaml`
* `nginx_deploy_nodeaff_soft_rule.yaml`
* `nginx_deploy_podaff.yaml`
* `nginx_deploy_podantiaff.yaml`

### Demonstrates:

* NodeSelector
* Node Affinity (hard & soft)
* Pod Affinity
* Pod Anti-Affinity
* Tolerations
* LoadBalancer services

---

## 🔹 Tomcat

* `tomcat_pod.yaml`
* `tomcat-rs.yaml`
* `tomcat-deployment.yaml`
* `tomcat-daemonset.yaml`
* `tomcat_service_lb.yaml`

### Demonstrates:

* Stateless web deployment
* Scaling
* AWS LoadBalancer service

---

## 🔹 Storage Examples

### Static Storage

* `pv.yaml`
* `pvc.yaml`
* `pvcmnt.yaml`
* `pvc_mnt.yaml`
* `hostpath-eg.yaml`

### EBS Dynamic Provisioning

* `ebs-sc.yaml`
* `ebs-test-pvc.yaml`
* `ebs-test-pod.yaml`

### EFS Dynamic Provisioning

* `efs-sc.yaml`
* `efs-test-pvc.yaml`
* `efs-test-pod.yaml`
* `efs-test-pod-2.yaml`

---

# 🧪 Learning Modules Covered

| Feature               | Covered |
| --------------------- | ------- |
| Static PV             | ✅       |
| HostPath              | ✅       |
| EBS Dynamic           | ✅       |
| EFS Dynamic           | ✅       |
| RWX vs RWO            | ✅       |
| ReplicaSets           | ✅       |
| Deployments           | ✅       |
| DaemonSets            | ✅       |
| NodeSelector          | ✅       |
| Node Affinity         | ✅       |
| Pod Affinity          | ✅       |
| Pod Anti-Affinity     | ✅       |
| Tolerations           | ✅       |
| LoadBalancer Services | ✅       |

---

# 🚀 Step-By-Step Lab Guide

---

## 🥇 Phase 1 – Setup Kubernetes (kubeadm on EC2)

1. Install containerd
2. Disable swap
3. Install kubeadm, kubelet, kubectl
4. Initialize control plane
5. Join worker nodes
6. Install Calico CNI

Verify:

```bash
kubectl get nodes
kubectl get pods -n kube-system
```

---

## 🥈 Phase 2 – Install AWS CSI Drivers

### EBS CSI

```bash
helm repo add aws-ebs-csi-driver https://kubernetes-sigs.github.io/aws-ebs-csi-driver
helm install aws-ebs-csi-driver aws-ebs-csi-driver/aws-ebs-csi-driver -n kube-system
```

### EFS CSI

```bash
helm repo add aws-efs-csi-driver https://kubernetes-sigs.github.io/aws-efs-csi-driver
helm install aws-efs-csi-driver aws-efs-csi-driver/aws-efs-csi-driver -n kube-system
```

⚠ EFS filesystem must be created manually in AWS.

---

## 🥉 Phase 3 – Storage Testing

### Static PV Test

```bash
kubectl apply -f pv.yaml
kubectl apply -f pvc.yaml
```

### EBS Dynamic Test

```bash
kubectl apply -f ebs-sc.yaml
kubectl apply -f ebs-test-pvc.yaml
kubectl apply -f ebs-test-pod.yaml
```

### EFS RWX Test

```bash
kubectl apply -f efs-sc.yaml
kubectl apply -f efs-test-pvc.yaml
kubectl apply -f efs-test-pod.yaml
kubectl apply -f efs-test-pod-2.yaml
```

---

## 🧑‍💻 Phase 4 – Jenkins Deployment

```bash
kubectl apply -f jenkins-deployment.yaml
kubectl apply -f jenkins-service.yaml
```

Or use EFS-backed Jenkins:

```bash
kubectl apply -f jenkins-efs-test.yaml
```

---

## 🌐 Phase 5 – Nginx Scheduling Lab

Try:

```bash
kubectl apply -f nginx_deploy_nodeselector.yaml
kubectl apply -f nginx_deploy_nodeaff_hard_rule.yaml
kubectl apply -f nginx_deploy_nodeaff_soft_rule.yaml
kubectl apply -f nginx_deploy_podaff.yaml
kubectl apply -f nginx_deploy_podantiaff.yaml
```

Observe pod placement using:

```bash
kubectl get pods -owide
```

---

## ☕ Phase 6 – Deploy Tomcat

```bash
kubectl apply -f tomcat-deployment.yaml
kubectl apply -f tomcat_service_lb.yaml
```

Check external IP:

```bash
kubectl get svc
```

---

# 🔄 Deployment Flow

```
kubectl apply
    ↓
API Server
    ↓
Scheduler
    ↓
PVC Created
    ↓
CSI Driver Provisions Storage
    ↓
PV Bound
    ↓
Pod Starts
    ↓
Service Exposed
    ↓
AWS LoadBalancer Created
```

---

# ⚠ Common Issues

### PVC Pending

* CSI driver not installed
* Wrong fileSystemId
* IAM role missing
* Security group blocking NFS (2049)

### CrashLoopBackOff

* Volume permission issue
* Wrong mount path

### LoadBalancer Pending

* AWS LB controller not installed
* IAM policy missing

---

# 🧠 Production Best Practices

* Use Deployments instead of bare Pods
* Use EFS for shared workloads (RWX)
* Use EBS for stateful block storage
* Use Ingress + ALB instead of NodePort
* Enable IRSA for secure AWS access

---

# 🎯 Outcome

After completing this lab, you will understand:

* Kubernetes storage internals
* CSI driver architecture
* Advanced scheduling strategies
* AWS integration patterns
* Real-world DevOps troubleshooting

---

# 📜 License

Open-source lab project for educational purposes.

---
====================================================================================================================================

# ☸️ k8s_yamls

> *"You don't learn Kubernetes by reading about it. You learn it by breaking things — and this repo is where that journey begins."*

A hands-on collection of **Kubernetes YAML manifests** built for learning, experimenting, and truly understanding how K8s works under the hood. Apply it, break it, fix it, repeat. 🔁

---

## 🎯 What This Repo Is About

This is a **learning-first** Kubernetes reference repo. Every manifest here is designed to be readable, hackable, and educational. No black-box helm charts — just raw, honest YAML so you can see exactly what's happening.

---

## 📦 Resources Covered

| Resource | What You'll Learn |
|----------|-----------------|
| 🚀 **Deployments** | Rolling updates, replica scaling, pod templates, and self-healing workloads |
| 🌐 **Services** | ClusterIP, NodePort — how pods discover and talk to each other |
| 📋 **ConfigMaps & Secrets** | Decoupling config from code; managing sensitive data with base64 encoding |
| 💾 **StatefulSets & PersistentVolumes** | Stateful apps, stable pod identity, and durable storage with PVCs |

---

## 🚀 Getting Started

**Prerequisites:**
- A local cluster: [`minikube`](https://minikube.sigs.k8s.io) or [`kind`](https://kind.sigs.k8s.io)
- `kubectl` installed and configured

```bash
# Clone the repo
git clone https://github.com/vinayak432/k8s_yamls.git
cd k8s_yamls

# ✅ Always dry-run first — good habit!
kubectl apply -f <manifest>.yaml --dry-run=client

# 🚀 Apply a manifest
kubectl apply -f <manifest>.yaml

# 👀 Watch your pods come alive
kubectl get pods -w
```

---

## 📂 Suggested Structure

```
k8s_yamls/
├── deployments/          # Stateless workload definitions
├── services/             # ClusterIP & NodePort configs
├── configmaps/           # App configuration as key-value data
├── secrets/              # Sensitive config (base64 encoded)
└── statefulsets/         # Stateful apps + PVC definitions
```

---

## 🧪 Learning Experiments to Try

Level up by experimenting with these after applying the manifests:

```bash
# 🔁 Scale a Deployment up and down
kubectl scale deployment <name> --replicas=5

# 💥 Kill a pod and watch K8s self-heal
kubectl delete pod <pod-name>

# 🔍 Inspect a ConfigMap value
kubectl get configmap <name> -o yaml

# 🔐 Decode a Secret
kubectl get secret <name> -o jsonpath='{.data.<key>}' | base64 --decode

# 📦 Exec into a running pod
kubectl exec -it <pod-name> -- /bin/sh

# 📜 Check rollout history
kubectl rollout history deployment/<name>
```

---

## 🧠 Key Concepts Demystified

**Why ConfigMaps & Secrets?**
> Keep your container images environment-agnostic. The same image should work in dev, staging, and prod — only the config changes.

**Why StatefulSets over Deployments for databases?**
> Pods in a StatefulSet get stable, predictable names (`pod-0`, `pod-1`) and their own PersistentVolumeClaims. Deployments treat pods as disposable cattle; StatefulSets treat them as named pets.

**Services vs. direct Pod IPs?**
> Pod IPs are ephemeral — they change on restart. Services provide a stable virtual IP and DNS name that always routes to healthy pods.

---

## 🛠️ Recommended Tools for Learning

| Tool | Why You Need It |
|------|----------------|
| [`minikube`](https://minikube.sigs.k8s.io) | Run a full K8s cluster locally |
| [`k9s`](https://k9scli.io) | Beautiful terminal UI — like `htop` for Kubernetes |
| [`kubectx`](https://github.com/ahmetb/kubectx) | Switch between clusters/namespaces instantly |
| [`lens`](https://k8slens.dev) | GUI IDE for Kubernetes exploration |

---

## 📖 Go Deeper

- 📚 [Kubernetes Official Docs](https://kubernetes.io/docs/home/)
- 🎮 [Killercoda K8s Labs](https://killercoda.com/playgrounds/scenario/kubernetes) — free browser-based K8s playground
- 🧗 [Kubernetes the Hard Way](https://github.com/kelseyhightower/kubernetes-the-hard-way) — build K8s from scratch
- 🃏 [CKAD Practice Questions](https://github.com/dgkanatsios/CKAD-exercises) — prep for the K8s developer exam

---

## 🤝 Contributing

Learning is better together! If you've built a useful manifest or found a bug:

1. Fork → Branch → Commit → PR
2. Add comments inside your YAMLs explaining *why*, not just *what*

---

## 👤 Author

**Vinayak** — on a journey from `kubectl get pods` to `kubectl know-everything`

[![GitHub](https://img.shields.io/badge/GitHub-vinayak432-181717?logo=github)](https://github.com/vinayak432)

---

<div align="center">

*One `kubectl apply` at a time. You've got this.* 💪

⭐ Found this helpful? Star the repo and share it with fellow K8s learners!

</div>

