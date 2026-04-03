# Platform Engineering Roadmap - UK 2026

This repository documents a 14-week technical transition into DevOps and Platform Engineering.

## Week 1: Linux and Automation
- Technical Milestone: Developed a self-healing Bash script (check_system.sh).
- Core Competencies: WSL2, Bash conditional logic, and Linux filesystem permissions.

## Week 2: Cloud Infrastructure (AWS)
- Day 8: Installed AWS CLI v2 and configured IAM Security protocols.
- Region: Primary deployment operations in eu-west-2 (London).
- Security: Root account secured with MFA; operations conducted via IAM Administrative user.

## Infrastructure Operations & Incident Management

### Incident Report: WSL2 Virtual Network Bridge Failure (APIPA)
- **Status**: Resolved (Day 10)
- **Classification**: Connectivity / DHCP Handshake Failure
- **Incident Description**: Interface `eth0` on the Ubuntu subsystem was assigned an Automatic Private IP Addressing (APIPA) address (`169.254.x.x`). Resulted in total egress failure to the public internet and AWS API endpoints.

#### Root Cause Analysis (RCA)
The failure originated from an inconsistency in the Windows Host Network Service (HNS) and the Virtual Switch bridge. The subsystem failed to receive a valid lease from the internal DHCP server, leading to a Link-Local fallback.

#### Remediation Actions (Finalised Day 10)
1. **Configuration Tuning**: Modified `.wslconfig` to utilize `mirrored` networking mode for enhanced stability and DNS tunneling.
2. **Service Recovery**: Executed a force-reset of the Host Network Service (HNS) and Windows Virtual Switch stack.
3. **Network Persistence (Day 10 Solution)**: 
    - Reconfigured `/etc/wsl.conf` to disable the automated generation of `resolv.conf`.
    - Manually provisioned a static `/etc/resolv.conf` pointing to Google Public DNS (`8.8.8.8`).
4. **Validation**: Successfully restored connectivity via ICMP echo requests to `google.com` (0% packet loss).

#### Operational Takeaway
This incident demonstrated the limitations of default virtualised network stacks. The successful Day 10 resolution proved the ability to perform deep-dive infrastructure debugging and implement manual overrides to maintain service availability.

### SSH Infrastructure & Authentication (Day 11)
- **Standard**: Migrated repository authentication from HTTPS to **SSH (Ed25519)**.
- **Security**: Implemented passphrase-protected private keys to secure the local-to-remote delivery pipeline.
- **Validation**: Confirmed successful handshake with GitHub's SSH gateway.

## Software & Package Management

### Linux Package Infrastructure (Day 12)
- **Standard**: Utilized `apt` for enterprise-grade software lifecycle management.
- **Competencies**: 
    - Performed system audits via `apt update` and `apt list --upgradable`.
    - Automated software provisioning using non-interactive flags (`-y`).
    - Implemented system hygiene protocols using `autoremove` to minimize the system's footprint.
- **Tools**: `apt`, `htop`.

