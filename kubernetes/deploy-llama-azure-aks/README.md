# Deploy Llama to Azure AKS

This example deploys Llama 3.2 to an existing Azure AKS cluster using Kubernetes.

Tested with: `Standard_NC4as_T4_v3` GPU node pool (NVIDIA T4, 16GB VRAM)

## Prerequisites

- AKS cluster with a GPU node pool
- `kubectl` configured for your cluster (`az aks get-credentials`)
- Azure CLI installed

## Step 1 - Create a GPU Node Pool (skip if you have one)

```bash
az aks nodepool add \
  --resource-group your-resource-group \
  --cluster-name your-cluster \
  --name gpunodes \
  --node-count 1 \
  --node-vm-size Standard_NC4as_T4_v3 \
  --node-taints sku=gpu:NoSchedule \
  --aks-custom-headers UseGPUDedicatedVHD=true
```

The `--aks-custom-headers` flag installs NVIDIA drivers automatically via the GPU-optimized node image.

## Step 2 - Deploy

```bash
kubectl apply -f deployment.yaml
```

## Step 3 - Wait for the Pod

The init container pulls the Llama model on first run - this takes a few minutes depending on your cluster's egress speed.

```bash
kubectl get pods -n ai-inference -w
```

Wait until status is `Running`.

## Step 4 - Test

```bash
kubectl port-forward -n ai-inference svc/llama 11434:11434
curl http://localhost:11434/api/generate \
  -d '{"model": "llama3.2:3b", "prompt": "Hello"}'
```

## Step 5 - Use the OpenAI-Compatible API

```python
from openai import OpenAI

client = OpenAI(
    api_key="unused",
    base_url="http://localhost:11434/v1",
)

response = client.chat.completions.create(
    model="llama3.2:3b",
    messages=[{"role": "user", "content": "Hello"}],
)
print(response.choices[0].message.content)
```

## Supported Models (T4 - 16GB VRAM)

| Model | VRAM Required | Command |
|---|---|---|
| llama3.2:3b | 4GB | `ollama pull llama3.2:3b` |
| llama3.1:8b | 8GB | `ollama pull llama3.1:8b` |
| deepseek-r1:7b | 8GB | `ollama pull deepseek-r1:7b` |
| mistral:7b | 8GB | `ollama pull mistral:7b` |

To change the model, update the `pull-model` init container command and the `OLLAMA_MODEL` env var in `deployment.yaml`.

---

## Simpler alternative

Connect your AKS cluster to CaseDesk and deploy Llama from the dashboard without writing manifests.

[https://getcasedesk.com](https://getcasedesk.com)
