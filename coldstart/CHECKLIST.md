# Team04 Training Submission Checklist

## ✅ Pre-Flight Checklist

### Done ✓
- [x] Downloaded official hackathon template
- [x] Modified model to EfficientNet B0 with pretrained weights
- [x] Uploaded coldstart/ to server
- [x] Installation in progress on server

### In Progress ⏳
- [ ] Dependencies installation (running now...)

### To Do Next 📝
- [ ] Update pyproject.toml with optimized config
- [ ] Submit training job
- [ ] Monitor training
- [ ] Evaluate best model
- [ ] Submit results

---

## 🚀 Execution Plan

### Phase 1: Quick Test (5-10 minutes) 🧪
**Purpose**: Verify everything works before full training

```bash
ssh team04@129.212.178.168 -p 32605
cd ~/coldstart
source ~/hackathon-venv/bin/activate

# Edit config for quick test
nano pyproject.toml
# Change: num-server-rounds = 5 (just for testing)

# Submit quick test
./submit-job.sh "flwr run . cluster --stream" --gpu --name quick_test

# Monitor
tail -f ~/logs/quick_test_*.out
```

**Expected**: Completes in 5-10 minutes, AUROC ~0.55-0.65 (undertrained, but proves it works)

---

### Phase 2: Optimized Training (20 minutes) 🎯
**Purpose**: Full training with optimized hyperparameters

```bash
# Upload optimized config
scp -P 32605 pyproject_optimized.toml team04@129.212.178.168:~/coldstart/pyproject.toml

# OR edit manually on server
nano pyproject.toml
# Set: num-server-rounds = 20, lr = 0.001

# Submit full training
./submit-job.sh "flwr run . cluster --stream" --gpu --name efficientnet_b0_final

# Monitor
tail -f ~/logs/efficientnet_b0_final_*.out
```

**Expected**: AUROC ~0.75-0.82 (good performance with pretrained EfficientNet B0)

---

### Phase 3: Evaluation & Submission 📊
**Purpose**: Evaluate best model and prepare submission

```bash
# Find best model
ls -lht ~/models/ | head -5

# Example output:
# efficientnet_b0_final_round18_auroc8134.pt  <- This is your best!

# Update evaluate.py
nano evaluate.py
# Line 19: MODEL_PATH = "/home/team04/models/efficientnet_b0_final_round18_auroc8134.pt"

# Run evaluation
./submit-job.sh "python evaluate.py" --gpu --name eval_final

# View results
cat ~/logs/eval_final_*.out
```

---

## ⚙️ Configuration Recommendations

### Conservative (Safe, Fits Time Limit)
```toml
image-size = 128
num-server-rounds = 15
local-epochs = 1
lr = 0.001
```
**Time**: ~12-15 minutes
**Expected AUROC**: 0.74-0.78

### Balanced (Recommended) ⭐
```toml
image-size = 128
num-server-rounds = 20
local-epochs = 1
lr = 0.001
```
**Time**: ~18-20 minutes
**Expected AUROC**: 0.76-0.82

### Aggressive (Risky, Might Timeout)
```toml
image-size = 224
num-server-rounds = 20
local-epochs = 2
lr = 0.0005
```
**Time**: ~25-30 minutes (WILL TIMEOUT!)
**Don't use this for first submission**

---

## 🎯 Success Criteria

| Metric | Minimum | Good | Excellent |
|--------|---------|------|-----------|
| **Training Completes** | ✅ Required | ✅ Required | ✅ Required |
| **No Errors** | ✅ Required | ✅ Required | ✅ Required |
| **AUROC** | >0.70 | >0.75 | >0.80 |
| **All Hospitals Participate** | ✅ Required | ✅ Required | ✅ Required |

---

## 📋 Commands Quick Reference

### SSH & Navigation
```bash
ssh team04@129.212.178.168 -p 32605
cd ~/coldstart
source ~/hackathon-venv/bin/activate
```

### Submit Jobs
```bash
# Test run
./submit-job.sh "flwr run . cluster --stream" --gpu --name test

# Full training
./submit-job.sh "flwr run . cluster --stream" --gpu --name exp1

# Evaluation
./submit-job.sh "python evaluate.py" --gpu --name eval
```

### Monitor
```bash
squeue -u team04                    # Check job status
ls -lt ~/logs/ | head -5           # Latest logs
tail -f ~/logs/YOUR_JOB_*.out      # Follow log
ls -lht ~/models/ | head -5        # Best models
```

### Troubleshoot
```bash
# Check dataset
ls /shared/hackathon/datasets/xray_fl_datasets_preprocessed_128/

# Check GPU
nvidia-smi

# Cancel job
scancel JOB_ID

# View full log
cat ~/logs/YOUR_JOB_*.out
```

---

## ⏰ Timeline

| Time | Action | Duration |
|------|--------|----------|
| **Now** | Installation completing | 5 min |
| **+5 min** | Quick test | 5-10 min |
| **+15 min** | Review test results | 2 min |
| **+17 min** | Submit full training | 20 min |
| **+37 min** | Training completes | - |
| **+40 min** | Evaluate best model | 5 min |
| **+45 min** | Review & submit | 5 min |

**Total**: ~50 minutes
**Deadline**: Saturday 15:30

---

## 🐛 Common Issues & Fixes

### Issue: Job fails immediately
**Check**:
```bash
tail -50 ~/logs/YOUR_JOB_*.out
```
**Fix**: Look for error messages, usually missing dependencies or config issues

### Issue: Out of memory
**Fix**:
```toml
image-size = 128  # Reduce from 224
```

### Issue: Job timeout at 20 minutes
**Fix**:
```toml
num-server-rounds = 15  # Reduce from 20+
```

### Issue: Low AUROC (<0.70)
**Possible causes**:
- Too few rounds
- Learning rate too high/low
- Check if all 3 hospitals are participating

**Fix**:
```bash
# Check logs for all hospitals training
grep "Hospital" ~/logs/YOUR_JOB_*.out
```

---

## 📝 Notes for Final Submission

1. **Model file naming**: Best model is auto-saved as `{run_name}_round{N}_auroc{XXXX}.pt`
2. **Evaluation format**: Use the provided `evaluate.py` script
3. **W&B dashboard**: Check https://wandb.ai/coldstart2025-team04/coldstart2025 (if configured)
4. **Models location**: `~/models/` on server, auto-copied after job completes

---

## ✅ Final Checklist Before Submission

- [ ] Training completed without errors
- [ ] Best model AUROC > 0.70
- [ ] All 3 hospitals participated in training
- [ ] Evaluation script runs successfully
- [ ] Model saved in `~/models/`
- [ ] Logs show no warnings/errors
- [ ] Results documented

---

**Ready to go! Start with Phase 1 (Quick Test) to verify everything works!** 🚀
