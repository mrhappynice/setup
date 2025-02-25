To easily install and run the Carbonyl terminal browser on Ubuntu, you have two primary options: using Docker or installing via npm.

**Using Docker:**

1. **Install Docker:** If you don't have Docker installed, you can set it up by running:

   ```bash
   sudo apt update
   sudo apt install docker.io
   ```


2. **Run Carbonyl:** Once Docker is installed, execute the following command to run Carbonyl:

   ```bash
   docker run --rm -ti fathyb/carbonyl https://example.com
   ```


   Replace `https://example.com` with the URL you wish to browse.

**Using npm:**

1. **Install Node.js and npm:** Ensure you have Node.js and npm installed. If not, install them with:

   ```bash
   sudo apt update
   sudo apt install nodejs npm
   ```


2. **Install Carbonyl:** Use npm to install Carbonyl globally:

   ```bash
   npm install --global carbonyl
   ```


3. **Run Carbonyl:** After installation, you can start browsing by running:

   ```bash
   carbonyl https://example.com
   ```


   Replace `https://example.com` with your desired URL.

Both methods allow you to run Carbonyl directly in your terminal, providing a full-featured browsing experience without the need for a graphical interface.
