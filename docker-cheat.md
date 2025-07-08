Here’s a concise cheat-sheet of the most common Docker commands for working with images, containers, volumes, networks, and general maintenance on the CLI.

---

## 📦 Image Management

| Command                                 | Description                       |
| --------------------------------------- | --------------------------------- |
| `docker pull <image>[:tag]`             | Download an image from a registry |
| `docker build -t <name>[:tag] <path>`   | Build an image from a Dockerfile  |
| `docker images`                         | List local images                 |
| `docker tag <image>[:tag] <repo>:<tag>` | Add a new tag to an image         |
| `docker push <repo>:<tag>`              | Push an image to a registry       |
| `docker rmi <image>[:tag]`              | Remove one or more images         |

```bash
# Example: build and push
docker build -t myapp:1.0 .
docker tag myapp:1.0 registry.example.com/myorg/myapp:1.0
docker push registry.example.com/myorg/myapp:1.0
```

---

## 🐳 Container Operations

| Command                              | Description                              |                       |                             |
| ------------------------------------ | ---------------------------------------- | --------------------- | --------------------------- |
| `docker run [opts] <image> [cmd]`    | Run a new container                      |                       |                             |
| `docker ps` / `docker ps -a`         | List running (`-a` for all) containers   |                       |                             |
| \`docker start                       | stop                                     | restart <container>\` | Control container lifecycle |
| `docker exec -it <container> <cmd>`  | Run a command inside a running container |                       |                             |
| `docker logs [--follow] <container>` | View container logs                      |                       |                             |
| `docker inspect <container>`         | Low-level info on a container            |                       |                             |
| `docker rm <container>`              | Remove one or more containers            |                       |                             |

```bash
# Example: run nginx, detach, map ports and name it
docker run -d --name web -p 80:80 nginx:latest

# Get a shell inside a running container
docker exec -it web /bin/bash
```

---

## 💾 Volumes & Bind Mounts

| Command                                        | Description                 |
| ---------------------------------------------- | --------------------------- |
| `docker volume create <vol>`                   | Create a named volume       |
| `docker volume ls`                             | List volumes                |
| `docker run -v <vol>:/data <image>`            | Mount a named volume        |
| `docker run -v /host/path:/container/path ...` | Bind-mount a host directory |
| `docker volume inspect <vol>`                  | View volume details         |
| `docker volume rm <vol>`                       | Remove one or more volumes  |

---

## 🌐 Networks

| Command                        | Description                      |
| ------------------------------ | -------------------------------- |
| `docker network ls`            | List networks                    |
| `docker network create <net>`  | Create a custom bridge network   |
| `docker run --network=<net> …` | Connect a container to a network |
| `docker network inspect <net>` | View network details             |
| `docker network rm <net>`      | Remove one or more networks      |

---

## 🧹 System Cleanup & Maintenance

| Command                  | Description                                                                     |
| ------------------------ | ------------------------------------------------------------------------------- |
| `docker system df`       | Show disk usage of images, containers, volumes                                  |
| `docker system prune`    | Remove all stopped containers, unused networks, dangling images and build cache |
| `docker container prune` | Remove all stopped containers                                                   |
| `docker image prune`     | Remove dangling images                                                          |
| `docker volume prune`    | Remove all unused volumes                                                       |
| `docker network prune`   | Remove all unused networks                                                      |

```bash
# Aggressive cleanup (won’t remove running containers)
docker system prune -a --volumes
```

---

## ℹ️ Info & Diagnostics

```bash
# Docker version and client/server info
docker version
docker info

# Show detailed resource usage
docker stats                # live stream
docker stats --no-stream    # one-time snapshot
```

---

## 🛠️ Docker Compose (if installed)

```bash
# Run services defined in docker-compose.yml
docker compose up -d

# Show running compose services
docker compose ps

# View logs for all services
docker compose logs -f

# Stop and remove containers, networks, volumes
docker compose down
```

---

### Tips & Best Practices

* **Use descriptive tags** (e.g., `myapp:2025.07.08`) to track versions.
* **Keep images small**: leverage multi-stage builds and minimal base images.
* **Automate builds** with CI pipelines (e.g., GitHub Actions, GitLab CI).
* **Regularly prune** unused resources to reclaim disk space.
* **Security**: scan images with tools like `docker scan` or third-party scanners.

