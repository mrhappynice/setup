Add your app and proxy with nginx

1. **One-time server setup** (fix default, certbot, ACME webroot)
2. **Per-app workflow (recommended, using Certbot + Nginx plugin correctly)**
3. **Alternative: manual SSL template** if you prefer Certbot not to touch configs at all

---

## 1. One-time server setup

### 1.1. Make sure Nginx “default” vhost doesn’t claim real domains

Edit the default site:

```bash
sudo nano /etc/nginx/sites-available/default
```

Make it something generic, like:

```nginx
server {
    listen 80 default_server;
    listen [::]:80 default_server;

    server_name _;

    root /var/www/html;
    index index.html;

    location / {
        try_files $uri $uri/ =404;
    }
}
```

Key idea:
**Do NOT put real domains in `server_name` here.** Use `_` so Certbot won’t think this is the vhost for your real domains.

Reload:

```bash
sudo nginx -t
sudo systemctl reload nginx
```

### 1.2. Install Certbot + plugin (if not done already)

```bash
sudo apt-get update
sudo apt-get install certbot python3-certbot-nginx
```

### 1.3. Create a shared ACME webroot (optional but handy)

```bash
sudo mkdir -p /var/www/certbot
sudo chown -R www-data:www-data /var/www/certbot
```

We’ll reference this in each HTTP server block so Certbot has a consistent place to drop challenges.

---

## 2. Per-app workflow (recommended pattern)

Let’s say you’re adding a new app:

* Domain: `app1.example.com`
* App listens on: `127.0.0.1:4000`

### Step 1 – DNS

In your DNS manager:

* **A record**: `app1` → your server’s public IP

Wait until you can `ping app1.example.com` from somewhere and get your server’s IP.

---

### Step 2 – Create basic HTTP-only Nginx config

Create a new vhost:

```bash
sudo nano /etc/nginx/sites-available/app1.example.com
```

Put this initial HTTP-only config:

```nginx
server {
    listen 80;
    listen [::]:80;

    server_name app1.example.com;

    # For Certbot HTTP-01 challenge:
    location /.well-known/acme-challenge/ {
        root /var/www/certbot;
    }

    # Temporary: you can either proxy to the app or just show 404/placeholder
    location / {
        proxy_pass         http://127.0.0.1:4000;
        proxy_http_version 1.1;
        proxy_set_header   Host               $host;
        proxy_set_header   X-Real-IP          $remote_addr;
        proxy_set_header   X-Forwarded-For    $proxy_add_x_forwarded_for;
        proxy_set_header   X-Forwarded-Proto  $scheme;
        proxy_set_header   Connection         "";
    }
}
```

Enable it:

```bash
sudo ln -s /etc/nginx/sites-available/app1.example.com /etc/nginx/sites-enabled/app1.example.com
sudo nginx -t
sudo systemctl reload nginx
```

At this point:
`http://app1.example.com` should reverse proxy to `127.0.0.1:4000` (no SSL yet).

---

### Step 3 – Run Certbot for that domain

Now that:

* DNS is correct
* Nginx has a vhost with `server_name app1.example.com`

Run:

```bash
sudo certbot --nginx -d app1.example.com
```

Certbot will:

* Use the existing `server { listen 80; server_name app1.example.com; }` block for the challenge
* Add a **new `server` block on 443** into **that same file** (not `default`), and
* Optionally add a redirect HTTP → HTTPS depending on what you choose in the prompt

Your final config will look roughly like:

```nginx
# HTTP
server {
    listen 80;
    listen [::]:80;
    server_name app1.example.com;

    location /.well-known/acme-challenge/ {
        root /var/www/certbot;
    }

    # Or Certbot may convert this to a redirect:
    location / {
        return 301 https://$host$request_uri;
    }
}

# HTTPS
server {
    listen 443 ssl;
    listen [::]:443 ssl;
    server_name app1.example.com;

    ssl_certificate     /etc/letsencrypt/live/app1.example.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/app1.example.com/privkey.pem;
    include /etc/letsencrypt/options-ssl-nginx.conf;
    ssl_dhparam         /etc/letsencrypt/ssl-dhparams.pem;

    location / {
        proxy_pass         http://127.0.0.1:4000;
        proxy_http_version 1.1;
        proxy_set_header   Host               $host;
        proxy_set_header   X-Real-IP          $remote_addr;
        proxy_set_header   X-Forwarded-For    $proxy_add_x_forwarded_for;
        proxy_set_header   X-Forwarded-Proto  $scheme;
        proxy_set_header   Connection         "";
    }
}
```

Certbot may slightly rearrange things, but that’s the gist.

---

### Step 4 – Test and clean up

Always:

```bash
sudo nginx -t
sudo systemctl reload nginx
```

Then verify:

* `http://app1.example.com` redirects to HTTPS (if you chose redirect)
* `https://app1.example.com` shows your app (proxied to 4000)

---

### Step 5 – Renewal

Certbot sets up automatic renewal. To test:

```bash
sudo certbot renew --dry-run
```

If that passes, you’re good.
For every new app, **repeat steps 1–4** with the new domain + port.

---

## 3. Alternative workflow: manual SSL template (Certbot doesn’t edit Nginx)

If you prefer **full control over Nginx configs** and don’t want Certbot adding blocks, use `certonly` + a template.

### 3.1. For each new domain

1. Create a minimal HTTP vhost:

```nginx
server {
    listen 80;
    listen [::]:80;
    server_name app2.example.com;

    location /.well-known/acme-challenge/ {
        root /var/www/certbot;
    }

    location / {
        return 404;  # temporary until SSL config is done
    }
}
```

2. Enable & reload:

```bash
sudo ln -s /etc/nginx/sites-available/app2.example.com /etc/nginx/sites-enabled/app2.example.com
sudo nginx -t
sudo systemctl reload nginx
```

3. Get cert **without installing**:

```bash
sudo certbot certonly --webroot -w /var/www/certbot -d app2.example.com
```

Now you have certs at:

* `/etc/letsencrypt/live/app2.example.com/fullchain.pem`
* `/etc/letsencrypt/live/app2.example.com/privkey.pem`

4. Replace that config with your full template:

```nginx
# HTTP
server {
    listen 80;
    listen [::]:80;
    server_name app2.example.com;

    location /.well-known/acme-challenge/ {
        root /var/www/certbot;
    }

    location / {
        return 301 https://$host$request_uri;
    }
}

# HTTPS
server {
    listen 443 ssl;
    listen [::]:443 ssl;
    server_name app2.example.com;

    ssl_certificate     /etc/letsencrypt/live/app2.example.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/app2.example.com/privkey.pem;
    include /etc/letsencrypt/options-ssl-nginx.conf;
    ssl_dhparam         /etc/letsencrypt/ssl-dhparams.pem;

    location / {
        proxy_pass         http://127.0.0.1:PORT_FOR_THIS_APP;
        proxy_http_version 1.1;
        proxy_set_header   Host               $host;
        proxy_set_header   X-Real-IP          $remote_addr;
        proxy_set_header   X-Forwarded-For    $proxy_add_x_forwarded_for;
        proxy_set_header   X-Forwarded-Proto  $scheme;
        proxy_set_header   Connection         "";
    }
}
```

5. Test & reload:

```bash
sudo nginx -t
sudo systemctl reload nginx
```

Renewal is still automatic:

```bash
sudo certbot renew --dry-run
```

---

## TL;DR “recipe” you can reuse

For **every new service**:

1. Add DNS A record for `sub.domain.com` → server IP.
2. Ensure app is listening on `127.0.0.1:<PORT>`.
3. Create `/etc/nginx/sites-available/sub.domain.com` with:

   * `listen 80`
   * `server_name sub.domain.com`
   * `location /.well-known/acme-challenge` → `/var/www/certbot`
   * `location /` proxying to `<PORT>`
4. Enable & reload Nginx.
5. Run `sudo certbot --nginx -d sub.domain.com`.
6. Verify HTTP→HTTPS redirect and 443 proxy.
7. Repeat for next app with new domain + new port.

If you want, you can paste one of your future configs (for a new app) and I’ll turn it into a reusable template snippet you can just search/replace domain + port in.
