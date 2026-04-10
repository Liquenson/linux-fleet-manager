# 🐧 Linux Fleet Manager

> Herramienta de automatización Bash para gestionar infraestructuras Linux a gran escala

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Bash Version](https://img.shields.io/badge/bash-%3E%3D4.0-green.svg)](https://www.gnu.org/software/bash/)
[![CI](https://github.com/Liquenson/linux-fleet-manager/actions/workflows/ci.yml/badge.svg)](https://github.com/Liquenson/linux-fleet-manager/actions/workflows/ci.yml)

## 🎯 ¿Qué es esto?

**Linux Fleet Manager** automatiza la gestión de cientos de servidores Linux con scripts Bash listos para producción.

En lugar de conectarte manualmente a cada servidor, este toolkit recopila información de toda tu infraestructura automáticamente.

## ⚡ Inicio Rápido

```bash
# Clonar el repositorio
git clone https://github.com/Liquenson/linux-fleet-manager.git
cd linux-fleet-manager

# Generar inventario de servidores
./scripts/inventory/server-inventory.sh --format csv

# Ver el reporte
cat reports/server-inventory_*.csv
```

**Resultado:**
```csv
Hostname,IP Address,OS Name,Kernel,CPU Count,Last Update
web-server-01,127.0.0.1,Linux,5.15.0-91-generic,8,2026-04-10
app-server-02,192.168.1.50,Linux,5.15.0-91-generic,16,2026-04-10
db-server-03,192.168.1.51,Linux,5.15.0-91-generic,32,2026-04-10
```

## ✨ Características Principales

### ✅ Inventario Automatizado
- **Recopila información** de todos tus servidores en segundos
- **Exporta en CSV/JSON** para Excel, bases de datos, o dashboards
- **Compatible** con Linux, macOS y Windows (Git Bash)

### ✅ Calidad Enterprise
- **CI/CD automático** con GitHub Actions
- **Tests en 3 plataformas** (Ubuntu, macOS, Windows)
- **Código validado** con ShellCheck (cero warnings)
- **Documentación completa** con ejemplos

### 🚧 Próximamente
- Health check de servicios en paralelo
- Gestión masiva de usuarios y SSH keys
- Despliegue automático de parches de seguridad
- Verificación de backups

## 📊 Casos de Uso Real

### Para Empresas IT
```bash
# Auditoría de 500 servidores en 2 minutos
./scripts/inventory/server-inventory.sh --format csv

# Importar a Excel para reportes
# Integrar con CMDB/ITSM
# Generar reportes de compliance
```

### Para DevOps Teams
```bash
# Verificar versiones de OS antes de deploy
# Documentar estado actual de infraestructura
# Detectar servidores con recursos limitados
# Alimentar dashboards de Grafana/Prometheus
```

### Para Equipos de Seguridad
```bash
# Auditar versiones de kernel
# Detectar servidores sin parchear
# Verificar configuraciones de seguridad
# Generar reportes de compliance (ISO, PCI-DSS)
```

## 🏗️ Estructura del Proyecto