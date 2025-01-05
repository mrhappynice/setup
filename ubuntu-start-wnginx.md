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
  sudo apt install nginx
  sudo systemctl status nginx
  sudo nano /etc/nginx/sites-available/da_app
  ```
  /etc/nginx/sites/available/gradio file contents:
  ```bash
  server { 
      listen 80; 
      server_name ip_address_here; 
  
      location / {
          root /home/da_site;
          index index.html;
      }
  
      location /api/ { 
          proxy_pass http://127.0.0.1:11434; 
	        proxy_http_version 1.1; 
          proxy_set_header Upgrade $http_upgrade; 
	        proxy_set_header Connection "upgrade"; 
	        proxy_set_header Host $host; 
          proxy_cache_bypass $http_upgrade; 
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


