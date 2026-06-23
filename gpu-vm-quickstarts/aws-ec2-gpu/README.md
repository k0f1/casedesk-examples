# Deploy an AI Model to AWS EC2 GPU VM

This guide provisions a GPU VM on AWS EC2, installs Ollama, and runs an open-source model.

Tested with: `g4dn.xlarge` (NVIDIA T4, 16GB VRAM)

## Prerequisites

- AWS account with EC2 access
- AWS CLI configured (`aws configure`)
- SSH key pair in your target region

## Step 1 - Provision the VM

```bash
aws ec2 run-instances \
  --image-id ami-0c02fb55956c7d316 \
  --instance-type g4dn.xlarge \
  --key-name your-key-name \
  --security-group-ids sg-xxxxxxxx \
  --block-device-mappings '[{"DeviceName":"/dev/xvda","Ebs":{"VolumeSize":100}}]' \
  --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=ai-inference}]'
```

Note your instance's public IP from the AWS console.

## Step 2 - Install NVIDIA Drivers and Docker

```bash
ssh -i your-key.pem ec2-user@<INSTANCE_IP> "bash -s" < setup.sh
```

## Step 3 - Install Ollama

```bash
ssh -i your-key.pem ec2-user@<INSTANCE_IP>

curl -fsSL https://ollama.com/install.sh | sh
sudo systemctl enable ollama
sudo systemctl start ollama
```

## Step 4 - Pull and Run a Model

```bash
ollama pull deepseek-r1:7b
ollama run deepseek-r1:7b
```

## Step 5 - Test the API

```bash
curl http://localhost:11434/api/generate \
  -d '{"model": "deepseek-r1:7b", "prompt": "Hello"}'
```

## Supported Models

| Model | VRAM Required | Command |
|---|---|---|
| deepseek-r1:7b | 8GB | `ollama pull deepseek-r1:7b` |
| llama3.2:3b | 4GB | `ollama pull llama3.2:3b` |
| qwen2.5:7b | 8GB | `ollama pull qwen2.5:7b` |
| gemma3:4b | 6GB | `ollama pull gemma3:4b` |

---

## Simpler alternative

Connect this VM to CaseDesk and deploy models from the dashboard without SSH.

[https://getcasedesk.com](https://getcasedesk.com)
