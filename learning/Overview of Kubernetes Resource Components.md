<img src="https://r2cdn.perplexity.ai/pplx-full-logo-primary-dark%402x.png" class="logo" width="120"/>

# Overview of Kubernetes Resource Components

Kubernetes uses resource components to manage compute, memory, and other resources for containers and applications running in a cluster. Here is a straightforward overview:

## Core Resource Components

### 1. CPU (Central Processing Unit)

- **Description:** Represents processing power available to a container.
- **Unit:** millicores (m) or full CPUs.
    - 1 CPU = 1,000m.
- **Behavior:** CPU can be throttled if overused (compressible resource).


### 2. Memory (RAM)

- **Description:** Specifies the amount of memory (RAM) a container can use.
- **Unit:** MiB (Mebibytes), GiB (Gibibytes).
- **Behavior:** If a container exceeds its memory limit, it is terminated (non-compressible).


### 3. Ephemeral Storage

- **Description:** Temporary storage for logs, cache, or files that don’t persist after the container is destroyed.
- **Unit:** MiB, GiB.
- **Behavior:** Limits prevent a container from filling up the node’s disk.


### 4. Extended and Custom Resources

- **Description:** Specialized resources like GPUs or other custom hardware for advanced workloads.
- **Examples:** `nvidia.com/gpu` for GPUs.


## Resource Requests and Limits

Kubernetes allows you to set "requests" and "limits" for each container:

- **Requests:** The minimum amount of resource guaranteed to the container.
- **Limits:** The maximum amount a container is allowed to consume.

**Why this matters:**
Requests help the scheduler decide where to place a pod. Limits ensure containers don’t consume excessive shared resources, keeping the system stable.

## Example YAML Specification

```yaml
resources:
  requests:
    cpu: "250m"      # At least 0.25 CPU core guaranteed
    memory: "128Mi"  # At least 128MiB RAM guaranteed
  limits:
    cpu: "500m"      # At most 0.5 CPU core can be used
    memory: "256Mi"  # At most 256MiB RAM can be used
```


## Summary Table

| Resource | What It Controls | Common Units | Compressible? |
| :-- | :-- | :-- | :-- |
| CPU | Processing power | m, CPU | Yes (throttled) |
| Memory | RAM | Mi, Gi | No (container killed if exceeded) |
| Ephemeral Storage | Temporary disk space | Mi, Gi | No (container killed if exceeded) |
| Extended/Custom | Specialized devices (e.g., GPU, FPGA) | Device units | Depends on type |

## Key Resource Components in Kubernetes Cluster

- **Node:** Worker machine in the cluster — physical or virtual.
- **Pod:** The smallest deployable unit; groups one or more containers.
- **Namespace:** Logical partition for resources, offering separation and quota management.
- **ResourceQuota:** Object to control resource consumption per namespace.
- **LimitRange:** Sets default/min/max requests or limits for resource types within a namespace.

Understanding and managing these core resource components ensures efficient, fair, and reliable operation of containerized applications across your Kubernetes cluster.

