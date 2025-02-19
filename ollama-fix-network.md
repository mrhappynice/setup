To make Ollama accessible on your local network, you'll need to configure it to listen on an IP address that allows connections from other devices, rather than the default `127.0.0.1` (which restricts access to the local machine). Here's how you can do this:

**1. Set the `OLLAMA_HOST` Environment Variable:**

By setting the `OLLAMA_HOST` environment variable to `0.0.0.0`, you instruct Ollama to listen on all available network interfaces, making it accessible from other devices on your local network.

**For Linux Systems:**

- **If Ollama is managed by `systemd`:**

  1. **Edit the Ollama service configuration:**

     ```bash
     sudo systemctl edit ollama.service
     ```

  2. **Add the following lines:**

     ```
     [Service]
     Environment="OLLAMA_HOST=0.0.0.0"
     ```

     Ensure these lines are placed above any comment lines that indicate where new content should go.

  3. **Save and exit the editor.**

  4. **Reload the systemd configuration and restart the Ollama service:**

     ```bash
     sudo systemctl daemon-reload
     sudo systemctl restart ollama
     ```

     This ensures that the changes take effect and Ollama starts listening on all network interfaces.

- **If you're running Ollama manually from the command line:**

  1. **Export the `OLLAMA_HOST` variable and start Ollama:**

     ```bash
     export OLLAMA_HOST=0.0.0.0
     ollama serve
     ```

     This command sets the environment variable for the current session and starts Ollama, making it accessible from other devices on the network.

**For Windows Systems:**

1. **Set the `OLLAMA_HOST` environment variable:**

   - **Through the System Properties:**

     - Open the **System Properties** window (you can search for "Environment Variables" in the Start menu).

     - Click on **Environment Variables**.

     - Under **System variables**, click **New** and add:

       - **Variable name:** `OLLAMA_HOST`

       - **Variable value:** `0.0.0.0`

     - Click **OK** to save the changes.

   - **Through the Command Prompt:**

     ```cmd
     setx OLLAMA_HOST "0.0.0.0"
     ```

     This command sets the environment variable persistently.

2. **Restart the Ollama application** to apply the changes.

**2. Verify Network Accessibility:**

After configuring Ollama to listen on all interfaces, ensure that your system's firewall settings allow incoming connections on the port Ollama uses (default is `11434`).

**3. Test the Connection:**

From another device on your local network, you can test the connection using `curl` or a web browser:

- **Using `curl`:**

  ```bash
  curl http://<your-computer-ip>:11434
  ```

- **Using a web browser:**

  Navigate to `http://<your-computer-ip>:11434`

Replace `<your-computer-ip>` with the IP address of the machine running Ollama.

**Security Considerations:**

Exposing Ollama on your local network can have security implications. Ensure that your network is secure and consider implementing additional security measures, such as setting up a reverse proxy with authentication, to control access.

By following these steps, you should be able to run Ollama on your local network, making it accessible to other devices. 

---
---
---
On Linux  

Edit the ollama.service using the following command  

sudo systemctl edit ollama.service  

Add the following environment variables  

[Service]
Environment="OLLAMA_HOST=0.0.0.0"  
Environment="OLLAMA_ORIGINS=*"

Then restart the ollama service

sudo service ollama restart

Testing

Your output should be like below if everything is setup right for Origins

(base) ➜  ~ curl -X OPTIONS http://localhost:11434 -H "Origin: http://example.com" -H "Access-Control-Request-Method: GET" -I
HTTP/1.1 204 No Content
Access-Control-Allow-Headers: Authorization,Content-Type,User-Agent,Accept,X-Requested-With,X-Stainless-Lang,X-Stainless-Package-Version,X-Stainless-Os,X-Stainless-Arch,X-Stainless-Runtime,X-Stainless-Runtime-Version,X-Stainless-Async
Access-Control-Allow-Methods: GET,POST,PUT,PATCH,DELETE,HEAD,OPTIONS
Access-Control-Allow-Origin: *
Access-Control-Max-Age: 43200
Date: Wed, 09 Oct 2024 10:13:26 GMT

to make sure binding is correct, run the following command

(base) gavi@node1:~$ netstat -an |grep 11434
tcp6       0      0 :::11434                :::*                    LISTEN

As you can see the port is bound to all IPs on the machine
