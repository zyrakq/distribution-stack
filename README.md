# 🚀 Distribution Stack

A comprehensive Docker stack for running Docker Distribution (Docker Registry) with certificate management solutions.

A lightweight Docker Registry implementation. Perfect for hosting private Docker images with Docker support.

## 🧩 Components

### 🔐 SSL Automation

#### [🔒 Let's Encrypt Manager](src/ssl-automation/letsencrypt-manager)

Automatic SSL certificate management from Let's Encrypt for production deployments. Provides seamless HTTPS integration for Docker containers using nginx-proxy and acme-companion.
[Learn more about Let's Encrypt Manager configuration](src/ssl-automation/letsencrypt-manager/README.md).

#### [🏠 Step CA Manager](src/ssl-automation/step-ca-manager)

Local domain stack with trusted self-signed certificates for virtual network deployments. Includes private CA management and local DNS resolution for development environments.
[Learn more about Step CA Manager configuration](src/ssl-automation/step-ca-manager/README.md).

## 🌐 Services

### 🐳 Docker Distribution

**Location:** [`src/distribution/`](src/distribution/)

## 🎯 Use Cases

- **🌐 Production Deployment**: Use Docker Distribution + Let's Encrypt Manager for public-facing Docker registries
- **🏠 Internal Networks**: Use Docker Distribution + Step CA Manager for private/development environments
- **🔧 Development**: Use Docker Distribution standalone for local development

## 🚀 Quick Start

Each component has its own README with detailed setup instructions. Choose the certificate management solution that fits your deployment scenario.

## 📄 License

This project is dual-licensed under:

- [Apache License 2.0](LICENSE-APACHE)
- [MIT License](LICENSE-MIT)
