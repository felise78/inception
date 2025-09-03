# Inception

A Docker-based infrastructure setting up a complete web environment with NGINX, WordPress, and MariaDB.

## Prerequisites

- Docker & Docker Compose
- Make

## Setup Instructions

### 1. VM Setup
Run both scripts inside the VM (**Debian GUI distro**):
```bash
.setupVM/install.sh
.setupVM/add_user.sh
```

### 2. Environment Configuration

#### Configure Environment Variables
```bash
# Copy the environment template
cp srcs/.env.example srcs/.env
```

Then edit `srcs/.env` with your own values:
- `DB_HOST`: Database host (usually `mariadb`)
- `DB_USER`: Database username
- `DB_NAME`: Database name
- `WP_ADMIN_EMAIL`: WordPress admin email
- `WP_ADMIN_USER`: WordPress admin username  
- `WP_USER_EMAIL`: WordPress user email
- `WP_USER`: WordPress username
- `WP_USER_ROLE`: WordPress user role (e.g., `author`, `editor`)

#### Create Secret Files
Create the following password files in the `secrets/` folder:

```bash
echo "your_database_password" > secrets/db_password.txt
echo "your_database_root_password" > secrets/db_root_password.txt  
echo "your_wordpress_admin_password" > secrets/wp_admin_password.txt
echo "your_wordpress_user_password" > secrets/wp_password.txt
```

## Running the Project

```bash
# Build and start all services
make
```