# Storcli64-docker

An ultra-lightweight (~25MB), Alpine-based Docker container for Broadcom/LSI MegaRAID `storcli64` utility optimization, specifically tailored for **TrueNAS SCALE**. 

## Features
- **Minimal Footprint:** Uses an Alpine multi-stage build structure to keep the production runtime lean (~25MB), leaving more RAM available for your ZFS cache.
- **Direct Hardware Communication:** Configured to safely interact with physical PCIe RAID controllers from inside an isolated container environment using `gcompat`.

---

## 🚀 Deployment on TrueNAS SCALE

Because TrueNAS SCALE treats the underlying Debian OS as a managed appliance, you should always build and run hardware management utilities within an isolated container environment.

### Step 1: Clone and Build the Image
SSH into your TrueNAS system as an administrator, navigate to a persistent storage directory on your ZFS pool, and run:

```bash
# Clone your repository
git clone https://github.com/Lol8005/Storcli64-docker/
cd Storcli64-docker

# Build the Docker image locally (requires sudo to access the Docker daemon)
sudo docker build -t local-storcli:latest .
```

### Step 2: Create a Global Shorthand Alias
Avoid typing long Docker commands every time you need to manage your arrays. Map the container execution string into a global system alias:

```bash
# Append the alias mapping to your environment profile
echo "alias storcli64='sudo docker run --rm -it --privileged local-storcli:latest storcli64'" >> ~/.bashrc

# Reload your shell configuration profile instantly
source ~/.bashrc
```

### Step 3: Run Hardware Verification
Test your newly mapped alias by retrieving the global hardware topology directly from the host PCIe layout:

```bash
storcli64 show
```

---

## 📖 Common Management Cheatsheet

Once your alias is active, you can use these baseline syntaxes directly from the TrueNAS host terminal:

* **List all controllers & general health summary:**
  ```bash
  storcli64 /c0 show all
  ```
* **Review physical disk states across all backplane slots:**
  ```bash
  storcli64 /c0/eall/sall show
  ```
* **Check the specific ROC/Controller temperature:**
  ```bash
  storcli64 /c0 show temperature
  ```

---

## 🧹 Cleanup and Removal

If you ever need to completely remove the utility, build caches, or configuration shortcuts from your TrueNAS system, follow these steps:

### 1. Delete Docker Build Cache and Images
Remove the local container image along with any dangling multi-stage builder layers left behind:

```bash
# Remove the built production image
sudo docker rmi local-storcli:latest

# Purge unused build caches to reclaim disk space
sudo docker builder prune -f
```

### 2. Remove the Git Repository Directory
Delete the workspace folder you cloned from the storage pool:

```bash
# Step out of the directory if you are still inside it
cd ..
rm -rf Storcli64-docker
```

### 3. Remove the Shell Alias
Open your environment profile file using a text editor (like `nano`):

```bash
nano ~/.bashrc
```

Scroll down to the bottom of the file, find the line containing `alias storcli64=...`, and delete it. Save and exit the editor (`Ctrl+O`, then `Ctrl+X`).

Finally, apply the changes to your current session by resetting the shell environment:
```bash
unalias storcli64
```
