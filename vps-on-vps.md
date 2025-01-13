# System

To partition your existing VPS into multiple virtual machines (VMs) with specified RAM allocations via the command line, you can utilize **Kernel-based Virtual Machine (KVM)** along with the **`virt-install`** utility. Here's how to proceed:

1. **Verify Virtualization Support**:
   - Ensure your CPU supports virtualization:
     - For Intel CPUs, look for the `vmx` flag.
     - For AMD CPUs, look for the `svm` flag.
   - Check by running:
     ```bash
     egrep -o 'vmx|svm' /proc/cpuinfo
     ```
   - If no output appears, your CPU may not support hardware virtualization.

2. **Install Necessary Packages**:
   - Install KVM and associated tools:
     ```bash
     sudo apt update
     sudo apt install qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils virtinst
     ```
   - Start and enable the libvirtd service:
     ```bash
     sudo systemctl enable --now libvirtd
     ```

3. **Create Virtual Machines with `virt-install`**:
   - Use the `virt-install` command to create VMs with specified resources.
   - Example for a VM with 2 GB RAM:
     ```bash
     sudo virt-install \
       --name vm1 \
       --memory 2048 \
       --vcpus 2 \
       --disk size=20 \
       --os-variant ubuntu20.04 \
       --cdrom /path/to/ubuntu-20.04.iso
     ```
   - Replace `/path/to/ubuntu-20.04.iso` with the actual path to your OS installation ISO.
   - Repeat the command for other VMs, adjusting the `--name`, `--memory`, `--vcpus`, and `--disk` parameters as needed.

4. **Manage Virtual Machines with `virsh`**:
   - List all VMs:
     ```bash
     sudo virsh list --all
     ```
   - Start a VM:
     ```bash
     sudo virsh start vm1
     ```
   - Access a VM's console:
     ```bash
     sudo virsh console vm1
     ```
   - Shutdown a VM:
     ```bash
     sudo virsh shutdown vm1
     ```

**Considerations**:

- **Resource Allocation**: Ensure your VPS has sufficient resources to accommodate the combined allocations of all VMs. Overcommitting resources can lead to performance degradation.

- **Networking Configuration**: By default, VMs may use NAT for networking. Depending on your requirements, you might need to configure bridged networking or other network setups.

- **Storage Management**: Allocate adequate disk space for each VM based on its intended use.

For more detailed information, refer to the Red Hat documentation on creating virtual machines using the command-line interface. 

# Networking

To route traffic to services hosted on your virtual machines (VMs) using NGINX as a reverse proxy, follow these steps:

**1. Configure Bridged Networking for VMs:**

Set up a network bridge on your host to allow VMs to obtain IP addresses on the same network as the host. This enables direct communication between the host, VMs, and external clients.

- **Create a Network Bridge:**

  - **On Debian/Ubuntu:**

    - Install necessary packages:

      ```bash
      sudo apt install bridge-utils
      ```

    - Edit `/etc/network/interfaces` to add:

      ```bash
      auto br0
      iface br0 inet dhcp
          bridge_ports eth0
      ```

    - Restart networking:

      ```bash
      sudo systemctl restart networking
      ```

  - **On CentOS/RHEL:**

    - Install necessary packages:

      ```bash
      sudo yum install bridge-utils
      ```

    - Create a bridge configuration file `/etc/sysconfig/network-scripts/ifcfg-br0` with:

      ```bash
      DEVICE=br0
      TYPE=Bridge
      BOOTPROTO=dhcp
      ONBOOT=yes
      ```

    - Edit your existing interface configuration (e.g., `/etc/sysconfig/network-scripts/ifcfg-eth0`) to include:

      ```bash
      BRIDGE=br0
      ```

    - Restart networking:

      ```bash
      sudo systemctl restart network
      ```

- **Attach VMs to the Bridge:**

  When creating or configuring VMs, specify `br0` as the network interface to ensure they connect to the bridge.

**2. Install and Configure NGINX on the Host:**

With VMs accessible via bridged networking, set up NGINX on the host to route incoming traffic to the appropriate VM based on domain names or URL paths.

- **Install NGINX:**

  - **On Debian/Ubuntu:**

    ```bash
    sudo apt update
    sudo apt install nginx
    ```

  - **On CentOS/RHEL:**

    ```bash
    sudo yum install epel-release
    sudo yum install nginx
    ```

- **Configure NGINX as a Reverse Proxy:**

  Edit the NGINX configuration file (usually located at `/etc/nginx/nginx.conf` or within `/etc/nginx/sites-available/` for Debian-based systems) to include server blocks that define how traffic should be routed.

  - **Example Configuration:**

    ```nginx
    server {
        listen 80;
        server_name service1.example.com;

        location / {
            proxy_pass http://192.168.1.101:80;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
        }
    }

    server {
        listen 80;
        server_name service2.example.com;

        location / {
            proxy_pass http://192.168.1.102:80;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
        }
    }
    ```

    Replace `service1.example.com` and `service2.example.com` with your actual domain names, and `192.168.1.101` and `192.168.1.102` with the IP addresses assigned to your VMs.

- **Test and Reload NGINX Configuration:**

  ```bash
  sudo nginx -t
  sudo systemctl reload nginx
  ```

**3. DNS Configuration:**

Ensure that DNS records for your domains (`service1.example.com`, `service2.example.com`, etc.) point to the public IP address of your host server. This setup directs incoming traffic to NGINX, which then proxies requests to the appropriate VM based on the domain name.

**4. Firewall and Security Considerations:**

- **Open Necessary Ports:**

  Ensure that firewall rules on the host allow incoming traffic on port 80 (HTTP) and, if using HTTPS, port 443.

- **Secure Backend Communication:**

  While internal communication between NGINX and your VMs may occur over a private network, consider implementing security measures such as firewall rules or VPNs to protect this traffic.

**5. SSL/TLS Termination (Optional but Recommended):**

For secure communication, configure SSL/TLS certificates in NGINX to handle HTTPS traffic. This setup offloads the encryption/decryption process from your VMs and centralizes certificate management.

- **Obtain SSL Certificates:**

  Use a Certificate Authority (CA) like Let's Encrypt to obtain SSL certificates for your domains.

- **Configure NGINX for SSL:**

  ```nginx
  server {
      listen 80;
      server_name service1.example.com;
      return 301 https://$host$request_uri;
  }

  server {
      listen 443 ssl;
      server_name service1.example.com;

      ssl_certificate /etc/letsencrypt/live/service1.example.com/fullchain.pem;
      ssl_certificate_key /etc/letsencrypt/live/service1.example.com/privkey.pem;

      location / {
          proxy_pass http://192.168.1.101:80;
          proxy_set_header Host $host;
          proxy_set_header X-Real-IP $remote_addr;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header X-Forwarded-Proto $scheme;
      }
  }
  ```

  Repeat the configuration for each service, updating domain names, certificate paths, and backend IP addresses accordingly.
