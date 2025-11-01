# 🐳 Docker Distribution Service

A modular Docker Compose configuration system for Docker Distribution (Docker Registry) with support for multiple environments and extensions.

## 🚀 Quick Start

### 1. Build Configurations

Build final Docker Compose configurations using [stackbuilder](https://github.com/zyrakq/stackbuilder):

```bash
sb build
```

This will create all combinations in the `build/` directory based on the [`stackbuilder.toml`](stackbuilder.toml) configuration.

### 2. Choose Your Configuration

Navigate to the desired configuration directory:

```bash
# For development container environment
cd build/devcontainer/base/

# For development with port forwarding
cd build/forwarding/base/

# For production with Let's Encrypt SSL
cd build/letsencrypt/base/

# For production with Step CA SSL
cd build/step-ca/base/

# For development with htpasswd authentication
cd build/forwarding/htpasswd/

# For development with OIDC authentication and notifications
cd build/forwarding/oidc-hub/
```

### 3. Configure Environment

Copy and edit the environment file:

```bash
cp .env.example .env
# Edit .env with your values
```

### 4. Deploy

Start the services:

```bash
docker-compose up -d
```

Access: `http://localhost:5000` (for forwarding mode)

## 📋 Registry Catalog

View available images in the registry:

```bash
# List all repositories
curl http://localhost:5000/v2/_catalog

# List tags for a specific repository
curl http://localhost:5000/v2/<repository>/tags/list
```

## 🔧 Available Configurations

### Environments

- **devcontainer**: Development container environment
- **forwarding**: Development environment with port forwarding (5000)
- **letsencrypt**: Production with Let's Encrypt SSL certificates
- **step-ca**: Production with Step CA SSL certificates

### Extensions

- **htpasswd**: HTTP Basic authentication with username/password
- **oidc**: OIDC/OAuth 2.0 token-based authentication
- **notification**: Event notifications to registry-admin interface

### Extension Combinations

- **htpasswd-hub**: Htpasswd authentication + notifications
- **oidc-hub**: OIDC authentication + notifications

### Generated Combinations

Each environment can be combined with extensions:

- `devcontainer/base` - Development container environment
- `devcontainer/htpasswd` - Development container with htpasswd auth
- `devcontainer/htpasswd-hub` - Development container with htpasswd auth + notifications
- `devcontainer/oidc-hub` - Development container with OIDC auth + notifications
- `forwarding/base` - Development with port forwarding
- `forwarding/htpasswd` - Development with htpasswd auth
- `forwarding/htpasswd-hub` - Development with htpasswd auth + notifications
- `forwarding/oidc-hub` - Development with OIDC auth + notifications
- `letsencrypt/base` - Production with Let's Encrypt SSL
- `letsencrypt/htpasswd` - Production with Let's Encrypt + htpasswd auth
- `letsencrypt/htpasswd-hub` - Production with Let's Encrypt + htpasswd auth + notifications
- `letsencrypt/oidc-hub` - Production with Let's Encrypt + OIDC auth + notifications
- `step-ca/base` - Production with Step CA SSL
- `step-ca/htpasswd` - Production with Step CA + htpasswd auth
- `step-ca/htpasswd-hub` - Production with Step CA + htpasswd auth + notifications
- `step-ca/oidc-hub` - Production with Step CA + OIDC auth + notifications

## 🔧 Environment Variables

### Base Configuration

- `COMPOSE_PROJECT_NAME`: Project name for Docker Compose (default: distribution)

### Let's Encrypt Configuration

- `VIRTUAL_PORT`: Port for nginx-proxy (default: 5000)
- `VIRTUAL_HOST`: Domain for nginx-proxy
- `LETSENCRYPT_HOST`: Domain for SSL certificate
- `LETSENCRYPT_EMAIL`: Email for certificate registration

### Step CA Configuration

- `VIRTUAL_PORT`: Port for nginx-proxy (default: 5000)
- `VIRTUAL_HOST`: Domain for nginx-proxy
- `LETSENCRYPT_HOST`: Domain for SSL certificate
- `LETSENCRYPT_EMAIL`: Email for certificate registration

⚠️ **Important**: When deploying with step-ca on a remote context, switch back to the main context before running `docker login` to ensure proper authentication.

### Htpasswd Configuration

- `REGISTRY_AUTH_HTPASSWD_PATH`: Path to htpasswd file (default: /auth/htpasswd)
- `REGISTRY_AUTH_HTPASSWD_REALM`: Authentication realm (default: basic-realm)
- `DISTRIBUTION_USERNAME`: Username for authentication
- `DISTRIBUTION_PASSWORD_HASH`: Bcrypt password hash

### OIDC Configuration

- `REGISTRY_AUTH_TOKEN_REALM`: Token authentication endpoint URL
- `REGISTRY_AUTH_TOKEN_SERVICE`: Service identifier for tokens
- `REGISTRY_AUTH_TOKEN_ISSUER`: Token issuer identifier
- `REGISTRY_AUTH_TOKEN_ROOTCERTBUNDLE`: Path to root certificate bundle (default: /oidc/certs/cert.crt)
- `DISTRIBUTION_CERTS`: External volume name for certificates

### Notification Configuration

- `REGISTRY_ENDPOINTS_0_URL`: Webhook URL for registry events
- `REGISTRY_NOTIFICATIONS_ENDPOINTS_0_HEADERS_AUTHORIZATION_0`: Authorization header for webhook
- `REGISTRY_ENDPOINTS_0_NAME`: Endpoint name (default: ra-listener)
- `REGISTRY_ENDPOINTS_0_TIMEOUT`: Request timeout (default: 1s)
- `REGISTRY_ENDPOINTS_0_THRESHOLD`: Retry threshold (default: 5)
- `REGISTRY_ENDPOINTS_0_BACKOFF`: Backoff duration (default: 3s)

## 🐳 Using Docker Registry

### Pushing Images

```bash
# Tag your image for the registry
docker tag my-image:latest localhost:5000/my-image:latest

# Push to registry (without authentication - base configurations)
docker push localhost:5000/my-image:latest

# With authentication (htpasswd configurations)
docker login localhost:5000
# Enter username and password when prompted
docker push localhost:5000/my-image:latest
```

### Pulling Images

```bash
# Pull from registry
docker pull localhost:5000/my-image:latest
```

### Registry Management

```bash
# View registry catalog
curl http://localhost:5000/v2/_catalog

# View tags for specific repository
curl http://localhost:5000/v2/my-image/tags/list
```

## 🛠️ Development

### Project Structure

- **`components/`** - Source compose components
  - `base/` - Base configuration
  - `environments/` - Environment-specific configs (devcontainer, forwarding, letsencrypt, step-ca)
  - `extensions/` - Optional extensions
    - `auth/` - Authentication methods (htpasswd, oidc)
    - `notification/` - Event notification system
- **`build/`** - Generated configurations (auto-generated, ready to deploy)
  - `devcontainer/` - Development container builds
  - `forwarding/` - Port forwarding builds
  - `letsencrypt/` - Let's Encrypt SSL builds
  - `step-ca/` - Step CA SSL builds
- **`stackbuilder.toml`** - Build configuration file

### Adding New Environments

1. Create directory in `components/environments/` with `docker-compose.yml` and optional `.env.example` file
2. Update [`stackbuilder.toml`](stackbuilder.toml) to include the new environment
3. Run `sb build` to generate new combinations

### Modifying Existing Components

1. Edit the component files in `components/`
2. Run `sb build` to regenerate configurations
3. The `build/` directory will be completely recreated

## 🌐 Networks

- **Development**: `distribution-network` (internal)
- **Let's Encrypt**: `letsencrypt-network` (external)
- **Step CA**: `step-ca-network` (external)

## 🔒 Security

⚠️ **Production Checklist:**

- Change default API key
- Use strong passwords for authentication
- Configure firewall rules
- Regular security updates

## 🆘 Troubleshooting

**Build Issues:**

- Ensure stackbuilder is installed: <https://github.com/zyrakq/stackbuilder>
- Check component file syntax
- Verify all required files exist

**Image Push/Pull Issues:**

- Check authentication credentials
- Ensure registry is running and accessible
- Review container logs: `docker logs distribution`
- Verify network connectivity and firewall rules

**SSL Issues:**

- **Let's Encrypt**: Verify domain DNS and letsencrypt-manager
- **Step CA**: Check step-ca-manager and virtual network config

## 📝 Notes

- The `build/` directory is automatically generated and should not be edited manually
- Environment variables in generated files use `$VARIABLE_NAME` format for proper interpolation
- Each generated configuration includes a complete `docker-compose.yml` and `.env.example`
- Component files follow standard Docker Compose naming convention for IDE compatibility
