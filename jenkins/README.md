# 🚀 Jenkins on Kubernetes (AWS Storage Lab)

![Kubernetes](https://img.shield# 🚀 Jenkins on Kubernetes (AWS Storage Lab)

![Kubernetes](https://img.shields.io/badge/Kubernetes-1.33-blue?logo=kubernetes)
![AWS](https://img.shields.io/badge/AWS-EBS%20%7C%20EFS-orange?logo=amazonaws)
![Storage](https://img.shields.io/badge/Storage-HostPath%20%7C%20EBS%20%7C%20EFS-yellow)
![Runtime](https://img.shields.io/badge/Containerd-Enabled-5c4ee5)



🚀 Jenkins on Kubernetes — AWS Storage & Configuration Lab


📌 Overview

This repository contains Kubernetes manifests for deploying Jenkins and experimenting with multiple storage and configuration strategies on an AWS-based Kubernetes cluster.

The lab demonstrates how Jenkins behaves with different:

Kubernetes workloads

Persistent storage types

Configuration management methods

Container registry authentication

This project is designed as a hands-on DevOps learning lab.

📚 Table of Contents

Overview

Architecture

Repository Structure

Jenkins Workloads

Storage Labs

ConfigMaps

Secrets

Private Docker Registry

AWS Integration

Deployment Guide

Troubleshooting

Production Recommendations

🏗 Architecture Overview
              AWS EC2 Kubernetes Cluster
                     (kubeadm)

              ┌─────────────────┐
              │  Control Plane  │
              │  API Server     │
              │  Scheduler      │
              └────────┬────────┘
                       │
               ┌───────▼────────┐
               │   Worker Node  │
               │  containerd    │
               │  Jenkins Pod   │
               └───────┬────────┘
                       │
      ┌────────────────┼────────────────┐
      │                │                │
   HostPath         EBS CSI          EFS CSI
 (Local Disk)     (Block Storage)   (Shared Storage)
📂 Repository Structure
jenkins/
│
├── jenkins-pod.yaml
├── jenkins-rs.yaml
├── jenkins-deployment.yaml
├── jenkins-daemonset.yaml
├── jenkins-service.yaml
│
├── jen_host.yaml
│
├── pv.yaml
├── pvc.yaml
├── pvc_mnt.yaml
│
├── ebs-sc.yaml
├── ebs-test-pvc.yaml
├── ebs-test-pod.yaml
│
├── efs-sc.yaml
├── efs-test-pvc.yaml
├── efs-test-pod.yaml
├── efs-test-pod-2.yaml
├── jenkins-efs-test.yaml
│
├── config_map.yaml
├── config-pod.yaml
├── config_deployment_pod.yaml
│
├── secret-pod-registry.yaml
│
└── aws-ccm-values.yaml
🧱 Jenkins Workloads

This repository demonstrates multiple Kubernetes workload types.

File	Description
jenkins-pod.yaml	Basic Jenkins Pod
jenkins-rs.yaml	Jenkins ReplicaSet
jenkins-deployment.yaml	Production Deployment
jenkins-daemonset.yaml	One Jenkins pod per node
jenkins-service.yaml	Service to expose Jenkins
Kubernetes Workload Hierarchy
Deployment
    ↓
ReplicaSet
    ↓
Pod
    ↓
Container (Jenkins)

Recommended workload:

✅ Deployment

💾 Storage Labs

This lab demonstrates four Kubernetes storage approaches.

🖥 HostPath Storage

File:

jen_host.yaml

HostPath mounts a node directory into a pod.

Worker Node Disk
        ↓
HostPath Volume
        ↓
Jenkins Pod

⚠ Not recommended for production.

Used mainly for:

local labs

development clusters

📦 Static Persistent Volume

Files:

pv.yaml
pvc.yaml
pvc_mnt.yaml

Static provisioning means admin manually creates the PV.

Admin Creates PV
        ↓
PVC Requested
        ↓
PV Bound
        ↓
Pod Uses Storage
💾 AWS EBS Dynamic Provisioning

Files:

ebs-sc.yaml
ebs-test-pvc.yaml
ebs-test-pod.yaml

Characteristics:

Feature	Value
Storage	AWS EBS
Access Mode	ReadWriteOnce
Type	Block Storage

Workflow:

StorageClass
     ↓
PVC
     ↓
EBS CSI Driver
     ↓
AWS EBS Volume Created
     ↓
Pod Mounts Volume

Best for single Jenkins instance.

📂 AWS EFS Dynamic Provisioning

Files:

efs-sc.yaml
efs-test-pvc.yaml
efs-test-pod.yaml
efs-test-pod-2.yaml
jenkins-efs-test.yaml

Characteristics:

Feature	Value
Storage	AWS EFS
Access Mode	ReadWriteMany
Type	Shared File System

Workflow:

Pod A
   ↓
PVC
   ↓
EFS CSI Driver
   ↓
AWS EFS Filesystem
   ↑
Pod B

Best for multi-node Jenkins deployments.

⚙ Configuration Management (ConfigMaps)

Files:

config_map.yaml
config-pod.yaml
config_deployment_pod.yaml

ConfigMaps allow separating configuration from container images.

Example flow:

ConfigMap
     ↓
Environment Variables
     ↓
Pod / Deployment

Commands:

kubectl apply -f config_map.yaml
kubectl get configmap
🔐 Kubernetes Secrets

File:

secret-pod-registry.yaml

Secrets store sensitive data:

passwords

tokens

registry credentials

certificates

Check secrets:

kubectl get secrets
📦 Private Docker Registry Image Pull

Create Docker registry secret:

kubectl create secret docker-registry regcred \
--docker-server=https://index.docker.io/v1/ \
--docker-username=<username> \
--docker-password=<password> \
--docker-email=<email>

Pod example:

spec:
  containers:
  - name: app
    image: my-private-repo/myimage:latest

  imagePullSecrets:
  - name: regcred

Workflow:

Private Docker Registry
        ↓
ImagePullSecret
        ↓
Kubernetes Pod
        ↓
Container Image Pulled
☁ AWS Integration

File:

aws-ccm-values.yaml

Used for configuring AWS Cloud Controller Manager.

This allows Kubernetes to integrate with AWS services like:

Load Balancers

Storage

Node lifecycle management

🚀 Deployment Guide
Verify Cluster
kubectl get nodes
kubectl get pods -n kube-system
Deploy Jenkins Pod
kubectl apply -f jenkins-pod.yaml
kubectl get pods
Deploy Jenkins Deployment
kubectl apply -f jenkins-deployment.yaml
kubectl apply -f jenkins-service.yaml

Check service:

kubectl get svc
💾 Storage Lab Commands
HostPath
kubectl apply -f jen_host.yaml

Fix permissions if required:

sudo chown -R 1000:1000 /var/jenkins-data
Static PV
kubectl apply -f pv.yaml
kubectl apply -f pvc.yaml
kubectl apply -f pvc_mnt.yaml
EBS Storage
kubectl apply -f ebs-sc.yaml
kubectl apply -f ebs-test-pvc.yaml
kubectl apply -f ebs-test-pod.yaml
EFS Storage
kubectl apply -f efs-sc.yaml
kubectl apply -f efs-test-pvc.yaml
kubectl apply -f efs-test-pod.yaml
kubectl apply -f efs-test-pod-2.yaml
kubectl apply -f jenkins-efs-test.yaml
⚠ Troubleshooting
PVC Pending

Possible reasons:

CSI driver not installed

wrong filesystem ID

IAM permissions missing

CrashLoopBackOff

Possible reasons:

incorrect volume mount

permission issues

Jenkins Not Accessible

Possible reasons:

incorrect service type

NodePort blocked in AWS security group

🎯 Production Recommendations

✔ Use EFS for Jenkins home directory
✔ Deploy Jenkins using Deployment
✔ Use Ingress + AWS ALB
✔ Enable IAM Roles for Service Accounts (IRSA)
❌ Avoid HostPath in production

📘 Key Takeaways
Feature	Purpose
EBS	Block storage for single pod
EFS	Shared storage across nodes
ConfigMap	External configuration
Secret	Secure credentials
imagePullSecrets	Pull private images
👨‍💻 Author

Vinayak

DevOps | Kubernetes | AWS

GitHub
https://github.com/vinayak432
