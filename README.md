# 🚀 Distribution Stack

Docker Distribution (Registry) with web interface, SSO, and SSL automation.

## 🧩 Components

### 🐳 [Docker Distribution](app/)

Docker Registry v2.8.3 with modular configuration system supporting multiple authentication methods and environments.

### 🎛️ [Registry Admin](src/clients/registry-admin/)

Web interface and OIDC/SSO provider for Docker Distribution. Provides user management and image catalog browsing.

⚠️ **Access Control Limitations**: Despite advertised support for groups, roles, and permissions, registry-admin currently only provides individual image-level access control. There is no grouping of images, no ownership assignment, and no role-based access management. Access control is limited to granting/restricting individual users to specific already-uploaded images.

### 🔐 SSL Automation

#### [🔒 Let's Encrypt Manager](src/ssl-automation/letsencrypt-manager)

Automatic SSL certificates from Let's Encrypt for production deployments.

#### [🏠 Step CA Manager](src/ssl-automation/step-ca-manager)

Private CA with local DNS for development environments.

## 🚀 Deployment Order

1. **First**: Deploy [distribution](app/)
2. **Second**: Deploy [registry-admin](src/clients/registry-admin/)

⚠️ **Note**: With OIDC, distribution restarts ~20 seconds during initial startup for certificate generation.

## 🎯 Use Cases

- **🌐 Production**: Distribution + Registry Admin + Let's Encrypt
- **🏠 Internal**: Distribution + Registry Admin + Step CA
- **🔧 Development**: Distribution standalone with port forwarding

## 🚀 Quick Start

Each component has its own README with detailed setup instructions. Choose the certificate management solution that fits your deployment scenario.

## 📄 License

This project is dual-licensed under:

- [Apache License 2.0](LICENSE-APACHE)
- [MIT License](LICENSE-MIT)
