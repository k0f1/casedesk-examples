# Deploy an AI Model to Hetzner GPU VM

This guide provisions a GPU VM on Hetzner Cloud, installs Ollama, and runs an open-source model.

Tested with: `GX2` (NVIDIA RTX 4000 Ada, 20GB VRAM) - one of the most cost-effective GPU VMs available.

## Prerequisites

- Hetzner Cloud account
- Hetzner CLI: `brew install hcloud` or download from [hetznercloud/cli](https://github.com/hetznercloud/cli)

## Step 1 - Create the VM

```bash
hcloud context create ai-inference
hcloud ssh-key create --name my-key --public-key-from-file ~/.ssh/id_rsa.pub

hcloud server create \
  --name ai-inference \
  --type gx2 \
  --image ubuntu-24.04 \
  --ssh-key my-key \
  --datacenter nbg1-dc3
```

## Step 2 - SSH In

```bash
hcloud server ssh ai-inference
```

## Step 3 - Install NVIDIA Drivers

```bash
apt-get update
apt-get install -y ubuntu-drivers-common
ubuntu-drivers install
reboot
```

Reconnect after reboot, then verify:

```bash
nvidia-smi
```

## Step 4 - Install Ollama

```bash
curl -fsSL https://ollama.com/install.sh | sh
systemctl enable ollama
systemctl start ollama
```

## Step 5 - Pull and Run a Model

```bash
ollama pull deepseek-r1:14b
ollama run deepseek-r1:14b
```

With 20GB VRAM, larger models run comfortably on Hetzner.

## Step 6 - Test the API

```bash
curl http://localhost:11434/api/generate \
  -d '{"model": "deepseek-r1:14b", "prompt": "Hello"}'
```

## Supported Models (GX2 - 20GB VRAM)

| Model | VRAM Required | Command |
|---|---|---|
| deepseek-r1:14b | 16GB | `ollama pull deepseek-r1:14b` |
| llama3.1:8b | 8GB | `ollama pull llama3.1:8b` |
| qwen2.5:14b | 14GB | `ollama pull qwen2.5:14b` |
| mistral:7b | 8GB | `ollama pull mistral:7b` |

---

## Simpler alternative

Connect this VM to CaseDesk and deploy models from the dashboard without SSH.

[https://getcasedesk.com](https://getcasedesk.com)
