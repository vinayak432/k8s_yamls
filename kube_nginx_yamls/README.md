# 🚀 Kubernetes Nginx Scheduling Lab

This repository is a hands-on Kubernetes lab to understand how pod scheduling works using:

- Taints & Tolerations
- NodeSelector
- NodeAffinity (Hard & Soft)
- PodAffinity
- PodAntiAffinity
- Deployments
- ReplicaSets
- DaemonSets
- Services

All examples use **nginx** to demonstrate real scheduling behaviour.

---

## 🖥️ Cluster Setup Used

This repo was tested on a 3-node cluster:

| Node | Role | Notes |
|------|------|------|
| Control Plane | Master | Tainted (not used for scheduling) |
| Worker 1 | Compute | size=big |
| Worker 2 | Compute | size=big |

Available node labels:


kubernetes.io/hostname
size=big


No zone labels exist, so:


kubernetes.io/hostname


is used as topology key.

---

## 📦 Workloads

| App | Label |
|-----|------|
| Backend | `app=backend` |
| Nginx | `app=nginx` |

---

## 📂 YAML Files Explained

### Basic Objects

| File | Purpose |
|------|--------|
| nginx-pod.yaml | Simple Pod |
| nginx-rs.yaml | ReplicaSet |
| nginx-rs-toleration.yaml | RS with toleration |
| nginx-daemonset.yaml | DaemonSet |
| nginx_deployment.yaml | Rolling Update Deployment |
| nginx_service_lb.yaml | LoadBalancer Service |

---

### Scheduling Examples

| File | Concept |
|------|--------|
| nginx_deploy_nodeselector.yaml | NodeSelector |
| nginx_deploy_nodeaff_hard_rule.yaml | Hard NodeAffinity |
| nginx_deploy_nodeaff_soft_rule.yaml | Soft NodeAffinity |
| nginx_backend.yaml | Backend deployment |
| nginx_deploy_podaff.yaml | PodAffinity |
| nginx_deploy_podantiaff.yaml | PodAntiAffinity |

---

## 🧠 Concepts Demonstrated

### NodeSelector
Schedules pods to nodes with matching labels.

---

### NodeAffinity

Hard Rule:


requiredDuringSchedulingIgnoredDuringExecution


Soft Rule:


preferredDuringSchedulingIgnoredDuringExecution


---

### PodAffinity

Used to place pods **together**.

Example:

Run nginx near backend pods.

---

### PodAntiAffinity

Used to **spread pods apart** for High Availability.

Example:

Prevent nginx replicas from running on same node.

---

## ⚠️ Observed Behaviour

### PodAntiAffinity

| Replicas | Worker Nodes | Result |
|----------|--------------|--------|
| 2 | 2 | Spread perfectly |
| 3 | 2 | 1 Pending |
| 4 | 2 | 2 Pending |

Reason:

Hard anti-affinity allows:


Max pods = number of topology domains


Here:


Domains = Nodes = 2


---

### AntiAffinity Selector Behaviour

| Selector | Effect |
|----------|--------|
| app=nginx | Spread nginx pods |
| app=backend | Avoid backend nodes |
| No matching pods | Rule ignored |

---

## 🛠️ How To Run

Deploy backend:


kubectl apply -f nginx_backend.yaml


Deploy nginx with PodAffinity:


kubectl apply -f nginx_deploy_podaff.yaml


Deploy nginx with PodAntiAffinity:


kubectl apply -f nginx_deploy_podantiaff.yaml


---

## 🧹 Cleanup


kubectl delete deployment --all


---

## 🎯 Goal

This repository helps understand:

✔ Node-based scheduling  
✔ Pod co-location  
✔ Pod spreading for HA  
✔ Hard vs Soft rules  
✔ Scheduling limits in small clusters  

---

## 📘 Key Takeaways

| Feature | Purpose |
|--------|--------|
| NodeAffinity | Choose node |
| PodAffinity | Bring pods together |
| PodAntiAffinity | Spread pods apart |

---

Happy Learning 🚀
