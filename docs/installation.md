# Installation Guide

## Prerequisites

Before installing Linux Fleet Manager, ensure you have the following on your control server:

### Required Software

- **Bash 4.0+**: Modern Bash shell
- **SSH Client**: OpenSSH or compatible
- **Git**: For cloning the repository

### Recommended Software

- **jq**: JSON processor for parsing JSON output
- **GNU Parallel**: For parallel execution across multiple servers
- **rsync**: For efficient file transfers

## Installation Steps

### 1. Install Dependencies

#### Ubuntu/Debian
```bash
sudo apt-get update
sudo apt-get install -y git jq parallel openssh-client rsync
```

#### CentOS/RHEL
```bash
sudo yum install -y git jq parallel openssh-clients rsync
```

#### macOS
```bash
brew install git jq parallel rsync
```

### 2. Clone the Repository

```bash
git clone https://github.com/Liquenson/linux-fleet-manager.git
cd linux-fleet-manager
```

### 3. Configure Server Inventory

Copy the example inventory file and customize it:

```bash
cp config/servers.ini.example config/servers.ini
vim config/servers.ini
```

Add your servers in the format:
```ini
[web_servers]
web-01 ansible_host=192.168.1.10 ansible_user=admin ansible_port=22
web-02 ansible_host=192.168.1.11 ansible_user=admin ansible_port=22
```

### 4. Configure Environment Variables

Copy the example environment file:

```bash
cp config/variables.env.example config/variables.env
vim config/variables.env
```

Customize the settings according to your environment.

### 5. Set Up SSH Access

#### Generate SSH Key (if you don't have one)

```bash
ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
```

#### Distribute SSH Key to All Servers

```bash
ssh-copy-id admin@192.168.1.10
ssh-copy-id admin@192.168.1.11
# ... repeat for all servers
```

Or use a loop:

```bash
for server in web-01 web-02 app-01; do
    ssh-copy-id admin@${server}
done
```

### 6. Make Scripts Executable

```bash
chmod +x scripts/**/*.sh
```

### 7. Test the Installation

Run a simple inventory check:

```bash
./scripts/inventory/server-inventory.sh --help
```

If you see the help message, the installation is successful!

## Directory Structure

After installation, your directory should look like this:

linux-fleet-manager/
├── README.md
├── LICENSE
├── .gitignore
├── config/
│   ├── servers.ini (your custom file)
│   ├── servers.ini.example
│   ├── variables.env (your custom file)
│   └── variables.env.example
├── scripts/
│   ├── inventory/
│   ├── health-check/
│   ├── patch-management/
│   ├── user-management/
│   ├── backup/
│   ├── monitoring/
│   ├── orchestration/
│   └── compliance/
├── docs/
├── tests/
├── examples/
├── templates/
├── logs/ (created at runtime)
└── reports/ (created at runtime)

## Troubleshooting

### SSH Connection Issues

If you can't connect to servers:

1. Verify SSH key permissions:
```bash
chmod 600 ~/.ssh/id_rsa
chmod 644 ~/.ssh/id_rsa.pub
```

2. Test manual SSH connection:
```bash
ssh -v admin@192.168.1.10
```

3. Check firewall rules on target servers

### Permission Denied Errors

Ensure scripts are executable:

```bash
chmod +x scripts/**/*.sh
```

### Missing Dependencies

Install all required packages as shown in step 1.

## Next Steps

After installation:

1. Read the [Use Cases](use-cases.md) documentation
2. Review the [Architecture](architecture.md) overview
3. Try running your first inventory scan
4. Explore other available scripts

## Support

For issues or questions:

- Email: liquenson.cloud@gmail.com
- GitHub Issues: https://github.com/Liquenson/linux-fleet-manager/issues
- LinkedIn: https://www.linkedin.com/in/liquenson-ruben-490961269/