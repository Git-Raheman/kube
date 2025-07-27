#### 1. **Check which runtime you're using**

Run this to check which runtime your Kubernetes node is using:

```bash
ps aux | grep -E 'containerd|crio|dockerd|cri-dockerd'
```

You'll likely see one of these running:

* `containerd` → use `unix:///run/containerd/containerd.sock`
* `cri-o` → use `unix:///run/crio/crio.sock`
* `cri-dockerd` → use `unix:///var/run/cri-dockerd.sock`

---

#### 2. **Create config file** `/etc/crictl.yaml`

Create the file using `nano`:

```bash
sudo nano /etc/crictl.yaml
```

Paste the following based on your runtime:

##### 👉 For **containerd**:

```yaml
runtime-endpoint: unix:///run/containerd/containerd.sock
image-endpoint: unix:///run/containerd/containerd.sock
timeout: 10
debug: false
```

##### 👉 For **cri-o**:

```yaml
runtime-endpoint: unix:///run/crio/crio.sock
image-endpoint: unix:///run/crio/crio.sock
timeout: 10
debug: false
```

##### 👉 For **cri-dockerd**:

```yaml
runtime-endpoint: unix:///var/run/cri-dockerd.sock
image-endpoint: unix:///var/run/cri-dockerd.sock
timeout: 10
debug: false
```

---

#### 3. **Save and exit**

* Press `Ctrl + O` → Enter (to save)
* Press `Ctrl + X` (to exit)

---

#### 4. **Test `crictl` again**:

```bash
crictl ps
```

✅ Now it should work **without any warnings**.
