# Docmost Kubernetes Deployment

This repository contains a complete Kubernetes deployment setup for **Docmost**, a document management web application. It includes deployments for the main application, PostgreSQL database, Redis cache, and required services, storage, secrets, and autoscaling.

## 📦 Components Deployed

### 1. **Namespace**
- A dedicated `docmost` namespace is created to isolate all resources related to the application.

### 2. **Secrets**
- A Kubernetes `Secret` is used to store sensitive values:
  - PostgreSQL password
  - SMTP credentials for email notifications

### 3. **Persistent Volume Claims (PVCs)**
- `pvc-docmost-storage`: Used by the main Docmost app to store persistent data.
- `pvc-docsmost-db`: Used by the PostgreSQL container.
- `pvc-docsmost-redis`: Used by the Redis container.

### 4. **Deployments**
- `docmost`: Main web application running two replicas with environment variables configured.
- `docsmost-db`: PostgreSQL 16-alpine database.
- `docsmost-redis`: Redis 7.2-alpine cache service.

### 5. **Services**
- `docmost-service`: LoadBalancer exposing the app on port 80.
- `docsmost-db`: Internal ClusterIP service for PostgreSQL.
- `docsmost-redis`: Internal ClusterIP service for Redis.

### 6. **Horizontal Pod Autoscaler**
- Automatically scales the Docmost app between 2 to 4 replicas based on CPU usage (target: 60% CPU utilization).

---

## ⚙️ Pre-requisites

- Kubernetes cluster (bare-metal or cloud)
- `nfs-client-provisioner` set as your default storage class (`nfs-client`)
- MetalLB (or cloud LB) configured for `LoadBalancer` support
- SMTP credentials and domain ready

---
