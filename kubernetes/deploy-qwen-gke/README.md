# Deploy Qwen to GKE

This example deploys Qwen 2.5 to an existing Google Kubernetes Engine cluster.

Tested with: `n1-standard-4` + NVIDIA T4 GPU node pool (16GB VRAM)

## Prerequisites

- GKE cluster with a GPU node pool
- `kubectl` configured for your cluster (`gcloud container clusters get-credentials`)
- `gcloud` CLI installed and authenticated

## Step 1 - Create a GPU Node Pool (skip if you have one)

```bash
gcloud container node-pools create gpu-pool \
  --cluster=your-cluster \
  --zone=us-central1-a \
  --machine-type=n1-standard-4 \
  --accelerator=type=nvidia-tesla-t4,count=1 \
  --num-nodes=1 \
  --node-taints=nvidia.com/gpu=present:NoSchedule
```

## Step 2 - Install the NVIDIA Device Plugin

GKE does not install the NVIDIA device plugin automatically on standard clusters.

```bash
kubectl apply -f https://raw.githubusercontent.com/GoogleCloudPlatform/container-engine-accelerators/master/nvidia-device-plugin.yaml
```

Verify the plugin is running:

```bash
kubectl get pods -n kube-system | grep nvidia
```

## Step 3 - Deploy

```bash
kubectl apply -f deployment.yaml
```

## Step 4 - Wait for the Pod

The init container pulls the Qwen model on first run.

```bash
kubectl get pods -n ai-inference -w
```

Wait until status is `Running`.

## Step 5 - Test

```bash
kubectl port-forward -n ai-inference svc/qwen 11434:11434
curl http://localhost:11434/api/generate \
  -d '{"model": "qwen2.5:7b", "prompt": "Hello"}'
```

## Step 6 - Use the OpenAI-Compatible API

```python
from openai import OpenAI

client = OpenAI(
    api_key="unused",
    base_url="http://localhost:11434/v1",
)

response = client.chat.completions.create(
    model="qwen2.5:7b",
    messages=[{"role": "user", "content": "Hello"}],
)
print(response.choices[0].message.content)
```

## Supported Models (T4 - 16GB VRAM)

| Model | VRAM Required | Command |
|---|---|---|
| qwen2.5:7b | 8GB | `ollama pull qwen2.5:7b` |
| qwen2.5:14b | 14GB | `ollama pull qwen2.5:14b` |
| qwen2.5-coder:7b | 8GB | `ollama pull qwen2.5-coder:7b` |
| deepseek-r1:7b | 8GB | `ollama pull deepseek-r1:7b` |

To change the model, update the `pull-model` init container command and the `OLLAMA_MODEL` env var in `deployment.yaml`.

---

## Simpler alternative

Connect your GKE cluster to CaseDesk and deploy Qwen from the dashboard without writing manifests.

[https://getcasedesk.com](https://getcasedesk.com)
