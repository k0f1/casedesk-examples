# Deploy an AI Model to GCP GPU VM

This guide provisions a GPU VM on Google Cloud, installs Ollama, and runs an open-source model.

Tested with: `n1-standard-4` + NVIDIA T4 GPU (16GB VRAM)

## Prerequisites

- Google Cloud account with billing enabled
- `gcloud` CLI installed and authenticated

## Step 1 - Provision the VM

```bash
gcloud compute instances create ai-inference \
  --zone=us-central1-a \
  --machine-type=n1-standard-4 \
  --accelerator=type=nvidia-tesla-t4,count=1 \
  --image-family=ubuntu-2204-lts \
  --image-project=ubuntu-os-cloud \
  --boot-disk-size=100GB \
  --maintenance-policy=TERMINATE \
  --metadata=install-nvidia-driver=True
```

## Step 2 - SSH In

```bash
gcloud compute ssh ai-inference --zone=us-central1-a
```

## Step 3 - Install NVIDIA Drivers

```bash
curl https://raw.githubusercontent.com/GoogleCloudPlatform/compute-gpu-installation/main/linux/install_gpu_driver.py --output install_gpu_driver.py
sudo python3 install_gpu_driver.py
```

Verify:

```bash
nvidia-smi
```

## Step 4 - Install Ollama

```bash
curl -fsSL https://ollama.com/install.sh | sh
sudo systemctl enable ollama
sudo systemctl start ollama
```

## Step 5 - Pull and Run a Model

```bash
ollama pull qwen2.5:7b
ollama run qwen2.5:7b
```

## Step 6 - Test the API

```bash
curl http://localhost:11434/api/generate \
  -d '{"model": "qwen2.5:7b", "prompt": "Hello"}'
```

## Supported Models

| Model | VRAM Required | Command |
|---|---|---|
| qwen2.5:7b | 8GB | `ollama pull qwen2.5:7b` |
| deepseek-r1:7b | 8GB | `ollama pull deepseek-r1:7b` |
| llama3.2:3b | 4GB | `ollama pull llama3.2:3b` |
| gemma3:4b | 6GB | `ollama pull gemma3:4b` |

---

## Simpler alternative

Connect this VM to CaseDesk and deploy models from the dashboard without SSH.

[https://getcasedesk.com](https://getcasedesk.com)
