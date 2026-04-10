# 🐧 Linux Fleet Manager

> Enterprise-grade Bash automation toolkit for managing large-scale Linux infrastructure

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Bash Version](https://img.shields.io/badge/bash-%3E%3D4.0-green.svg)](https://www.gnu.org/software/bash/)
[![CI](https://github.com/Liquenson/linux-fleet-manager/actions/workflows/ci.yml/badge.svg)](https://github.com/Liquenson/linux-fleet-manager/actions/workflows/ci.yml)
[![Maintenance](https://img.shields.io/badge/Maintained%3F-yes-green.svg)](https://github.com/Liquenson/linux-fleet-manager/graphs/commit-activity)

## 🎯 Overview

Linux Fleet Manager is a production-ready Bash automation toolkit designed to streamline the management of large-scale Linux server infrastructures. Built with enterprise best practices, automated testing, and cross-platform compatibility.

### What It Does

Automates critical infrastructure management tasks:
- 📊 **Server Inventory Collection** - Automated asset discovery and reporting
- 🏥 **Health Monitoring** - Parallel health checks across entire fleet
- 👥 **User Management** - Bulk user provisioning and SSH key distribution
- 🔒 **Security & Compliance** - Automated patching and compliance auditing
- 💾 **Backup Verification** - Automated backup integrity checks
- 📈 **Monitoring Integration** - Centralized log collection and metrics

### Enterprise-Grade Quality

✅ **Multi-Platform Support** - Tested on Ubuntu, macOS, and Windows (Git Bash)  
✅ **CI/CD Pipeline** - Automated testing with GitHub Actions  
✅ **Code Quality** - ShellCheck validated, zero warnings  
✅ **Comprehensive Documentation** - Installation guides, examples, and best practices  
✅ **Shared Libraries** - DRY principles with reusable components  

## ✨ Features

### 🔍 Server Inventory
- **Multi-format export** (CSV/JSON) for integration with CMDB systems
- **Cross-platform compatible** (Linux, macOS, Windows)
- **Automated data collection** (hostname, OS, kernel, CPU, date)
- **Extensible architecture** for adding custom metrics

### 🏥 Health Monitoring *(Coming Soon)*
- Parallel health checks across entire fleet
- Service availability monitoring
- Resource usage tracking
- Automated alerting

### 👥 User Management *(Coming Soon)*
- Bulk user provisioning/deprovisioning
- SSH key distribution at scale
- Sudo access management
- Access audit trails

### 🔒 Security & Compliance *(Coming Soon)*
- Automated security patch deployment
- CVE vulnerability scanning
- Security compliance auditing (CIS, PCI-DSS, SOC2)
- SSH configuration hardening

## 🚀 Quick Start

### Prerequisites

```bash
# Required
- Bash 4.0+ (Bash 3.x supported on macOS)
- SSH client
- awk, cut, tr (standard Unix tools)

# Optional (for development)
- ShellCheck (code linting)
- jq (JSON processing)
```

### Installation

```bash
# Clone the repository
git clone https://github.com/Liquenson/linux-fleet-manager.git
cd linux-fleet-manager

# Make scripts executable (Unix/Linux/macOS)
chmod +x scripts/inventory/server-inventory.sh
chmod +x lib/*.sh

# Configure your server inventory
cp config/servers.ini.example config/servers.ini
vim config/servers.ini  # Add your servers
```

### Basic Usage

```bash
# Display help
./scripts/inventory/server-inventory.sh --help

# Generate CSV inventory
./scripts/inventory/server-inventory.sh --format csv

# Generate JSON inventory
./scripts/inventory/server-inventory.sh --format json

# Custom output filename
./scripts/inventory/server-inventory.sh --format csv --output my-servers.csv

# View generated report
cat reports/server-inventory_*.csv
```

### Example Output

**CSV Format:**
```csv
Hostname,IP Address,OS Name,Kernel,CPU Count,Last Update
web-server-01,127.0.0.1,Linux,5.15.0-91-generic,8,2026-04-10
app-server-02,127.0.0.1,Darwin,23.3.0,4,2026-04-10
```

**JSON Format:**
```json
[
  {
    "hostname": "web-server-01",
    "ip_address": "127.0.0.1",
    "os_name": "Linux",
    "kernel": "5.15.0-91-generic",
    "cpu_count": "8",
    "last_update": "2026-04-10"
  }
]
```

## 🏗️ Project Structure

linux-fleet-manager/
├── .github/
│   └── workflows/
│       └── ci.yml                    # GitHub Actions CI/CD pipeline
├── scripts/
│   ├── inventory/
│   │   └── server-inventory.sh       # ✅ Server inventory collection
│   ├── health-check/                 # 🚧 Coming soon
│   ├── user-management/              # 🚧 Coming soon
│   ├── patch-management/             # 🚧 Coming soon
│   ├── backup/                       # 🚧 Coming soon
│   ├── monitoring/                   # 🚧 Coming soon
│   ├── orchestration/                # 🚧 Coming soon
│   └── compliance/                   # 🚧 Coming soon
├── lib/
│   ├── common.sh                     # Shared utility functions
│   └── logger.sh                     # Advanced logging system
├── config/
│   ├── servers.ini.example           # Server inventory template
│   └── variables.env.example         # Environment configuration
├── docs/
│   └── installation.md               # Installation guide
├── tests/                            # Test suite (future)
├── .editorconfig                     # Code style configuration
├── .shellcheckrc                     # ShellCheck linting rules
├── .gitignore                        # Git ignore patterns
├── CHANGELOG.md                      # Version history
├── CONTRIBUTING.md                   # Contribution guidelines
├── LICENSE                           # MIT License
└── README.md                         # This file

## 🔧 CI/CD Pipeline

### Automated Testing

Every commit is automatically tested via GitHub Actions:

✅ **ShellCheck Validation** - Static analysis for Bash scripts  
✅ **Ubuntu Testing** - Functional tests on Ubuntu latest  
✅ **macOS Testing** - Cross-platform compatibility (Bash 3.x)  
✅ **Windows Testing** - Git Bash compatibility  
✅ **Structure Verification** - Project integrity checks  

### Workflow Features

- **Multi-platform testing** (Ubuntu, macOS, Windows)
- **Code quality enforcement** (ShellCheck with zero warnings)
- **Automated artifact generation** (test reports)
- **Pull request validation**
- **Continuous deployment ready**

View the latest build status: [GitHub Actions](https://github.com/Liquenson/linux-fleet-manager/actions)

## 📚 Documentation

- [Installation Guide](docs/installation.md) - Complete setup instructions
- [CHANGELOG](CHANGELOG.md) - Version history and release notes
- [CONTRIBUTING](CONTRIBUTING.md) - How to contribute to the project

## 🛠️ Development

### Code Quality Standards

```bash
# Run ShellCheck locally
shellcheck scripts/**/*.sh
shellcheck lib/*.sh

# Follow code style
# - 4 spaces indentation
# - LF line endings
# - UTF-8 encoding
# - See .editorconfig for details
```

### Running Tests Locally

```bash
# Test help functionality
./scripts/inventory/server-inventory.sh --help

# Test version display
./scripts/inventory/server-inventory.sh --version

# Test CSV generation
./scripts/inventory/server-inventory.sh --format csv
cat reports/server-inventory_*.csv

# Test JSON generation
./scripts/inventory/server-inventory.sh --format json
cat reports/server-inventory_*.json
```

### Contributing

Contributions are welcome! Please read [CONTRIBUTING.md](CONTRIBUTING.md) for:
- Code style guidelines
- Commit message conventions (Conventional Commits)
- Pull request process
- Testing requirements

## 📖 Use Cases

### IT Operations
- **Asset Management** - Automated CMDB updates
- **Compliance Reporting** - Scheduled inventory reports
- **Capacity Planning** - Track resource usage trends
- **Audit Trails** - Historical server information

### DevOps Teams
- **Infrastructure Discovery** - Automated server cataloging
- **Configuration Baselines** - Track server configurations
- **Deployment Verification** - Pre/post-deployment checks
- **Monitoring Integration** - Feed data to Grafana/Prometheus

### Security Operations
- **Vulnerability Assessment** - Track OS versions and patches
- **Compliance Auditing** - Verify security configurations
- **Incident Response** - Rapid information gathering
- **Access Control** - Track system configurations

## 🌟 Roadmap

### v1.0.0 (Current)
- ✅ Server inventory collection (CSV/JSON)
- ✅ Cross-platform support (Linux/macOS/Windows)
- ✅ CI/CD with GitHub Actions
- ✅ Shared library system
- ✅ Comprehensive documentation

### v1.1.0 (Planned)
- 🚧 Health check automation
- 🚧 User management scripts
- 🚧 Security patch deployment
- 🚧 Backup verification
- 🚧 Enhanced reporting (HTML/PDF)

### v2.0.0 (Future)
- 🔮 Real-time monitoring dashboard
- 🔮 Ansible integration
- 🔮 Kubernetes cluster support
- 🔮 Cloud provider APIs (AWS/Azure/GCP)
- 🔮 RESTful API

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👨‍💻 Author

**Liquenson Ruben Alexis**  
*DevOps Engineer || Cloud & Linux Administrator || AWS || Kubernetes* · 
Gran Canaria, España

- 📧 Email: liquenson.cloud@gmail.com
- 💼 LinkedIn: [linkedin.com/in/liquenson-ruben](https://www.linkedin.com/in/liquenson-ruben-490961269/)
- 🐙 GitHub: [@Liquenson](https://github.com/Liquenson)
- 📍 Location: Las Palmas de Gran Canaria, Spain

## 🙏 Acknowledgments

This project demonstrates enterprise-grade DevOps practices including:
- Clean code architecture with shared libraries
- Comprehensive CI/CD automation
- Cross-platform compatibility
- Professional documentation standards
- Industry-standard tooling (ShellCheck, EditorConfig)

Built with experience from real-world infrastructure automation challenges.

---

## 🔗 Related Projects

- [aws-terraform-devops-lab](https://github.com/Liquenson/aws-terraform-devops-lab) - AWS Infrastructure with Terraform, EKS, and CI/CD

---

⭐ **If this project helps you, please consider giving it a star!**

**Questions?** Open an [issue](https://github.com/Liquenson/linux-fleet-manager/issues) or reach out via [email](mailto:liquenson.cloud@gmail.com).

