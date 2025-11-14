# Submit Quick Test - Copy/Paste These Commands

The server connection is intermittent from my end. **Copy and paste these commands directly into your terminal:**

## ✅ What's Already Done

I've successfully completed:
- ✅ Uploaded coldstart with EfficientNet B0 to server
- ✅ Updated pyproject.toml for quick test (5 rounds, lr=0.001)
- ✅ Updated dataset path to ~/xray-data
- ✅ Flower 1.23.0 is already installed

## 🚀 Run These Commands (Copy/Paste)

### Step 1: SSH into Server
```bash
ssh team04@129.212.178.168 -p 32605
```
Password: `Et;;%oiWS)IT<Ot0uY0CTrG07YiHZbSQ`

**If connection times out, try 2-3 times!**

---

### Step 2: Setup and Submit Quick Test
Once you're logged in, paste these commands:

```bash
cd ~/coldstart
source ~/hackathon-venv/bin/activate
export DATASET_DIR=~/xray-data

# Verify setup
echo "Dataset: $DATASET_DIR"
ls $DATASET_DIR/xray_fl_datasets_preprocessed_128/

# Check config
grep -A 5 "tool.flwr.app.config" pyproject.toml

# Submit quick test (5 rounds, EfficientNet B0)
flwr run . local-simulation --stream
```

---

### Step 3: If Job Runs Successfully

You'll see output like:
```
Loading ServerApp
Loading ClientApp
INFO: Starting Flower simulation
Round 1/5
  Hospital A training...
  Hospital B training...
  Hospital C training...
  AUROC: 0.XXXX
...
```

**Let it run for 5-10 minutes.**

---

### Step 4: After Quick Test Completes

```bash
# Check if models were saved
ls -lh ~/coldstart/models/

# Update config for full training (20 rounds)
cd ~/coldstart
nano pyproject.toml
# Change line: num-server-rounds = 5  →  num-server-rounds = 20
# Save: Ctrl+X, Y, Enter

# Submit full training
flwr run . local-simulation --stream
```

---

## 🎯 Current Config (Already Set)

```toml
[tool.flwr.app.config]
image-size = 128          # Using 128x128 images
num-server-rounds = 5     # Quick test - change to 20 for full
local-epochs = 1          # 1 epoch per hospital per round
lr = 0.001                # Lower LR for pretrained EfficientNet B0
```

**Model**: EfficientNet B0 with ImageNet pretrained weights
**Dataset**: ~/xray-data/xray_fl_datasets_preprocessed_128/
**Hospitals**: 3 (A, B, C)

---

## 📊 Expected Results

### Quick Test (5 rounds):
- **Time**: 5-10 minutes
- **AUROC**: ~0.55-0.70 (undertrained)
- **Purpose**: Verify everything works

### Full Training (20 rounds):
- **Time**: 18-20 minutes
- **AUROC**: ~0.75-0.82 (good performance!)
- **Purpose**: Final model

---

## 🐛 Troubleshooting

### If you get "DATASET_DIR not found":
```bash
export DATASET_DIR=~/xray-data
ls $DATASET_DIR/xray_fl_datasets_preprocessed_128/
```

### If you get "Module not found":
```bash
cd ~/coldstart
source ~/hackathon-venv/bin/activate
pip list | grep -E "flwr|torch"
```

### If training fails:
```bash
# Check the error message
# Common issues:
# 1. Dataset path - make sure DATASET_DIR is set
# 2. GPU/memory - use local-simulation federation (no GPU needed)
# 3. Module imports - make sure you're in ~/coldstart directory
```

---

## 🎉 After Successful Training

Your best model will be saved in:
```
~/coldstart/models/YOUR_RUN_NAME_roundN_aurocXXXX.pt
```

To evaluate:
```bash
# Update evaluate.py with your best model path
nano evaluate.py
# Line 19: MODEL_PATH = "/home/team04/coldstart/models/YOUR_MODEL.pt"

# Run evaluation
python evaluate.py
```

---

## 📋 Summary of Changes I Made

1. **Updated pyproject.toml**:
   - Components point to `cold_start_hackathon` (our EfficientNet B0 version)
   - num-server-rounds = 5 (for quick test)
   - lr = 0.001 (optimized for pretrained model)

2. **Updated task.py**:
   - Dataset path now defaults to ~/xray-data

3. **Model**: EfficientNet B0 with:
   - ImageNet pretrained weights
   - Grayscale adaptation for X-rays
   - Dropout regularization (0.3)
   - Binary classification head

---

**Copy the commands from Step 2 above and run them now!** 🚀

The server connection is intermittent, so you may need to try SSHing 2-3 times.
