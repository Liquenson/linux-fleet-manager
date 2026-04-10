# 🐧 Linux Fleet Manager

> Enterprise-grade Bash automation toolkit for managing large-scale Linux infrastructure (500+ servers)

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Bash Version](https://img.shields.io/badge/bash-%3E%3D4.0-green.svg)](https://www.gnu.org/software/bash/)
[![Maintenance](https://img.shields.io/badge/Maintained%3F-yes-green.svg)](https://github.com/Liquenson/linux-fleet-manager/graphs/commit-activity)

## 🎯 Overview

Linux Fleet Manager is a comprehensive collection of production-ready Bash scripts designed to automate and streamline the management of large-scale Linux server infrastructures. Built from real-world enterprise experience managing 500+ servers across multiple data centers and cloud environments.

### Real-World Scenario

This toolkit addresses the challenges of managing:
- **1500+ Linux servers** across multiple data centers
- **500 web servers** (Nginx/Apache)
- **400 application servers** (Java/Python/Node.js)
- **300 database servers** (PostgreSQL/MySQL/MongoDB)
- **200 cache servers** (Redis/Memcached)
- **100 monitoring/logging servers** (Prometheus/ELK)

Distributed across:
- 3 Data Centers (Madrid, Barcelona, Valencia)
- 5 Environments (Dev, Test, Staging, Production, DR)
- Multiple OS distributions (Ubuntu 20.04/22.04, CentOS 7/8, RHEL 8/9)

## ✨ Features

### 🔍 Inventory & Auditing
- Automated server discovery and asset inventory
- Hardware and software inventory collection
- Compliance reporting (CSV/JSON export)
- CMDB integration support

### 🏥 Health Monitoring
- Parallel health checks across entire fleet
- Service availability monitoring
- Resource usage tracking (CPU, RAM, Disk, Network)
- Automated alerting for critical issues

### 🔒 Security & Compliance
- Automated security patch deployment
- CVE vulnerability scanning
- Security compliance auditing (CIS, PCI-DSS)
- SSH configuration hardening

### 👥 User Management
- Bulk user provisioning/deprovisioning
- SSH key distribution at scale
- Sudo access management
- Access audit trails

### 💾 Backup & Recovery
- Automated backup verification
- Restore testing
- Backup integrity checks
- Cloud storage integration

### 📊 Monitoring & Analytics
- Centralized log collection
- Capacity planning and forecasting
- Performance trending
- Custom metric collection

### 🔄 Service Orchestration
- Zero-downtime rolling restarts
- Load balancer integration
- Service deployment automation
- Automatic rollback on failure

## 🚀 Quick Start

### Prerequisites

```bash
# Required on control server
- Bash 4.0+
- SSH client
- jq (for JSON processing)
- GNU Parallel (recommended)

# Install dependencies (Ubuntu/Debian)
sudo apt-get update
sudo apt-get install -y jq parallel openssh-client

# Install dependencies (CentOS/RHEL)
sudo yum install -y jq parallel openssh-clients
```

### Installation

```bash
# Clone the repository
git clone https://github.com/Liquenson/linux-fleet-manager.git
cd linux-fleet-manager

# Make scripts executable
chmod +x scripts/**/*.sh

# Configure your server inventory
cp config/servers.ini.example config/servers.ini
vim config/servers.ini
```

### Basic Usage

```bash
# Run server inventory
./scripts/inventory/server-inventory.sh

# Perform health check on all servers
./scripts/health-check/mass-health-check.sh

# Manage users across fleet
./scripts/user-management/bulk-user-management.sh --action create --users-file users.txt
```

## 📚 Use Cases

### Enterprise Operations
- **IT Asset Management:** Automated inventory for CMDB/ITSM systems
- **Compliance Auditing:** SOC2, ISO 27001, PCI-DSS compliance checks
- **Patch Management:** Security patch deployment across entire fleet
- **Incident Response:** Rapid information gathering during outages

### Security Operations
- **Vulnerability Management:** CVE scanning and remediation tracking
- **Access Control:** Centralized user and SSH key management
- **Audit Trails:** Complete logging of all administrative actions
- **Compliance Reporting:** Automated generation of compliance reports

### DevOps Teams
- **Configuration Management:** Ensure consistency across all servers
- **Service Orchestration:** Coordinate deployments and updates
- **Monitoring Integration:** Feed data to Prometheus, ELK, Grafana
- **Automation:** Reduce manual tasks and human error

## 🏗️ Project Structure

linux-fleet-manager/
├── README.md
├── LICENSE
├── .gitignore
├── docs/
│   ├── installation.md
│   ├── architecture.md
│   ├── use-cases.md
│   └── troubleshooting.md
├── scripts/
│   ├── inventory/
│   │   └── server-inventory.sh
│   ├── health-check/
│   │   └── mass-health-check.sh
│   ├── patch-management/
│   │   └── security-patch-deployment.sh
│   ├── user-management/
│   │   └── bulk-user-management.sh
│   ├── backup/
│   │   └── backup-verification.sh
│   ├── monitoring/
│   │   └── centralized-log-collector.sh
│   ├── orchestration/
│   │   └── rolling-restart.sh
│   └── compliance/
│       └── security-compliance-audit.sh
├── config/
│   ├── servers.ini.example
│   └── variables.env.example
├── tests/
│   └── test-inventory.sh
└── examples/
└── basic-usage.md

## 🛠️ Technology Stack

- **Shell:** Bash 4.0+
- **Transport:** SSH / OpenSSH
- **Parallelization:** GNU Parallel
- **Data Processing:** jq, awk, sed
- **Monitoring:** Integration with Prometheus, ELK, Grafana
- **Cloud:** AWS CLI, Azure CLI (optional)

## 📖 Documentation

- [Installation Guide](docs/installation.md) - Complete installation instructions
- [Architecture Overview](docs/architecture.md) - System design and components
- [Use Cases](docs/use-cases.md) - Real-world scenarios and examples
- [Troubleshooting](docs/troubleshooting.md) - Common issues and solutions

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👨‍💻 Author

**Liquenson Ruben Alexis**  
DevOps Engineer || Cloud & Linux Administrator || AWS || Kubernetes · 
Gran Canaria, España

- 📧 Email: liquenson.cloud@gmail.com
- 💼 LinkedIn: [linkedin.com/in/liquenson-ruben-490961269](https://www.linkedin.com/in/liquenson-ruben-490961269/)
- 🐙 GitHub: [@Liquenson](https://github.com/Liquenson)
- 📱 Phone: +34 608 541 718

## 🙏 Acknowledgments

Built with experience from managing production Linux infrastructure at enterprise scale in multi-datacenter environments. Inspired by real-world challenges in managing 500+ servers across distributed systems.

---

⭐ **If this project helps you, please consider giving it a star!**

## 🔗 Related Projects

- [aws-terraform-devops-lab](https://github.com/Liquenson/aws-terraform-devops-lab) - AWS Infrastructure with Terraform
