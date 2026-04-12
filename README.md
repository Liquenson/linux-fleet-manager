# 🐧 Linux Fleet Manager

> Herramienta de automatización Bash para gestionar infraestructuras Linux a gran escala

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Bash Version](https://img.shields.io/badge/bash-%3E%3D4.0-green.svg)](https://www.gnu.org/software/bash/)
[![CI](https://github.com/Liquenson/linux-fleet-manager/actions/workflows/ci.yml/badge.svg)](https://github.com/Liquenson/linux-fleet-manager/actions/workflows/ci.yml)

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
linux-fleet-manager/
├── scripts/
│   └── inventory/
│       └── server-inventory.sh    # ✅ Script principal
├── lib/
│   ├── common.sh                  # Funciones reutilizables
│   └── logger.sh                  # Sistema de logging
├── config/
│   └── servers.ini.example        # Plantilla de configuración
├── .github/workflows/
│   └── ci.yml                     # Pipeline CI/CD
└── README.md                      # Este archivo

## 🔧 Tecnologías

- **Bash 4.0+** - Scripts shell profesionales
- **GitHub Actions** - CI/CD automatizado
- **ShellCheck** - Validación de código
- **SSH** - Acceso seguro a servidores
- **CSV/JSON** - Formatos de exportación estándar

## 📖 Uso Detallado

```bash
# Ver opciones disponibles
./scripts/inventory/server-inventory.sh --help

# Generar CSV
./scripts/inventory/server-inventory.sh --format csv

# Generar JSON
./scripts/inventory/server-inventory.sh --format json

# Archivo personalizado
./scripts/inventory/server-inventory.sh --output mis-servidores.csv
```

## 🚀 CI/CD Pipeline

Cada commit pasa automáticamente por:

✅ **Validación ShellCheck** - Análisis estático de código  
✅ **Tests en Ubuntu** - Verificación funcional  
✅ **Tests en macOS** - Compatibilidad Bash 3.x  
✅ **Tests en Windows** - Git Bash compatibility  
✅ **Verificación de estructura** - Integridad del proyecto  

[Ver estado del CI/CD →](https://github.com/Liquenson/linux-fleet-manager/actions)

## 📈 Roadmap

### v1.0.0 (Actual)
- ✅ Inventario de servidores (CSV/JSON)
- ✅ CI/CD con GitHub Actions
- ✅ Soporte multiplataforma
- ✅ Documentación completa

### v1.1.0 (Próximo)
- 🚧 Health checks automáticos
- 🚧 Gestión de usuarios en masa
- 🚧 Despliegue de parches
- 🚧 Reportes HTML/PDF

### v2.0.0 (Futuro)
- 🔮 Dashboard web en tiempo real
- 🔮 Integración con Kubernetes
- 🔮 APIs de cloud (AWS/Azure/GCP)

## 👨‍💻 Autor

**Liquenson Ruben Alexis**  
*DevOps Engineer | AWS | Kubernetes | Linux*

- 📧 liquenson.cloud@gmail.com
- 💼 [LinkedIn](https://www.linkedin.com/in/liquenson-ruben-490961269/)
- 🐙 [GitHub](https://github.com/Liquenson)
- 📍 Las Palmas de Gran Canaria, España

## 📄 Licencia

MIT License - Ver [LICENSE](LICENSE) para más detalles.

---

## 🔗 Proyectos Relacionados

- [aws-terraform-devops-lab](https://github.com/Liquenson/aws-terraform-devops-lab) - Infraestructura AWS con Terraform

---

⭐ **¿Te resulta útil? ¡Dale una estrella al proyecto!**

**¿Preguntas?** Abre un [issue](https://github.com/Liquenson/linux-fleet-manager/issues) o contáctame por [email](mailto:liquenson.cloud@gmail.com).

