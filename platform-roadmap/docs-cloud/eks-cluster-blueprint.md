# Enterprise Managed Kubernetes Cluster Architecture (AWS EKS Topology)

## 1. Network Foundation (VPC & Subnet Layer)
To guarantee high availability and fault isolation, the cluster spans across three separate **Availability Zones (AZs)**.
- **CIDR Block**: `10.0.0.0/16` (Provides 65,536 private cluster IP addresses).
- **Public Subnets**: Three subnets (`10.0.1.0/24`, `10.0.2.0/24`, `10.0.3.0/24`) housing public-facing Internet Gateways and Managed NAT Gateways.
- **Private Subnets**: Three insulated subnets (`10.0.10.0/24`, `10.0.11.0/24`, `10.0.12.0/24`) where all production compute node instances sit securely without direct public internet routes.

## 2. Compute Infrastructure (Managed Node Pools)
- **Control Plane**: AWS-managed, highly available EKS API server running across automated master nodes.
- **Worker Node Selection**: `t3.medium` or `m5.large` Amazon Linux 2 EC2 instances.
- **Auto-Scaling Layout Groups**:
  - **Minimum Nodes**: 3 (Ensures at least 1 compute node sits in each Availability Zone for drift protection).
  - **Desired Nodes**: 3 (Steady-state baseline configuration).
  - **Maximum Nodes**: 9 (Allows horizontal pod autoscalers to absorb sudden traffic spikes).

## 3. Storage & Secret Integration Mapping
- **Persistent Volume Driver**: AWS EBS CSI Driver linked to AWS Elastic Block Store storage volumes instead of local `hostPath` disks.
- **Secret Provider**: AWS Secrets Manager integrated via the Kubernetes External Secrets Operator to keep keys hardware-encrypted.
