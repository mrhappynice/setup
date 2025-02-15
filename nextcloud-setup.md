Below is one tested “simpler” method that uses the Nextcloud snap package (which bundles everything you need) and then puts an Nginx reverse proxy in front of it so that your Nextcloud instance is available at https://nextcloud.example.com.

Follow these steps on an Ubuntu 22.04 server:

---

### 1. Install the Nextcloud Snap Package

Run the following command to install Nextcloud from snap:

```bash
sudo snap install nextcloud
```

By default, the snap’s built‑in Apache will listen on ports 80/443. Since you want to use Nginx as a reverse proxy, you need to change these ports.

---

### 2. Change Nextcloud Snap’s Default Ports

Set the snap to use alternate ports so Nginx can bind to 80/443. For example, configure HTTP on port 81 and HTTPS on port 444:

```bash
sudo snap set nextcloud nextcloud.http.port=81
sudo snap set nextcloud nextcloud.https.port=444
```

You can verify the settings with:

```bash
sudo snap get nextcloud
```

---

### 3. Update Nextcloud’s Trusted Domains

Nextcloud by default only accepts connections from “localhost.” Add your subdomain (replace with your actual domain) so it knows to trust requests coming from there:

```bash
sudo nextcloud.occ config:system:set trusted_domains 1 --value=nextcloud.example.com
```

---

### 4. Set Up an Nginx Reverse Proxy

Create an Nginx server block so that requests to nextcloud.example.com are forwarded to the Nextcloud snap (now on ports 81/444).

First, create a new file at `/etc/nginx/sites-available/nextcloud`:

```bash
sudo nano /etc/nginx/sites-available/nextcloud
```

Paste in the following configuration (adjust paths for your SSL certificate if you already have one; see Step 5 for Let’s Encrypt setup):

```nginx
# Redirect HTTP to HTTPS
server {
    listen 80;
    server_name nextcloud.example.com;
    return 301 https://$server_name$request_uri;
}

# HTTPS server block
server {
    listen 443 ssl http2;
    server_name nextcloud.example.com;

    # Path to your SSL certificate files (see Step 5 for obtaining certificates)
    ssl_certificate /etc/letsencrypt/live/nextcloud.example.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/nextcloud.example.com/privkey.pem;
    include /etc/letsencrypt/options-ssl-nginx.conf;
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem;

    # Reverse proxy settings – forward requests to the Nextcloud snap’s HTTPS port (444)
    location / {
        proxy_pass https://127.0.0.1:444;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto https;
        proxy_buffering off;
    }
}
```

Save the file and exit your editor.

Now enable the site and test Nginx configuration:

```bash
sudo ln -s /etc/nginx/sites-available/nextcloud /etc/nginx/sites-enabled/
sudo nginx -t && sudo systemctl reload nginx
```

Make sure that DNS for **nextcloud.example.com** points to your server’s public IP.

---

### 5. (Optional) Obtain an SSL Certificate with Certbot

If you don’t already have an SSL certificate for your subdomain, you can use Certbot to get one from Let’s Encrypt.

First, install Certbot via snap:

```bash
sudo snap install core && sudo snap refresh core
sudo apt remove certbot
sudo snap install --classic certbot
```

Then run Certbot with the Nginx plugin:

```bash
sudo certbot --nginx -d nextcloud.example.com
```

Follow the interactive prompts (provide your email, agree to the terms, etc.). Certbot will update your Nginx config to include the correct certificate paths.

After the process completes, reload Nginx if necessary:

```bash
sudo systemctl reload nginx
```

---

### 6. Finalize and Access Your Nextcloud Instance

Now, open your web browser and navigate to:

```
https://nextcloud.example.com
```

You should see the Nextcloud setup screen. Complete the on‑screen steps (set up an admin account, provide database details if needed, etc.). Since the snap package comes preconfigured, you might only need to finish the web‑based setup.

---

### Summary

1. **Install Nextcloud snap and change its ports:**
   - `sudo snap install nextcloud`
   - `sudo snap set nextcloud nextcloud.http.port=81`
   - `sudo snap set nextcloud nextcloud.https.port=444`
2. **Add your subdomain as a trusted domain:**
   - `sudo nextcloud.occ config:system:set trusted_domains 1 --value=nextcloud.example.com`
3. **Configure Nginx as a reverse proxy** (create a site config that proxies HTTPS to `127.0.0.1:444`).
4. **Obtain and configure SSL certificates** (using Certbot with the Nginx plugin).
5. **Access your instance at** `https://nextcloud.example.com` and finish the web‑based setup.

