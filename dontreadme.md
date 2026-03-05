☸️ Kubernetes DevOps Lab — AWS, Storage, Scheduling & Workloads

"You don't learn Kubernetes by reading about it.
You learn it by breaking things — and this repo is where that journey begins."

A hands-on Kubernetes learning lab built on AWS EC2 using kubeadm, designed to explore storage, scheduling, and workload patterns used in real production environments.

Apply → Observe → Break → Fix → Learn 🔁

📌 Overview

This repository demonstrates real-world Kubernetes infrastructure concepts including:

📦 Static & Dynamic Persistent Volumes

💾 AWS EBS Block Storage

📂 AWS EFS Shared Storage (RWX)

🧑‍💻 Jenkins deployments (multiple patterns)

🌐 Nginx scheduling experiments

☕ Tomcat deployments

🔄 ReplicaSets, Deployments, DaemonSets

🎯 NodeSelector, Node Affinity, Pod Affinity / Anti-Affinity

🌍 AWS LoadBalancer services

This lab is ideal for:

DevOps practice

Kubernetes interview preparation

Storage architecture learning

Scheduling strategy experimentation

AWS + Kubernetes integration

🏗 High-Level Architecture
                         AWS Cloud
                              │
                     ┌───────────────┐
                     │      VPC      │
                     └───────────────┘
                              │
        ┌───────────────────────────────┐
        │     Kubernetes Cluster        │
        └───────────────────────────────┘
               │                    │
       Control Plane            Worker Nodes
        (kubeadm)              (EC2 Instances)
               │                    │
        API Server              kubelet
        Scheduler               containerd
        etcd                    Calico CNI
               │                    │
               └──────────────┬─────┘
                              │
              ┌───────────────┼───────────────┐
              │               │               │
           HostPath        EBS CSI          EFS CSI
           (local)         (RWO)             (RWX)
              │               │               │
        Jenkins / Nginx / Tomcat workloads using PV/PVC
📂 Repository Structure

Instead of a big file tree, the repository is organized into logical learning modules.

🔹 Jenkins Workloads

Files:

jenkins-pod.yaml
jenkins-rs.yaml
jenkins-deployment.yaml
jenkins-daemonset.yaml
jenkins-service.yaml
jenkins-efs-test.yaml
jen_host.yaml

Demonstrates:

Pod vs ReplicaSet vs Deployment

DaemonSet behavior

Persistent storage

Service exposure

🔹 Nginx Scheduling Lab

Located under:

nginx/

Includes:

nginx-pod.yaml
nginx-rs.yaml
nginx-daemonset.yaml
nginx_deployment.yaml
nginx_service_lb.yaml
nginx_backend.yaml
Advanced Scheduling Examples
nginx_deploy_nodeselector.yaml
nginx_deploy_nodeaff_hard_rule.yaml
nginx_deploy_nodeaff_soft_rule.yaml
nginx_deploy_podaff.yaml
nginx_deploy_podantiaff.yaml

Demonstrates:

NodeSelector

Node Affinity (Hard & Soft)

Pod Affinity

Pod Anti-Affinity

Tolerations

LoadBalancer Services

🔹 Tomcat Deployments
tomcat_pod.yaml
tomcat-rs.yaml
tomcat-deployment.yaml
tomcat-daemonset.yaml
tomcat_service_lb.yaml

Demonstrates:

Stateless web deployments

Horizontal scaling

AWS LoadBalancer services

🔹 Storage Examples
Static Storage
pv.yaml
pvc.yaml
pvcmnt.yaml
pvc_mnt.yaml
hostpath-eg.yaml
EBS Dynamic Provisioning
ebs-sc.yaml
ebs-test-pvc.yaml
ebs-test-pod.yaml
EFS Dynamic Provisioning
efs-sc.yaml
efs-test-pvc.yaml
efs-test-pod.yaml
efs-test-pod-2.yaml
🧪 Learning Modules Covered
Feature	Covered
Static PV	✅
HostPath	✅
EBS Dynamic	✅
EFS Dynamic	✅
RWX vs RWO	✅
ReplicaSets	✅
Deployments	✅
DaemonSets	✅
NodeSelector	✅
Node Affinity	✅
Pod Affinity	✅
Pod Anti-Affinity	✅
Tolerations	✅
LoadBalancer Services	✅
🚀 Step-By-Step Lab Guide
Phase 1 — Setup Kubernetes (kubeadm)

Install:

containerd

kubeadm

kubelet

kubectl

Calico CNI

Verify cluster:

kubectl get nodes
kubectl get pods -n kube-system
Phase 2 — Install AWS CSI Drivers
EBS CSI
helm repo add aws-ebs-csi-driver https://kubernetes-sigs.github.io/aws-ebs-csi-driver

helm install aws-ebs-csi-driver \
aws-ebs-csi-driver/aws-ebs-csi-driver \
-n kube-system
EFS CSI
helm repo add aws-efs-csi-driver https://kubernetes-sigs.github.io/aws-efs-csi-driver

helm install aws-efs-csi-driver \
aws-efs-csi-driver/aws-efs-csi-driver \
-n kube-system

⚠ EFS filesystem must be created manually in AWS.

Phase 3 — Storage Testing
Static PV
kubectl apply -f pv.yaml
kubectl apply -f pvc.yaml
EBS Dynamic
kubectl apply -f ebs-sc.yaml
kubectl apply -f ebs-test-pvc.yaml
kubectl apply -f ebs-test-pod.yaml
EFS RWX
kubectl apply -f efs-sc.yaml
kubectl apply -f efs-test-pvc.yaml
kubectl apply -f efs-test-pod.yaml
kubectl apply -f efs-test-pod-2.yaml
Phase 4 — Jenkins Deployment
kubectl apply -f jenkins-deployment.yaml
kubectl apply -f jenkins-service.yaml

Or use EFS backed Jenkins:

kubectl apply -f jenkins-efs-test.yaml
Phase 5 — Nginx Scheduling Lab

Try different scheduling policies:

kubectl apply -f nginx_deploy_nodeselector.yaml
kubectl apply -f nginx_deploy_nodeaff_hard_rule.yaml
kubectl apply -f nginx_deploy_nodeaff_soft_rule.yaml
kubectl apply -f nginx_deploy_podaff.yaml
kubectl apply -f nginx_deploy_podantiaff.yaml

Observe pod placement:

kubectl get pods -o wide
Phase 6 — Deploy Tomcat
kubectl apply -f tomcat-deployment.yaml
kubectl apply -f tomcat_service_lb.yaml

Check external IP:

kubectl get svc
🔄 Kubernetes Deployment Flow
kubectl apply
      ↓
API Server
      ↓
Scheduler
      ↓
PVC Created
      ↓
CSI Driver provisions storage
      ↓
PV Bound
      ↓
Pod starts
      ↓
Service exposed
      ↓
AWS LoadBalancer created
⚠ Common Issues
PVC Pending

Possible reasons:

CSI driver not installed

incorrect StorageClass

IAM permissions missing

EFS NFS port (2049) blocked

CrashLoopBackOff

Possible reasons:

incorrect mount path

permission issues

LoadBalancer Pending

Possible reasons:

AWS LB controller missing

IAM policy not attached

🧠 Production Best Practices

Use Deployments instead of bare Pods

Use EFS for shared workloads

Use EBS for stateful block storage

Use Ingress + AWS ALB

Enable IRSA for AWS permissions

🎯 Outcome

After completing this lab you will understand:

Kubernetes storage internals

CSI driver architecture

Advanced scheduling strategies

AWS integration patterns

Real-world DevOps troubleshooting

👤 Author

Vinayak

DevOps | Kubernetes | AWS

GitHub:
https://github.com/vinayak432
