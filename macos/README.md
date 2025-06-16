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



### 5. Install NextFlow
https://www.nextflow.io/docs/latest/install.html

need to install Java:

```
$ java
The operation couldn’t be completed. Unable to locate a Java Runtime.
Please visit http://www.java.com for information on installing Java.
```

This error on macOS usually means that a **Java placeholder** is installed — but no actual **Java Runtime Environment (JRE)** or **Java Development Kit (JDK)** is present.

install by brew `brew install openjdk`

install conda by miniforge, then mamba, and then creata a env for nextflow, that should work for both linux (cloud -init on Azure) and Mac

TODO: fix the version 



https://github.com/conda-forge/miniforge/releases/download/25.3.0-3/Miniforge3-MacOSX-arm64.sh

```bash
# Replace architecture if needed: aarch64, x86_64, etc.
ARCH=arm64  # or x86_64
OS=MacOSX   # or Linux
#curl -L -o miniforge.sh https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-${OS}-${ARCH}.sh
curl -L -o miniforge.sh https://github.com/conda-forge/miniforge/releases/download/25.3.0-3//Miniforge3-${OS}-${ARCH}.sh
bash miniforge.sh -b -p $HOME/miniforge
```

```
eval "$($HOME/miniforge/bin/conda shell.bash hook)"
conda init
```

```
conda install -n base -c conda-forge mamba=2.1.1 --yes
mamba create -n nextflow_env -c bioconda -c conda-forge nextflow=25.04.3 openjdk=21 --yes
conda activate nextflow_env

```

```
(nextflow_env) nnfcb-l1146:GitRepo zhlia$ conda --version
conda 25.5.1
(nextflow_env) nnfcb-l1146:GitRepo zhlia$ mamba --version
2.1.1
(nextflow_env) nnfcb-l1146:GitRepo zhlia$ nextflow -version

      N E X T F L O W
      version 25.04.3 build 5949
      created 02-06-2025 20:56 UTC (22:56 CEST)
      cite doi:10.1038/nbt.3820
      http://nextflow.io


```

```
# there were something wrong with my pyenv python version setup, after logging into the nextflow_env
source ~/.bashrc
source ~/.bash_profile
```

a$ echo $PATH

/opt/homebrew/opt/openjdk/bin:/Users/zhlia/.pyenv/shims:/opt/homebrew/bin:/opt/homebrew/sbin:/opt/homebrew/Cellar/pyenv-virtualenv/1.2.4/shims:/Users/zhlia/miniforge/envs/nextflow_env/bin:/Users/zhlia/miniforge/condabin:/opt/homebrew/opt/openjdk/bin:/usr/local/bin:/System/Cryptexes/App/usr/bin:/usr/bin:/bin:/usr/sbin:/sbin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/local/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/appleinternal/bin:/Users/zhlia/.orbstack/bin:/Users/zhlia/.orbstack/bin