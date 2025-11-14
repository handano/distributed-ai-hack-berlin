# Quick Command Reference - Team04

## 🔐 SSH Access
```bash
ssh team04@129.212.178.168 -p 32605
# Password: Et;;%oiWS)IT<Ot0uY0CTrG07YiHZbSQ
```

## ⚡ Quick Setup (Run Once)
```bash
cd ~/coldstart
source ~/hackathon-venv/bin/activate
pip install -e .
```

## 🎯 Submit Training Job
```bash
cd ~/coldstart

# Quick test (fewer rounds)
./submit-job.sh "flwr run . cluster --stream" --gpu --name test_run

# Full training
./submit-job.sh "flwr run . cluster --stream" --gpu --name efficientnet_b0
```

## 📊 Monitor Progress
```bash
# Check job status
squeue -u team04

# View latest log
ls -lt ~/logs/ | head -5
tail -f ~/logs/YOUR_JOB_NAME_*.out

# Check models
ls -lh ~/models/
```

## 🔧 Quick Config Changes
```bash
cd ~/coldstart
nano pyproject.toml

# Change these values:
# num-server-rounds = 20    (reduce for faster iteration)
# lr = 0.001                (lower LR for pretrained)
# image-size = 128          (faster than 224)
```

## 📈 Evaluate Best Model
```bash
# List models
ls -lh ~/models/

# Edit evaluate.py
nano evaluate.py
# Update line 19: MODEL_PATH = "/home/team04/models/YOUR_BEST_MODEL.pt"

# Run evaluation
./submit-job.sh "python evaluate.py" --gpu --name eval_final
```

## 🐛 Troubleshooting
```bash
# Check dataset
ls -lh /shared/hackathon/datasets/xray_fl_datasets_preprocessed_128/

# Check GPU
nvidia-smi

# Check environment
which python
pip list | grep -E "flwr|torch"

# View full log
cat ~/logs/YOUR_JOB_*.out

# Cancel job
scancel JOB_ID
```

## ⏰ Time Check
```bash
date
# Deadline: Saturday 15:30
```

## 📝 W&B Setup (Optional)
```bash
export WANDB_API_KEY="your_key_from_organizers"
export WANDB_PROJECT="coldstart2025-team04"
```

## 🎯 Recommended First Commands
```bash
# 1. SSH in
ssh team04@129.212.178.168 -p 32605

# 2. Go to directory
cd ~/coldstart

# 3. Activate environment
source ~/hackathon-venv/bin/activate

# 4. Install
pip install -e .

# 5. Edit config (reduce rounds for testing)
nano pyproject.toml
# Change: num-server-rounds = 10

# 6. Submit test job
./submit-job.sh "flwr run . cluster --stream" --gpu --name test_quick

# 7. Monitor
tail -f ~/logs/test_quick_*.out
```
