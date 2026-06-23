# Deploy an AI Model to Azure GPU VM

This guide provisions a GPU VM on Azure, installs Ollama, and runs an open-source model.

Tested with: `Standard_NC4as_T4_v3` (NVIDIA T4, 16GB VRAM)

## Prerequisites

- Azure account with subscription
- Azure CLI installed (`az login`)

## Step 1 - Create Resource Group and VM

```bash
az group create --name ai-inference-rg --location eastus

az vm create \
  --resource-group ai-inference-rg \
  --name ai-inference-vm \
  --image Ubuntu2204 \
  --size Standard_NC4as_T4_v3 \
  --admin-username azureuser \
  --generate-ssh-keys \
  --os-disk-size-gb 100
```

Note: `azureuser` is not root. Use `sudo` for system commands.

## Step 2 - Open Port for API Access (optional)

```bash
az vm open-port \
  --resource-group ai-inference-rg \
  --name ai-inference-vm \
  --port 11434
```

## Step 3 - Install NVIDIA Drivers

```bash
az vm extension set \
  --resource-group ai-inference-rg \
  --vm-name ai-inference-vm \
  --name NvidiaGpuDriverLinux \
  --publisher Microsoft.HpcCompute
```

Wait for the extension to finish, then SSH in:

```bash
ssh azureuser@<VM_PUBLIC_IP>
```

## Step 4 - Install Ollama

```bash
curl -fsSL https://ollama.com/install.sh | sh
sudo systemctl enable ollama
sudo systemctl start ollama
```

## Step 5 - Pull and Run a Model

```bash
ollama pull llama3.2:3b
ollama run llama3.2:3b
```

## Step 6 - Test the API

```bash
curl http://localhost:11434/api/generate \
  -d '{"model": "llama3.2:3b", "prompt": "Hello"}'
```

## Supported Models

| Model | VRAM Required | Command |
|---|---|---|
| llama3.2:3b | 4GB | `ollama pull llama3.2:3b` |
| deepseek-r1:7b | 8GB | `ollama pull deepseek-r1:7b` |
| qwen2.5:7b | 8GB | `ollama pull qwen2.5:7b` |
| mistral:7b | 8GB | `ollama pull mistral:7b` |

---

## Simpler alternative

Connect this VM to CaseDesk and deploy models from the dashboard without SSH.

[https://getcasedesk.com](https://getcasedesk.com)
