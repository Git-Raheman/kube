# Enable Permanent kubectl Autocompletion on Ubuntu

To enable **persistent kubectl command autocompletion** in Ubuntu bash, follow these steps:

## 1. Install `bash-completion` (if not already installed)
```bash
sudo apt update && sudo apt install -y bash-completion
```

## 2. Add kubectl autocompletion to `~/.bashrc`
Run this command to permanently enable autocompletion:
```bash
echo "source <(kubectl completion bash)" >> ~/.bashrc
```

## 3. Reload your shell
Apply the changes by either:
- Closing and reopening your terminal
- Or running:
  ```bash
  source ~/.bashrc
  ```

## 4. Verify it works
Test by typing:
```bash
kubectl get p[Tab]
```
It should autocomplete to `kubectl get pods`.

---

## Alternative Method (for system-wide setup)
If you prefer system-wide autocompletion (for all users), use:
```bash
kubectl completion bash | sudo tee /etc/bash_completion.d/kubectl > /dev/null
```

## Notes
- This works for **bash** shells. For zsh, use `kubectl completion zsh`.
- Requires kubectl to be installed and in your `$PATH`.

