# GCP VM Setup Guide for ACE-Step-1.5

## Prerequisites

- Google Cloud Platform account with billing enabled
- `gcloud` CLI installed and configured

## 1. Create VM with GPU

```bash
# Set project
gcloud config set project YOUR_PROJECT_ID

# Create VM with GPU
gcloud compute instances create jam-ai-gpu \
  --zone=us-central1-a \
  --machine-type=n1-standard-4 \
  --accelerator=type=nvidia-tesla-t4,count=1 \
  --image-family=ubuntu-2204-lts \
  --image-project=ubuntu-os-cloud \
  --boot-disk-size=100GB \
  --boot-disk-type=pd-ssd \
  --maintenance-policy=TERMINATE \
  --tags=http-server,https-server
```

## 2. Configure Firewall

```bash
# Allow port 8001 for API
gcloud compute firewall-rules create allow-acestep-api \
  --allow=tcp:8001 \
  --target-tags=http-server \
  --description="Allow ACE-Step API traffic"
```

## 3. SSH and Install

```bash
# SSH into VM
gcloud compute ssh jam-ai-gpu --zone=us-central1-a

# Run installation script
chmod +x install_model.sh
./install_model.sh
```

## 4. Set API Key and Start

```bash
# Set API key in environment
echo 'ACE_STEP_API_KEY=your-secret-key-here' | sudo tee /etc/acestep.env
sudo chmod 600 /etc/acestep.env

# Start service
sudo systemctl daemon-reload
sudo systemctl start acestep
sudo systemctl enable acestep

# Check logs
sudo journalctl -u acestep -f
```

## 5. Verify Installation

```bash
# Check GPU
nvidia-smi

# Test API
curl http://localhost:8001/health
```

## Cost Optimization Tips

1. **Spot/Preemptible VMs**: 60-90% cheaper, but can be terminated
2. **Scheduled Start/Stop**: Use Cloud Scheduler to run VM only during peak hours
3. **Auto-scaling**: Use Cloud Run for the API layer (connects to GPU VM)
