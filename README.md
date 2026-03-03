# 🚀 Kubernetes on AWS – Complete Workload & Storage Lab

![Kubernetes](https://img.shields.io/badge/Kubernetes-1.33-blue?logo=kubernetes)
![AWS](https://img.shields.io/badge/AWS-EC2%20%7C%20EBS%20%7C%20EFS-orange?logo=amazonaws)
![Storage](https://img.shields.io/badge/Storage-HostPath%20%7C%20EBS%20%7C%20EFS-yellow)
![Workloads](https://img.shields.io/badge/Workloads-Jenkins%20%7C%20Nginx%20%7C%20Tomcat-green)
![CNI](https://img.shields.io/badge/CNI-Calico-blue)
![Containerd](https://img.shields.io/badge/Runtime-Containerd-5c4ee5)

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

If you'd like next:

* 📊 Visual PNG architecture diagram
* 🧩 Terraform infra version
* 🔁 CI/CD integration with Jenkins
* 📘 Interview question guide

Let me know 🚀
