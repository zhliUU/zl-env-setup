# zl-env-setup

Personal macOS development environment setup for:

- 🌐 Web Development
- 🧬 Nextflow bioinformatics pipeline development
- 🧪 Local testing & 🚀 server deployment

## 🔧 Tools & Stack

- [Homebrew](https://brew.sh/)
- [OrbStack for Mac](https://orbstack.dev/) (or Docker Desktop)
<!-- - Node.js, Python, Git, NGINX
- VS Code with custom extensions
- Nextflow & related tools -->



# Install Homebrew packages
brew bundle

# Run setup script (optional)
./scripts/setup.sh

# 🛠️ macOS NGINX Setup Guide (Homebrew vs Docker)

This guide shows how to replicate a Linux-style NGINX config on macOS using:

- 🍺 Homebrew-installed NGINX
- 🐳 Dockerized NGINX

---

## 📦 Option 1: NGINX via Homebrew

### 🔧 1. Install NGINX

```bash
brew install nginx
brew services start nginx
sudo mkdir -p /opt/homebrew/etc/nginx/servers
```


```bash
==> nginx
Docroot is: /opt/homebrew/var/www

The default port has been set in /opt/homebrew/etc/nginx/nginx.conf to 8080 so that
nginx can run without sudo.

nginx will load all files in /opt/homebrew/etc/nginx/servers/.

To start nginx now and restart at login:
  brew services start nginx
Or, if you don't want/need a background service you can just run:
  /opt/homebrew/opt/nginx/bin/nginx -g daemon\ off\;
```

### 2. Create Custom NGINX Config

```bash
sudo mkdir -p /opt/homebrew/etc/nginx/servers

sudo tee /opt/homebrew/etc/nginx/servers/aledb.conf > /dev/null <<EOF
server {
    listen 80;
    server_name aledb.org www.aledb.org;

    location / {
        proxy_pass http://127.0.0.1:8000;
    }

    location /aledata {
        alias /opt/homebrew/var/www/ale_analytics_data;
        autoindex on;
        satisfy any;
    }

    location /static {
        alias /opt/homebrew/var/www/aledb/static;
    }
}
EOF
```

### 3. Include Config in nginx.conf
```bash
sudo sed -i '' '/http {/a\
    include servers/*.conf;
' /opt/homebrew/etc/nginx/nginx.conf
```
(This inserts the line only if not already present. Alternatively, edit manually.)

### 4. Restart NGINX
```bash
brew services restart nginx
```

## Option 2: NGINX via Docker
TODO: improve after able to run aledb

