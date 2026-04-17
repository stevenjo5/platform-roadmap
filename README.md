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

## Version Control & CI/CD Standards

### Production Git Workflows (Day 14)
- **Branching Strategy**: Implemented **Feature Branching** (`feature/refactor-reporting`) to isolate development from the stable `main` branch.
- **Peer Review Lifecycle**: Executed a full **Pull Request (PR)** on GitHub, simulating an industry-standard code review and merge process.
- **Incident: Push Rejection (Upstream Out-of-Sync)**:
    - **Problem**: Encountered `error: failed to push some refs` due to local history trailing behind the remote origin.
    - **Remediation**: Synchronised local environment via `git pull origin main` and merged upstream changes into the feature branch before re-attempting the push.
- **Hygiene**: Practiced post-merge branch deletion to maintain repository cleanliness.

## Process & Resource Management

### Linux Process Lifecycle (Day 15)
- **Monitoring**: Utilised `ps aux` and `pstree` to audit system-wide process hierarchies and resource consumption.
- **Signal Management**: 
    - Mastered the distinction between **SIGTERM (15)** for graceful service termination and **SIGKILL (9)** for non-responsive process remediation.
    - Practiced background process execution using the ampersand (`&`) operator.
- **Tools**: `ps`, `kill`, `htop`.

### Automated Service Recovery (Day 16)
- **Watchdog Implementation**: Developed a custom **Process Watchdog** utility to monitor mission-critical service availability.
- **Logic**: Utilized `pgrep` and exit-code validation to trigger automated service restoration upon failure detection.
- **Goal**: Reduced **Mean Time To Recovery (MTTR)** by implementing primitive self-healing infrastructure.
- **Tools**: `pgrep`, `pkill`, Bash conditional logic.

## Automated Service Reliability (Day 17)
- **Infrastructure Orchestration**: Scheduled the `watchdog.sh` utility via system `crontab` for 60-second interval polling.
- **Incident Resolution**: 
    - **Issue**: Script failed execution due to `unexpected end of file`.
    - **Diagnosis**: Analyzed `watchdog.log` to identify a syntax error in the conditional logic.
    - **Remediation**: Corrected the Bash `if/fi` block, restoring automated service recovery.
- **Validation**: Confirmed successful process resurrection via `pgrep` after manual `pkill` termination.

## Observability & Resource Monitoring

### Automated Health Audits (Day 18)
- **Metric Extraction**: Utilized `awk` and `grep` to parse raw system data into actionable numerical metrics.
- **Resource Monitoring**: Developed `health_check.sh` to monitor RAM consumption against defined performance thresholds.
- **Goal**: Transitioning from "Process Uptime" to "Performance Observability" to ensure platform stability.
- **Tools**: `free`, `awk`, `cut`.

## Platform Maintenance & Storage Optimization

### Automated Log Rotation (Day 19)
- **Log Management**: Implemented `logrotate` policies to prevent disk exhaustion from high-frequency telemetry.
- **Data Compression**: Configured `gzip` compression for archived logs, reducing storage footprint by ~90%.
- **Retention Policy**: Established a 3-cycle rotation policy to ensure only relevant audit data is retained.
- **Tools**: `logrotate`, `gzip`, `copytruncate`.

## Developer Experience (DevEx) & Tooling

### Platform Dashboard (Day 20)
- **Data Aggregation**: Developed a unified dashboard to provide real-time visibility into process health, memory consumption, and disk utilization.
- **Visual Feedback**: Implemented Bash color coding (`ANSI escape codes`) to highlight system failures vs. healthy states.
- **Contextual Auditing**: Integrated live log-tailing into the dashboard for immediate troubleshooting.

## Developer Experience & Interface Design

### Command Aliasing & Path Abstraction (Day 21)
- **Tooling Accessibility**: Implemented permanent Bash aliases within `.bashrc` to provide global access to custom platform utilities.
- **Cognitive Load Reduction**: Abstracted complex script paths into single-word commands (`status`, `watch`), standardizing the developer's CLI experience.
- **Persistence Engineering**: Utilized shell profile sourcing to ensure environmental consistency across terminal sessions.
- **Tools**: `.bashrc`, `alias`, `source`.

## Infrastructure as Code (IaC)

### Provisioning Challenges & Logic (Day 22)
- **Objective**: Initialise the Terraform ecosystem for declarative infrastructure management.
- **Incident Response**: Encountered **HTTP 429 (Too Many Requests)** rate-limiting during the provider repository integration phase.
- **Engineering Troubleshooting**:
    - **GPG Key Management**: Attempted manual injection of GPG keys into `/usr/share/keyrings` to resolve repository trust issues.
    - **Network Resilience**: Pivoted between `wget` and `curl` to bypass CDN-level blocking and rate limits.
    - **Architecture Fallback**: Evaluated a manual binary installation via the HashiCorp Releases server to circumvent package manager (`apt`) dependencies.
- **Outcome**: Environment provisioning deferred to Day 23 to allow for IP cooling/TTL expiry, prioritising system stability over forced configuration.
- **Tools**: `Terraform`, `GPG`, `curl`, `wget`.


### The Terraform Lifecycle & Troubleshooting (Day 23)
- **Objective**: Initialise and execute the first managed resource using HashiCorp Terraform.
- **Incident Resolution (429 Rate Limiting)**: 
    - Encountered persistent **HTTP 429** errors when attempting to reach HashiCorp repositories via CLI.
    - **Platform Solution**: Pivoted to a manual binary injection strategy. Downloaded the Linux binary via a Windows host bridge and moved it into the Linux System Path (`/usr/local/bin`).
- **Workflow Execution**: 
    - **Init**: Successfully initialised the "Local Provider" backend.
    - **Plan**: Validated the execution blueprint for a `local_file` resource.
    - **Apply**: Provisioned the resource and verified state persistence.
- **Repository Hygiene**: Hardened the master `.gitignore` to prevent leaking `terraform.tfstate` (infrastructure "secrets") and environment-specific drivers.
- **Tools**: `Terraform v1.7.5`, `HCL`, `Git`, `Linux Binary Management`.

## Infrastructure as Code (IaC)

### Dynamic Provisioning & Variables (Day 24)
- **Abstraction**: Decoupled hard-coded values from infrastructure logic using `variables.tf`.
- **Parameterisation**: Implemented input variables to allow for "Self-Service" configurations.
- **Dynamic Overrides**: Demonstrated the ability to inject runtime variables via CLI flags (`-var`).
- **Tools**: `Terraform`, `HCL Variables`.

## Infrastructure as Code (IaC)

### Custom Workflow Automation (Day 25)
- **Provisioning Hooks**: Implemented the `local-exec` provisioner to execute automated shell commands immediately following resource creation.
- **Log Standardisation**: Developed a plain-text auditing system (`deploy.log`) to track deployment success without relying on non-standard characters (emojis), ensuring cross-platform log compatibility.
- **Dynamic Metadata**: Utilized the `${self.id}` attribute to inject real-time resource identifiers into external audit logs.
- **Repository Hygiene**: Hardened the master `.gitignore` to exclude local execution logs, maintaining a clean, production-ready codebase.
- **Tools**: `Terraform`, `local-exec`, `Bash`, `Git`.

## Infrastructure as Code (IaC)

### Lifecycle Management & Safety Locks (Day 26)
- **Accidental Deletion Prevention**: Implemented `prevent_destroy` lifecycle rules to protect critical resources from unauthorised termination.
- **Risk Mitigation**: Verified the "Locked" state by confirming that `terraform destroy` commands are rejected by the engine.
- **Production Standards**: Adopted "Safety First" infrastructure patterns used to protect production databases and networking in UK engineering teams.
- **Tools**: `Terraform Lifecycle`, `prevent_destroy`.

## Infrastructure as Code (IaC)

### External Data Integration (Day 27)
- **Data Sources**: Implemented `data` blocks to enable read-only access to existing system files.
- **Audit Verification**: Utilized the `local_file` data source to fetch and expose contents of the `deploy.log` for programmatic auditing.
- **HCL Logic**: Demonstrated the distinction between "Managed Resources" (Write) and "Data Sources" (Read).
- **Tools**: `Terraform Data Sources`, `HCL`.
