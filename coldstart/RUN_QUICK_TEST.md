# Quick Test - Run These Commands Manually

The server connection is intermittent. Please run these commands **directly in your terminal**:

## Step 1: SSH into Server (may need 2-3 tries)

```bash
ssh team04@129.212.178.168 -p 32605
# Password: Et;;%oiWS)IT<Ot0uY0CTrG07YiHZbSQ
```

**If connection times out, try again immediately. It usually works on 2nd or 3rd try.**

---

## Step 2: Navigate and Activate Environment

```bash
cd ~/coldstart
source ~/hackathon-venv/bin/activate
```

---

## Step 3: Check What's Installed

```bash
# Check if dependencies are installed
python -c "import flwr; print(flwr.__version__)"
python -c "import torch; print(torch.__version__)"

# If they're not installed, the pip install should still be running
# Check with:
ps aux | grep pip
```

**If pip install is still running, wait for it to complete (~5 minutes total)**

---

## Step 4: Update Config for Quick Test

```bash
# Edit the config file
nano pyproject.toml
```

**Find this section** (around line 46-50):
```toml
[tool.flwr.app.config]
image-size = 128
num-server-rounds = 100
local-epochs = 1
lr = 0.01
```

**Change to** (for quick test):
```toml
[tool.flwr.app.config]
image-size = 128
num-server-rounds = 5      # Changed from 100 to 5 for quick test
local-epochs = 1
lr = 0.001                  # Changed from 0.01 to 0.001 for pretrained model
```

**Save**: Press `Ctrl+X`, then `Y`, then `Enter`

---

## Step 5: Submit Quick Test Job

```bash
# Make sure you're in ~/coldstart directory
cd ~/coldstart

# Check if submit-job.sh exists
ls -la submit-job.sh

# If it doesn't exist, check what files we have
ls -la

# Submit the job (adjust command based on what's available)
# Try this first:
flwr run . --run-config num-server-rounds=5

# OR if submit-job.sh exists:
./submit-job.sh "flwr run ." --gpu --name quick_test
```

---

## Step 6: Monitor the Job

```bash
# Check job status
squeue -u team04

# Find the log file
ls -lt ~/logs/ | head -5

# Monitor the log (replace with actual filename)
tail -f ~/logs/quick_test_*.out

# Or if no logs yet:
tail -f ~/logs/*.out
```

---

## What to Look For in the Logs

**Success indicators:**
```
✓ Loading model...
✓ Hospital A, Hospital B, Hospital C training
✓ Round 1/5 completed
✓ Round 2/5 completed
...
✓ AUROC: 0.XXXX
✓ Model saved
```

**If you see errors:**
- Dataset not found → Check DATASET_DIR
- GPU error → Job might not have GPU allocated
- Import errors → Dependencies not installed yet

---

## Expected Results

**Time**: 5-10 minutes
**AUROC**: ~0.55-0.70 (undertrained, but proves it works!)
**Purpose**: Verify everything is working before full training

---

## After Quick Test Succeeds

```bash
# Find the saved model
ls -lh ~/models/

# Update config for full training
nano pyproject.toml
# Change: num-server-rounds = 20 (or 25 for better results)

# Submit full training
flwr run .
# OR
./submit-job.sh "flwr run ." --gpu --name efficientnet_b0_full

# Monitor
tail -f ~/logs/efficientnet_b0_full_*.out
```

---

## Troubleshooting

### Can't connect via SSH
- Try 2-3 times
- Check you're on hackathon WiFi

### pip install still running
```bash
ps aux | grep pip
# Wait for it to complete, or cancel and install manually:
# Ctrl+C, then:
pip install -e .
```

### submit-job.sh doesn't exist
```bash
# Check what scripts are available
ls -la ~/

# You might need to use:
flwr run .
# OR
python -m flwr run .
```

### Dataset not found
```bash
# Check dataset location
ls /shared/hackathon/datasets/
ls /shared/hackathon/datasets/xray_fl_datasets_preprocessed_128/

# Make sure environment variable is set
echo $DATASET_DIR

# If not set, the job script should set it
```

---

## Quick Command Reference

```bash
# SSH (2-3 tries)
ssh team04@129.212.178.168 -p 32605

# Go to directory
cd ~/coldstart && source ~/hackathon-venv/bin/activate

# Edit config
nano pyproject.toml

# Submit job
flwr run .

# Monitor
tail -f ~/logs/*.out

# Check status
squeue -u team04

# List models
ls -lh ~/models/
```

---

**Start with Step 1 above and work through them manually. The connection should work after 2-3 tries!** 🚀
