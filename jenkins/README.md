# 🚀 Jenkins on Kubernetes (AWS Storage Lab)

![Kubernetes](https://img.shields.io/badge/Kubernetes-1.33-blue?logo=kubernetes)
![AWS](https://img.shields.io/badge/AWS-EBS%20%7C%20EFS-orange?logo=amazonaws)
![Storage](https://img.shields.io/badge/Storage-HostPath%20%7C%20EBS%20%7C%20EFS-yellow)
![Runtime](https://img.shields.io/badge/Containerd-Enabled-5c4ee5)

---

# 📌 Overview

This directory contains all Kubernetes manifests required to deploy **Jenkins** using different workload types and storage backends on an AWS-based `kubeadm` cluster.

It demonstrates:

* 🧱 Pod vs ReplicaSet vs Deployment vs DaemonSet
* 💾 Static Persistent Volume
* 📦 Dynamic EBS provisioning (RWO)
* 📂 Dynamic EFS provisioning (RWX)
* 🖥 HostPath-based storage
* 🌐 Service exposure
* ☁ AWS Cloud integration concepts

This lab is ideal for understanding how Jenkins behaves with different Kubernetes storage strategies.

---

# 📂 File Structure

## 🔹 Core Jenkins Workloads

* `jenkins-pod.yaml` → Basic single Pod
* `jenkins-rs.yaml` → ReplicaSet
* `jenkins-deployment.yaml` → Deployment (Recommended)
* `jenkins-daemonset.yaml` → One pod per node
* `jenkins-service.yaml` → Service for Jenkins

---

## 🔹 Storage Variants

### 🖥 HostPath Example

* `jen_host.yaml`

Stores Jenkins data on the worker node filesystem.

⚠ Not recommended for production.

---

### 📦 Static PV Example

* `pv.yaml`
* `pvc.yaml`
* `pvc_mnt.yaml`

Demonstrates manual PersistentVolume binding.

---

### 💾 AWS EBS Dynamic Provisioning (Block Storage – RWO)

* `ebs-sc.yaml`
* `ebs-test-pvc.yaml`
* `ebs-test-pod.yaml`

Suitable for:

* Single-node Jenkins
* Block storage requirements

---

### 📂 AWS EFS Dynamic Provisioning (Shared – RWX)

* `efs-sc.yaml`
* `efs-test-pvc.yaml`
* `efs-test-pod.yaml`
* `efs-test-pod-2.yaml`
* `jenkins-efs-test.yaml`

Suitable for:

* Shared Jenkins home
* Multi-node deployments
* Production-ready RWX storage

⚠ EFS filesystem must be created manually in AWS.

---

## 🔹 AWS Integration

* `aws-ccm-values.yaml`

Used when configuring AWS Cloud Controller Manager.

---

# 🏗 Architecture Overview

```id="jv82fx"
              AWS EC2 Cluster (kubeadm)
                     │
        ┌───────────────────────────┐
        │       Control Plane       │
        └───────────────────────────┘
                     │
        ┌───────────────────────────┐
        │        Worker Node        │
        │  kubelet + containerd     │
        │  Jenkins Pod              │
        └───────────────────────────┘
                     │
     ┌───────────────┼───────────────┐
     │               │               │
  HostPath         EBS CSI         EFS CSI
 (Local Disk)      (Block RWO)     (Shared RWX)
```

---

# 🚀 Step-by-Step Deployment Guide

---

## 🥇 1. Verify Cluster

```bash id="r1q7tq"
kubectl get nodes
kubectl get pods -n kube-system
```

---

## 🥈 2. Deploy Basic Jenkins Pod

```bash id="h2v6ut"
kubectl apply -f jenkins-pod.yaml
kubectl get pods
```

---

## 🥉 3. Deploy Jenkins Using Deployment (Recommended)

```bash id="x2v8kc"
kubectl apply -f jenkins-deployment.yaml
kubectl apply -f jenkins-service.yaml
```

Check service:

```bash id="k5m0zq"
kubectl get svc
```

Access Jenkins using NodePort or LoadBalancer IP.

---

# 💾 Storage Labs

---

## 🖥 HostPath Jenkins

```bash id="u2l4sw"
kubectl apply -f jen_host.yaml
```

Fix permissions if needed:

```bash id="k6q7ef"
sudo chown -R 1000:1000 /var/jenkins-data
```

---

## 📦 Static PV Example

```bash id="q8v2pd"
kubectl apply -f pv.yaml
kubectl apply -f pvc.yaml
kubectl apply -f pvc_mnt.yaml
```

Verify:

```bash id="y4r7sj"
kubectl get pvc
```

---

## 💾 EBS Dynamic Storage

1️⃣ Install EBS CSI Driver
2️⃣ Apply:

```bash id="n4b8uw"
kubectl apply -f ebs-sc.yaml
kubectl apply -f ebs-test-pvc.yaml
kubectl apply -f ebs-test-pod.yaml
```

Expected:

```text id="k94zwl"
STATUS: Bound
```

---

## 📂 EFS Dynamic Storage (RWX)

1️⃣ Create EFS filesystem in AWS
2️⃣ Allow NFS port 2049
3️⃣ Update `fileSystemId` in `efs-sc.yaml`

Apply:

```bash id="z3m8fs"
kubectl apply -f efs-sc.yaml
kubectl apply -f efs-test-pvc.yaml
kubectl apply -f efs-test-pod.yaml
kubectl apply -f efs-test-pod-2.yaml
```

For Jenkins:

```bash id="v9e6ax"
kubectl apply -f jenkins-efs-test.yaml
```

---

# 🔄 Deployment Flow

```id="k2g9mp"
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
Jenkins Pod Starts
      ↓
Service Exposed
```

---

# 🧠 Concepts Covered

| Concept          | Covered |
| ---------------- | ------- |
| Pod              | ✅       |
| ReplicaSet       | ✅       |
| Deployment       | ✅       |
| DaemonSet        | ✅       |
| HostPath         | ✅       |
| Static PV        | ✅       |
| Dynamic EBS      | ✅       |
| Dynamic EFS      | ✅       |
| RWO vs RWX       | ✅       |
| Service Exposure | ✅       |

---

# ⚠ Common Issues

### PVC Pending

* CSI driver missing
* Incorrect fileSystemId
* IAM role missing
* NFS 2049 blocked

### CrashLoopBackOff

* Volume permission issue
* Wrong mount path

### Cannot Access Jenkins

* Service type incorrect
* NodePort not open in security group

---

# 🎯 Production Recommendations

* Use EFS for Jenkins home (RWX)
* Use Deployment instead of Pod
* Use Ingress + ALB for exposure
* Enable IAM Roles for Service Accounts (IRSA)
* Avoid HostPath in production

---

# 📜 License

Educational DevOps Lab Project

---
