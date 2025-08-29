
---

# 🚀 Nginx Setup Guide with Domain + Subdomain

## 1. Install Nginx

```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Install Nginx
sudo apt install nginx -y

# Start and enable Nginx
sudo systemctl start nginx
sudo systemctl enable nginx
```

Check:

```bash
nginx -v
systemctl status nginx
```

---

## 2. Firewall (if enabled)

```bash
sudo ufw allow 'Nginx Full'
```

---

## 3. Set Up Your Domain

Point your domain’s **DNS records** to your server’s IP:

* `A` record → `@` → server IP (for `example.com`)
* `A` record → `www` → server IP
* (Optional) `A` record → `sub` → server IP (for `sub.example.com`)

---

## 4. Create Website Directory

```bash
sudo mkdir -p /var/www/example.com/html
sudo chown -R $USER:$USER /var/www/example.com/html
sudo chmod -R 755 /var/www/example.com

# Sample index file
echo "<h1>Welcome to example.com</h1>" > /var/www/example.com/html/index.html
```

---

## 5. Configure Domain in Nginx

Create a new server block:

```bash
sudo nano /etc/nginx/sites-available/example.com
```

Paste:

```nginx
server {
    listen 80;
    listen [::]:80;

    server_name example.com www.example.com;

    root /var/www/example.com/html;
    index index.html index.htm;

    location / {
        try_files $uri $uri/ =404;
    }
}
```

Enable it:

```bash
sudo ln -s /etc/nginx/sites-available/example.com /etc/nginx/sites-enabled/
```

Test config:

```bash
sudo nginx -t
```

Reload:

```bash
sudo systemctl reload nginx
```

---

## 6. (Optional) Configure Subdomain for Port 5959

If you have a service running on **port 5959** (e.g., Node.js, Python app), create another server block.

```bash
sudo nano /etc/nginx/sites-available/sub.example.com
```

Paste:

```nginx
server {
    listen 80;
    listen [::]:80;

    server_name sub.example.com;

    location / {
        proxy_pass http://127.0.0.1:5959;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}
```

Enable it:

```bash
sudo ln -s /etc/nginx/sites-available/sub.example.com /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx
```

---

## 7. Enable HTTPS with Let’s Encrypt (Recommended)

Install Certbot:

```bash
sudo apt install certbot python3-certbot-nginx -y
```

Run:

```bash
sudo certbot --nginx -d example.com -d www.example.com -d sub.example.com
```

Auto-renew test:

```bash
sudo certbot renew --dry-run
```

---

## ✅ Final Result

* `http(s)://example.com` → Static website (`/var/www/example.com/html`)
* `http(s)://sub.example.com` → Proxied service running on **port 5959**

---

Would you like me to also include **best-practice hardening** (e.g., gzip, caching, security headers) in the Nginx config, or keep it minimal?
