# 🚀 Jenkins on Kubernetes (AWS Storage Lab)

![Kubernetes](https://img.shield# 🚀 Jenkins on Kubernetes (AWS Storage Lab)

![Kubernetes](https://img.shields.io/badge/Kubernetes-1.33-blue?logo=kubernetes)
![AWS](https://img.shields.io/badge/AWS-EBS%20%7C%20EFS-orange?logo=amazonaws)
![Storage](https://img.shields.io/badge/Storage-HostPath%20%7C%20EBS%20%7C%20EFS-yellow)
![Runtime](https://img.shields.io/badge/Containerd-Enabled-5c4ee5)

🚀 Jenkins on Kubernetes — AWS Storage & Configuration Lab
4
📌 Overview

This repository contains Kubernetes manifests for deploying Jenkins and experimenting with multiple storage and configuration strategies on an AWS-based Kubernetes cluster.

The lab demonstrates how Jenkins behaves when deployed with different Kubernetes resources and storage backends.

It covers:

🧱 Pod, ReplicaSet, Deployment, DaemonSet

💾 Static Persistent Volumes

📦 Dynamic AWS EBS provisioning (RWO)

📂 Dynamic AWS EFS provisioning (RWX)

🖥 HostPath storage

⚙ ConfigMaps

🔐 Secrets

📦 Private Docker registry image pulls

🌐 Service exposure

☁ AWS cloud integration

This lab is designed to help understand real DevOps infrastructure patterns used in production Kubernetes clusters.

🧠 Kubernetes Concepts Covered
Category	Topics
Workloads	Pod, ReplicaSet, Deployment, DaemonSet
Storage	HostPath, Static PV, Dynamic EBS, Dynamic EFS
Configuration	ConfigMaps
Security	Secrets
Container Registry	imagePullSecrets
Networking	Kubernetes Services
Cloud Integration	AWS storage drivers
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
🧱 Jenkins Workload Types

This lab shows multiple ways to run Jenkins.

File	Description
jenkins-pod.yaml	Basic single Jenkins Pod
jenkins-rs.yaml	ReplicaSet
jenkins-deployment.yaml	Production-style Deployment
jenkins-daemonset.yaml	One Jenkins pod per node
jenkins-service.yaml	Expose Jenkins via Service
Kubernetes Deployment Flow
Deployment
    ↓
ReplicaSet
    ↓
Pod
    ↓
Container (Jenkins)

Recommended workload:

✔ Deployment

💾 Storage Labs

This repository demonstrates four different Kubernetes storage models.

🖥 HostPath Storage
4

File:

jen_host.yaml

HostPath mounts a node directory directly into a pod.

Architecture:

Worker Node Disk
      ↓
HostPath Volume
      ↓
Jenkins Pod

⚠ Not recommended for production.

Used for:

local labs

test clusters

Minikube environments

📦 Static Persistent Volume

Files:

pv.yaml
pvc.yaml
pvc_mnt.yaml

This demonstrates manual PV provisioning.

Flow:

Admin Creates PV
        ↓
PVC Requested
        ↓
PV Bound
        ↓
Pod Uses Storage

Useful when storage is provisioned outside Kubernetes.

💾 AWS EBS Dynamic Provisioning (RWO)
4

Files:

ebs-sc.yaml
ebs-test-pvc.yaml
ebs-test-pod.yaml
Characteristics
Feature	Value
Storage Type	Block Storage
Access Mode	ReadWriteOnce
Best Use	Single Jenkins instance

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
📂 AWS EFS Dynamic Provisioning (RWX)
4

Files:

efs-sc.yaml
efs-test-pvc.yaml
efs-test-pod.yaml
efs-test-pod-2.yaml
jenkins-efs-test.yaml
Characteristics
Feature	Value
Storage Type	Shared File System
Access Mode	ReadWriteMany
Best Use	Multi-node Jenkins

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

⚠ EFS filesystem must be created manually in AWS.

⚙ Configuration Management (ConfigMaps)
4

Files:

config_map.yaml
config-pod.yaml
config_deployment_pod.yaml

ConfigMaps allow separating application configuration from container images.

Flow:

ConfigMap
   ↓
Environment Variables
   ↓
Pod / Deployment

Example command:

kubectl apply -f config_map.yaml
kubectl get configmap
🔐 Secrets & Private Docker Registry
4

File:

secret-pod-registry.yaml

Secrets store sensitive information:

registry credentials

passwords

tokens

certificates

Check secrets:

kubectl get secrets
📦 Pull Image From Private Docker Registry

Create registry secret:

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

Used when configuring AWS Cloud Controller Manager.

Provides integration with:

AWS load balancers

node lifecycle management

cloud storage resources

🏗 Architecture Overview
              AWS EC2 Kubernetes Cluster
                     (kubeadm)

              ┌─────────────────┐
              │  Control Plane  │
              │ API Server      │
              │ Scheduler       │
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
🚀 Step-by-Step Deployment
Verify Cluster
kubectl get nodes
kubectl get pods -n kube-system
Deploy Jenkins Pod
kubectl apply -f jenkins-pod.yaml
kubectl get pods
Deploy Jenkins with Deployment
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
🔄 Deployment Workflow
kubectl apply
      ↓
API Server
      ↓
Scheduler
      ↓
PVC Created
      ↓
CSI Driver Creates Storage
      ↓
PV Bound
      ↓
Jenkins Pod Starts
      ↓
Service Exposed
⚠ Common Issues
PVC Pending

Possible reasons:

CSI driver missing

wrong fileSystemId

IAM permission issues

CrashLoopBackOff

Possible causes:

incorrect mount path

permission issues

Jenkins Not Accessible

Possible causes:

incorrect service type

NodePort blocked in security group

🎯 Production Recommendations

✔ Use EFS for Jenkins home directory
✔ Deploy Jenkins using Deployment
✔ Use Ingress + AWS ALB
✔ Enable IAM Roles for Service Accounts
❌ Avoid HostPath storage in production

📘 Key Takeaways
Feature	Purpose
EBS	Block storage for single pod
EFS	Shared storage across nodes
ConfigMap	External configuration
Secret	Secure credential storage
imagePullSecrets	Pull private container images
👨‍💻 Author

Vinayak

DevOps | Kubernetes | AWS

GitHub:
https://github.com/vinayak432
