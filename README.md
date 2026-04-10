# Ì∞ß Linux Fleet Manager

> Enterprise-grade Bash automation toolkit for managing large-scale Linux infrastructure

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Bash Version](https://img.shields.io/badge/bash-%3E%3D4.0-green.svg)](https://www.gnu.org/software/bash/)
[![CI](https://github.com/Liquenson/linux-fleet-manager/actions/workflows/ci.yml/badge.svg)](https://github.com/Liquenson/linux-fleet-manager/actions/workflows/ci.yml)
[![Maintenance](https://img.shields.io/badge/Maintained%3F-yes-green.svg)](https://github.com/Liquenson/linux-fleet-manager/graphs/commit-activity)

## ÌæØ Overview

Linux Fleet Manager is a production-ready Bash automation toolkit designed to streamline the management of large-scale Linux server infrastructures. Built with enterprise best practices, automated testing, and cross-platform compatibility.

### What It Does

Automates critical infrastructure management tasks:
- Ì≥ä **Server Inventory Collection** - Automated asset discovery and reporting
- Ìø• **Health Monitoring** - Parallel health checks across entire fleet
- Ì±• **User Management** - Bulk user provisioning and SSH key distribution
- Ì¥í **Security & Compliance** - Automated patching and compliance auditing
- Ì≤æ **Backup Verification** - Automated backup integrity checks
- Ì≥à **Monitoring Integration** - Centralized log collection and metrics

### Enterprise-Grade Quality

‚úÖ **Multi-Platform Support** - Tested on Ubuntu, macOS, and Windows (Git Bash)  
‚úÖ **CI/CD Pipeline** - Automated testing with GitHub Actions  
‚úÖ **Code Quality** - ShellCheck validated, zero warnings  
‚úÖ **Comprehensive Documentation** - Installation guides, examples, and best practices  
‚úÖ **Shared Libraries** - DRY principles with reusable components  

## ‚ú® Features

### Ì¥ç Server Inventory
- **Multi-format export** (CSV/JSON) for integration with CMDB systems
- **Cross-platform compatible** (Linux, macOS, Windows)
- **Automated data collection** (hostname, OS, kernel, CPU, date)
- **Extensible architecture** for adding custom metrics

### Ìø• Health Monitoring *(Coming Soon)*
- Parallel health checks across entire fleet
- Service availability monitoring
- Resource usage tracking
- Automated alerting

### Ì±• User Management *(Coming Soon)*
- Bulk user provisioning/deprovisioning
- SSH key distribution at scale
- Sudo access management
- Access audit trails

### Ì¥í Security & Compliance *(Coming Soon)*
- Automated security patch deployment
- CVE vulnerability scanning
- Security compliance auditing (CIS, PCI-DSS, SOC2)
- SSH configuration hardening

## Ì∫Ä Quick Start

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

## ÌøóÔ∏è Project Structure
