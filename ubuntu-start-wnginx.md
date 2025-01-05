- Update apt:
  ```bash
  sudo apt update
  ```

- Download Ollama:
  ```bash
  curl -fsSL https://ollama.com/install.sh | sh
  ```
  - pull your fav models

- Setup Nginx:
  ```bash
  sudo apt update
  sudo apt install nginx
  sudo ufw allow 'Nginx HTTP'
  sudo ufw status
  sudo systemctl status nginx
  sudo nano /etc/nginx/sites-available/da_app
  ```
  /etc/nginx/sites/available/gradio file contents:
  ```bash
  server {
    listen 80;
    server_name your_domain.com(or ip address);

    location / {
        proxy_pass http://127.0.0.1:your_app_port;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
  }
  ```
  finish:
  ```bash
  sudo ln -s /etc/nginx/sites-available/da_app /etc/nginx/sites-enabled/
  sudo nginx -t
  sudo systemctl reload nginx
  ```


