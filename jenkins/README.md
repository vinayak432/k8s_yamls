# 🚀 Jenkins on Kubernetes (AWS Storage Lab)

![Kubernetes](https://img.shields.io/badge/Kubernetes-1.33-blue?logo=kubernetes)
![AWS](https://img.shields.io/badge/AWS-EBS%20%7C%20EFS-orange?logo=amazonaws)
![Storage](https://img.shields.io/badge/Storage-HostPath%20%7C%20EBS%20%7C%20EFS-yellow)
![Runtime](https://img.shields.io/badge/Containerd-Enabled-5c4ee5)

---

🚀 Jenkins on Kubernetes (AWS Storage Lab)
<img width="769" height="572" alt="image" src="https://github.com/user-attachments/assets/a8ed5f45-c264-4f44-878a-ffbfbf6a2bf4" />
<img width="1102" height="1070" alt="image" src="https://github.com/user-attachments/assets/450cf769-4590-43d5-8bfd-bdb577468f2f" />
<img width="800" height="622" alt="image" src="https://github.com/user-attachments/assets/dcfd7c81-cf0b-4b87-bc2f-2abf2e83d541" />
<img width="879" height="466" alt="image" src="https://github.com/user-attachments/assets/05210147-ed09-4db9-8b10-6ae35973f1c7" />

📌 Overview

This directory contains Kubernetes manifests to deploy Jenkins with multiple workload types and storage strategies on an AWS-based kubeadm Kubernetes cluster.

This lab demonstrates how Jenkins interacts with different storage backends and Kubernetes resource types.

🧪 What This Lab Covers
Category	Topics
🧱 Workloads	Pod, ReplicaSet, Deployment, DaemonSet
💾 Storage	Static PV, Dynamic EBS (RWO), Dynamic EFS (RWX), HostPath
🌐 Networking	Kubernetes Services
☁ Cloud Integration	AWS Storage + Cloud Controller concepts

This lab is designed to help you understand how persistent storage works for Jenkins in Kubernetes.

🗂 Directory Structure
jenkins/
│
├── jenkins-pod.yaml
├── jenkins-rs.yaml
├── jenkins-deployment.yaml
├── jenkins-daemonset.yaml
├── jenkins-service.yaml
│
├── pv.yaml
├── pvc.yaml
├── pvc_mnt.yaml
│
├── jen_host.yaml
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
└── aws-ccm-values.yaml
🧱 Core Jenkins Workloads
File	Description
jenkins-pod.yaml	Basic Jenkins Pod
jenkins-rs.yaml	Jenkins ReplicaSet
jenkins-deployment.yaml	Jenkins Deployment (recommended)
jenkins-daemonset.yaml	Runs Jenkins pod on every node
jenkins-service.yaml	Service to expose Jenkins
Deployment Hierarchy
Deployment
   ↓
ReplicaSet
   ↓
Pod
   ↓
Container (Jenkins)
💾 Storage Variants

This repository demonstrates four different Kubernetes storage patterns.

🖥 HostPath Storage
<img width="590" height="300" alt="image" src="https://github.com/user-attachments/assets/1cc822ed-a3d4-4ccf-b7c2-e9ae5147a4d9" />
<img width="799" height="679" alt="image" src="https://github.com/user-attachments/assets/1a3d36ac-9f0d-4d0b-a128-150239b29044" />
<img width="1064" height="1204" alt="image" src="https://github.com/user-attachments/assets/c287ecaa-73ab-46de-a282-d98709f3077e" />
<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/b9828bea-1586-4040-b5c2-310fe62986f8" />

File:

jen_host.yaml

HostPath stores Jenkins data directly on the worker node filesystem.

Flow
Worker Node Disk
      ↓
HostPath Volume
      ↓
Jenkins Pod

⚠ Not recommended for production
Best used for:

local labs

testing environments

Minikube / Kind

📦 Static Persistent Volume

Files:

pv.yaml
pvc.yaml
pvc_mnt.yaml

This demonstrates manual PV provisioning.

Flow
Admin Creates PV
       ↓
PVC Requested
       ↓
PV Bound
       ↓
Pod Uses Storage

Useful when storage is managed manually by infrastructure teams.

💾 AWS EBS Dynamic Provisioning (RWO)
<img width="800" height="622" alt="image" src="https://github.com/user-attachments/assets/a391e2b0-d9a4-4012-bd02-dc3e68b6257a" />
<img width="789" height="400" alt="image" src="https://github.com/user-attachments/assets/5e7a2036-25be-4823-bfde-82a77c66cedb" />


Files:

ebs-sc.yaml
ebs-test-pvc.yaml
ebs-test-pod.yaml
Characteristics
Feature	Value
Storage Type	Block Storage
Access Mode	RWO (ReadWriteOnce)
Best For	Single Jenkins instance
Workflow
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
<img width="621" height="411" alt="image" src="https://github.com/user-attachments/assets/c63c5bde-05ac-40f7-a386-a27ed08b804d" />
<img width="800" height="687" alt="image" src="https://github.com/user-attachments/assets/c505ae8c-c2b8-4e47-ab2f-ac9f8e4d305a" />
<img width="769" height="572" alt="image" src="https://github.com/user-attachments/assets/9958fe9e-7570-4b8b-82c1-8d71165347d7" />
<img width="800" height="501" alt="image" src="https://github.com/user-attachments/assets/c72b5b35-c66e-455f-897b-e535af582adb" />

Files:

efs-sc.yaml
efs-test-pvc.yaml
efs-test-pod.yaml
efs-test-pod-2.yaml
jenkins-efs-test.yaml
Characteristics
Feature	Value
Storage Type	Shared File System
Access Mode	RWX (ReadWriteMany)
Best For	Multi-node Jenkins
Workflow
Pod A
   ↓
PVC
   ↓
EFS CSI Driver
   ↓
AWS EFS Filesystem
   ↑
Pod B

⚠ EFS filesystem must be created manually in AWS

☁ AWS Integration

File:

aws-ccm-values.yaml

Used when configuring AWS Cloud Controller Manager.

This enables Kubernetes to integrate with AWS services like:

Load Balancers

Node management

Storage provisioning

🏗 Architecture Overview
              AWS EC2 Kubernetes Cluster
                     (kubeadm)

                ┌───────────────┐
                │ Control Plane │
                │ API Server    │
                │ Scheduler     │
                └───────┬───────┘
                        │
                ┌───────▼────────┐
                │   Worker Node  │
                │  kubelet       │
                │  containerd    │
                │  Jenkins Pod   │
                └───────┬────────┘
                        │
      ┌─────────────────┼─────────────────┐
      │                 │                 │
   HostPath          EBS CSI           EFS CSI
 (Local Disk)     (Block Storage)   (Shared Storage)
🚀 Step-by-Step Deployment Guide
🥇 Verify Cluster
kubectl get nodes
kubectl get pods -n kube-system
🥈 Deploy Basic Jenkins Pod
kubectl apply -f jenkins-pod.yaml
kubectl get pods
🥉 Deploy Jenkins Using Deployment
kubectl apply -f jenkins-deployment.yaml
kubectl apply -f jenkins-service.yaml

Check service:

kubectl get svc

Access Jenkins using NodePort or LoadBalancer IP.

💾 Storage Labs
HostPath Jenkins
kubectl apply -f jen_host.yaml

Fix permissions if needed:

sudo chown -R 1000:1000 /var/jenkins-data
Static PV Example
kubectl apply -f pv.yaml
kubectl apply -f pvc.yaml
kubectl apply -f pvc_mnt.yaml

Verify:

kubectl get pvc
EBS Dynamic Storage

Install EBS CSI Driver, then:

kubectl apply -f ebs-sc.yaml
kubectl apply -f ebs-test-pvc.yaml
kubectl apply -f ebs-test-pod.yaml

Expected status:

PVC → Bound
EFS Dynamic Storage

1️⃣ Create EFS filesystem in AWS
2️⃣ Allow NFS port 2049
3️⃣ Update fileSystemId in efs-sc.yaml

Apply:

kubectl apply -f efs-sc.yaml
kubectl apply -f efs-test-pvc.yaml
kubectl apply -f efs-test-pod.yaml
kubectl apply -f efs-test-pod-2.yaml

Deploy Jenkins with EFS:

kubectl apply -f jenkins-efs-test.yaml
🔄 Deployment Flow
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
🧠 Concepts Covered
Concept	Covered
Pod	✅
ReplicaSet	✅
Deployment	✅
DaemonSet	✅
HostPath	✅
Static PV	✅
Dynamic EBS	✅
Dynamic EFS	✅
RWO vs RWX	✅
Service Exposure	✅
⚠ Common Issues
PVC Pending

Possible causes:

CSI driver not installed

wrong fileSystemId

IAM role missing

CrashLoopBackOff

Possible causes:

volume permission issues

incorrect mount path

Cannot Access Jenkins

Possible causes:

wrong service type

NodePort blocked in security group

🎯 Production Recommendations

✔ Use EFS for Jenkins home directory
✔ Deploy Jenkins using Deployment
✔ Use Ingress + AWS ALB
✔ Enable IAM Roles for Service Accounts (IRSA)
❌ Avoid HostPath in production

📜 License

Educational DevOps Lab Project

💡 If you want, I can also help you upgrade this into a 🔥 “Top 1% DevOps GitHub README” with:

animated architecture diagrams

badges (Kubernetes / AWS / Jenkins)

table of contents

collapsible sections

pipeline diagrams

It will look much more impressive to recruiters.

yes and i create config map secrets and imagepuullled from the doker registry u missed above

Great catch 👍 — ConfigMaps, Secrets, and private Docker registry image pulls are important parts of your lab. I’ve updated the README section to include them properly and made it more GitHub-friendly and visual so it fits with the rest of your lab documentation.

You can add this section to your README (or replace the existing Config/Secrets part).

🔐 Configuration & Secrets Management
<img width="740" height="305" alt="image" src="https://github.com/user-attachments/assets/cefcf8a6-3dde-47ea-ad87-0968ea63e991" />
<img width="810" height="298" alt="image" src="https://github.com/user-attachments/assets/2a863e9f-577d-4ce9-ac7e-0a22613181ef" />
<img width="1200" height="1216" alt="image" src="https://github.com/user-attachments/assets/a93107e6-ea91-46ee-8213-17c7618ebae3" />


This lab also demonstrates externalizing configuration and managing secrets in Kubernetes, including pulling images from a private Docker registry.

Covered concepts:

Feature	Purpose
ConfigMap	Store application configuration
Secret	Store sensitive credentials
imagePullSecrets	Authenticate to private container registry
⚙️ ConfigMap Example

Files:

config_map.yaml
config-pod.yaml
config_deployment_pod.yaml
Purpose

ConfigMaps allow you to separate configuration from container images.

Example use cases:

Application configuration

Environment variables

Configuration files

Flow
ConfigMap
    ↓
Mounted as Environment Variable
    ↓
Pod / Deployment

Example usage:

kubectl apply -f config_map.yaml
kubectl apply -f config-pod.yaml

Check ConfigMap:

kubectl get configmap
🔐 Kubernetes Secrets

File:

secret-pod-registry.yaml

Secrets are used to securely store sensitive information such as:

passwords

API keys

registry credentials

TLS certificates

Example Types of Secrets
Type	Use Case
Opaque	generic credentials
kubernetes.io/dockerconfigjson	Docker registry login
TLS	HTTPS certificates

Check secrets:

kubectl get secrets
📦 Private Docker Registry Image Pull

This repository also demonstrates how to pull container images from a private Docker registry.

Create Registry Secret

Example:

kubectl create secret docker-registry regcred \
--docker-server=https://index.docker.io/v1/ \
--docker-username=<username> \
--docker-password=<password> \
--docker-email=<email>

Verify:

kubectl get secret regcred
🧱 Pod Using imagePullSecrets

Example configuration:

spec:
  containers:
  - name: app
    image: my-private-repo/myimage:latest

  imagePullSecrets:
  - name: regcred
Workflow
Private Docker Registry
        ↓
ImagePullSecret
        ↓
Kubernetes Pod
        ↓
Container Image Pulled
🧠 Why This Matters

Using ConfigMaps and Secrets enables:

✔ secure credential management
✔ environment-specific configuration
✔ safe container image pulls from private registries
✔ better DevOps practices

📘 Concepts Covered in This Section
Concept	Covered
ConfigMap	✅
Secret	✅
Docker Registry Secret	✅
imagePullSecrets	✅
Config Injection into Pods	✅

💡 Suggestion for your repo

Since your repository already contains many labs, the final README structure should be:

1. Overview
2. Architecture
3. Jenkins Workloads
4. Storage Labs
5. ConfigMaps & Secrets
6. Private Registry Image Pull
7. Deployment Guide
8. Troubleshooting
9. Production Recommendations

If you want, I can also help you add three things that will make your README look like a senior DevOps engineer repo:

1️⃣ Animated Kubernetes architecture diagrams
2️⃣ Badges (AWS, Kubernetes, Jenkins, CSI, EFS)
3️⃣ Collapsible sections for each lab

It will look 10x more professional on GitHub.

complete one README FILE PLZ WITH EVERYTHING INCLUDED IN IT?

Below is a complete, polished README.md that includes everything from your lab:

Jenkins workloads

Storage (HostPath, Static PV, EBS, EFS)

ConfigMaps

Secrets

Private Docker registry image pull

AWS integration

Architecture diagrams

Deployment steps

Troubleshooting

Production recommendations

You can copy-paste this entire file as your repository README.md.

🚀 Jenkins on Kubernetes — AWS Storage & Configuration Lab
<img width="769" height="572" alt="image" src="https://github.com/user-attachments/assets/9e1b5905-2b7a-4a11-a70a-188fd9e27982" />
<img width="1102" height="1070" alt="image" src="https://github.com/user-attachments/assets/67117cc7-8daf-421a-954b-6f6bc0dace2a" />
<img width="781" height="939" alt="image" src="https://github.com/user-attachments/assets/052fee0a-40bf-4c46-bfb3-6cb8eea408d0" />
<img width="1182" height="1097" alt="image" src="https://github.com/user-attachments/assets/01689613-e732-4b55-8fad-4478f9b79f13" />

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
