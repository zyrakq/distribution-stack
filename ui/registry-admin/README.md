# 🎛️ Registry Admin

SSO and web interface for Docker Distribution Registry. Provides OIDC authentication, user management, and image catalog browsing.

## 📦 Prerequisites

This project requires a running Docker Distribution Registry from [distribution-stack](https://github.com/zyrakq/distribution-stack).

**Important**: Distribution must use version **2.8.3** due to token issuance compatibility issues with newer versions.

## 🚀 Deployment Order

1. **First**: Deploy distribution from [distribution-stack](https://github.com/zyrakq/distribution-stack)
2. **Second**: Deploy registry-admin (this project)

### Startup Behavior

- **OIDC mode**: ~20 seconds startup time for certificate generation and trust establishment
  - Registry-admin generates OIDC certificates for distribution
  - Distribution waits for certificates and may restart during this period
  - Registry-admin adds distribution HTTPS certificate to trusted store
- **Htpasswd mode**: Faster startup, requires htpasswd file created by distribution and accessible for user management

## 🔗 Integration

Registry-admin integrates with distribution via:

- **OIDC Token Service**: Acts as authentication provider for distribution
- **Webhook Notifications**: Receives events from distribution's `imagelist-conf` extension for image synchronization
- **Certificate Management**: Automatic generation and trust setup for OIDC authentication

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

- `COMPOSE_PROJECT_NAME`: Project name (default: registry-admin)
- `IMAGE`: Docker image (default: localhost/registry-admin:latest)
- `RA_CONFIG_FILE`: Config file path (default: /app/config/config.yml)
- `APP_UID`: Application user ID (default: 1001)
- `RA_DEBUG`: Debug mode (default: false)
- `RA_REGISTRY_HOSTNAME`: Registry hostname (default: 0.0.0.0)
- `RA_REGISTRY_HOST`: Distribution registry URL (e.g., <https://dist.example.com>)
- `RA_REGISTRY_PORT`: Distribution registry port (default: 443)
- `RA_AUTH_TOKEN_SECRET`: Secret for token generation (generate with `openssl rand -hex 64`)
- `RA_STORE_DB_TYPE`: Database type (default: embed)
- `RA_STORE_ADMIN_PASSWORD`: Admin password for web interface
- `RA_STORE_EMBED_DB_PATH`: Embedded database path (default: /app/data/store.db)

### Let's Encrypt Configuration

- `VIRTUAL_PORT`: Port for nginx-proxy (default: 80)
- `VIRTUAL_HOST`: Domain for registry-admin web interface
- `LETSENCRYPT_HOST`: Domain for SSL certificate
- `LETSENCRYPT_EMAIL`: Email for certificate registration

### Step CA Configuration

- `VIRTUAL_PORT`: Port for nginx-proxy (default: 80)
- `VIRTUAL_HOST`: Local domain for registry-admin
- `LETSENCRYPT_HOST`: Domain for SSL certificate
- `LETSENCRYPT_EMAIL`: Email for certificate registration

### Htpasswd Authentication

- `RA_REGISTRY_AUTH_TYPE`: Authentication type (basic)
- `RA_REGISTRY_HTPASSWD`: Path to htpasswd file (default: /app/access/.htpasswd)
- `RA_REGISTRY_LOGIN`: Username for distribution registry
- `RA_REGISTRY_PASSWORD`: Password for distribution registry

**Note**: Htpasswd file must be created by distribution and accessible for registry-admin to manage users.

### OIDC Authentication

- `RA_REGISTRY_AUTH_TYPE`: Authentication type (token)
- `RA_REGISTRY_ISSUER`: OIDC issuer identifier
- `RA_REGISTRY_SERVICE`: Service identifier for tokens
- `RA_REGISTRY_CERTS_CERT_PATH`: Certificate path
- `RA_REGISTRY_CERTS_KEY_PATH`: Private key path
- `RA_REGISTRY_CERTS_PUBLIC_KEY_PATH`: Public key path
- `RA_REGISTRY_CERTS_CA_ROOT_PATH`: CA root certificate path
- `RA_REGISTRY_CERTS_IP`: IP address for certificate
- `RA_REGISTRY_CERTS_FQDN`: FQDN for certificate
- `RA_REGISTRY_HTTPS_INSECURE`: Skip HTTPS verification (default: false)
- `RA_REGISTRY_CERTS_CERT_HTTPS`: HTTPS certificate path
- `DISTRIBUTION_CERTS`: External volume name for certificates

### Step CA Trust

- `STEP_CA_TRUST`: Enable Step CA trust (default: true)
- `STEP_CA_TRUST_RESTART`: Restart on certificate update (default: true)
- `REQUESTS_CA_BUNDLE`: CA bundle path for Python requests
- `SSL_CERT_FILE`: SSL certificate file path

## 🌐 Accessing Registry Admin

After deployment, access the web interface at:

- **Forwarding mode**: <http://localhost> (or configured port)
- **Let's Encrypt**: <https://your-domain.com>
- **Step CA**: <https://your-local-domain>

Login with the admin password configured in `RA_STORE_ADMIN_PASSWORD`.

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

**Startup Issues:**

- **OIDC**: Wait ~20 seconds for certificate generation
- **Htpasswd**: Verify htpasswd file exists and is accessible from distribution
- **Distribution restarts**: Normal during OIDC setup, should stabilize after ~20 seconds

**Integration Issues:**

- **Images not syncing**: Check webhook configuration in distribution (`imagelist-conf` extension)
- **OIDC authentication fails**: Verify certificate paths and issuer configuration
- **Certificate trust issues**: Check `STEP_CA_TRUST` settings for Step CA deployments

**SSL Issues:**

- **Let's Encrypt**: Verify domain DNS and letsencrypt-manager
- **Step CA**: Check step-ca-manager and virtual network config

## 📝 Notes

- The `build/` directory is automatically generated and should not be edited manually
- Environment variables in generated files use `$VARIABLE_NAME` format for proper interpolation
- Each generated configuration includes a complete `docker-compose.yml` and `.env.example`
- Component files follow standard Docker Compose naming convention for IDE compatibility
