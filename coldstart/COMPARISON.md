# Comparison: Custom Implementation vs Official Template

## Summary

You now have **TWO implementations** in your project:

1. **Custom Implementation** (in parent directory) - What we built from scratch
2. **Official Template** (in `coldstart/`) - From `flwr new @hackathon/coldstart`

**RECOMMENDATION: Use the official template (`coldstart/`)** - it's better integrated with the hackathon infrastructure!

---

## Key Differences

| Aspect | Custom Implementation | **Official Template** ⭐ |
|--------|----------------------|------------------------|
| **Location** | `../` | `coldstart/` |
| **Model** | EfficientNet B0 | ResNet18 → **Modified to EfficientNet B0** |
| **Flower Version** | 1.6.0 → 1.23.0 | **1.23.0 (latest)** |
| **API Style** | Old NumPyClient | **New ServerApp/ClientApp** |
| **Configuration** | YAML files | **pyproject.toml** (Flower standard) |
| **Dataset Path** | `~/xray-data` (incorrect!) | **`/shared/hackathon/datasets/`** (correct!) |
| **Data Format** | Raw images | **Preprocessed HuggingFace datasets** |
| **Job Submission** | Custom scripts | **`./submit-job.sh` + `flwr run`** |
| **W&B Integration** | Manual setup | **Built-in logging** |
| **Model Saving** | Manual | **Automatic best model tracking** |
| **Evaluation** | Custom script | **Official eval script** |
| **Resource Limits** | 15 min assumption | **20 minutes** (correct!) |

---

## What We Learned from Our Custom Implementation

Our custom implementation was valuable for learning but had several incorrect assumptions:

### ❌ Incorrect Assumptions

1. **Dataset Location**
   - We thought: `~/xray-data`
   - Actually: `/shared/hackathon/datasets/xray_fl_datasets_preprocessed_128/`

2. **Data Format**
   - We thought: Raw PNG images + CSV metadata
   - Actually: Preprocessed HuggingFace datasets (already split by hospital)

3. **Time Limit**
   - We thought: 15 minutes
   - Actually: **20 minutes**

4. **Job Submission**
   - We thought: `python run_simulation.py` or `~/submit-job.sh`
   - Actually: `./submit-job.sh "flwr run . cluster --stream" --gpu`

5. **Flower API**
   - We used: Old `fl.client.NumPyClient` API (Flower 1.6.0)
   - Should use: New `ServerApp`/`ClientApp` decorators (Flower 1.23.0)

### ✅ What We Got Right

1. **Model Choice** - EfficientNet B0 is a good choice!
2. **Binary Classification** - Correct task understanding
3. **Federated Learning Concept** - 3 hospitals, FedAvg
4. **Pretrained Weights** - Good idea for better performance
5. **Dropout Regularization** - Helps with generalization
6. **AUROC Metric** - Correct evaluation metric

---

## Why Use the Official Template?

### 1. **Correct Infrastructure Integration**
- Uses the actual dataset paths on the cluster
- Compatible with the job submission system
- Works with their W&B setup

### 2. **Better Flower API (1.23.0)**
```python
# Old API (our custom implementation)
class ChestXRayClient(fl.client.NumPyClient):
    def fit(self, parameters, config):
        # Manual parameter handling
        pass

# New API (official template) ⭐
@app.train()
def train(msg: Message, context: Context):
    # Cleaner, more powerful
    pass
```

### 3. **Preprocessed Data**
- Images already resized (128x128 or 224x224)
- Already split by hospital
- HuggingFace datasets format
- Much faster loading!

### 4. **Automatic Logging & Model Saving**
- Best models automatically saved with AUROC in filename
- W&B integration built-in
- Metrics logged per hospital and aggregated

### 5. **Official Evaluation**
- Their eval script expects specific model format
- Easier for organizers to evaluate your submission

---

## Migration Guide

If you want to incorporate ideas from our custom implementation into the official template:

### Use EfficientNet B0 (Already Done! ✅)
File: `coldstart/cold_start_hackathon/task.py`

We already modified the `Net` class to use EfficientNet B0 with:
- ImageNet pretrained weights
- Grayscale adaptation
- Binary classification head
- Dropout (0.3) for regularization

### Adjust Hyperparameters
File: `coldstart/pyproject.toml`

```toml
[tool.flwr.app.config]
image-size = 128        # Start with 128 for speed
num-server-rounds = 20  # Reduce from 100 for 20-min limit
local-epochs = 1        # Or 2 for more local training
lr = 0.001              # Lower LR for pretrained model
```

### Add Custom Data Augmentation (Optional)
File: `coldstart/cold_start_hackathon/task.py`

The official template uses preprocessed data without augmentation. If you want to add it:

```python
# Add to train() function in task.py
transform = transforms.Compose([
    transforms.RandomHorizontalFlip(p=0.5),
    transforms.RandomRotation(10),
    # ... more augmentations
])
```

But note: Preprocessed datasets might not support transforms easily.

---

## Recommended Workflow

### For the Hackathon (Use Official Template)

1. **Navigate to template**
   ```bash
   cd coldstart/
   ```

2. **Upload to server**
   ```bash
   scp -P 32605 -r coldstart team04@129.212.178.168:~/
   ```

3. **Follow TEAM04_SETUP.md** (in coldstart/ directory)

4. **Tune hyperparameters in pyproject.toml**

5. **Submit and monitor**

### For Learning (Custom Implementation)

The custom implementation in the parent directory is still valuable for:
- Understanding federated learning concepts
- Learning Flower API basics
- Experimentation with different architectures
- Local development and testing

But **don't use it for the hackathon submission** - the dataset paths won't match!

---

## File Structure Overview

```
distributed-ai-hack-berlin/
├── coldstart/                          ⭐ USE THIS FOR HACKATHON
│   ├── cold_start_hackathon/
│   │   ├── task.py                    ✅ Modified: EfficientNet B0
│   │   ├── client_app.py
│   │   ├── server_app.py
│   │   └── util.py
│   ├── pyproject.toml                 ⚙️ Configuration
│   ├── evaluate.py                    📊 Final evaluation
│   ├── README.md                      📖 Official docs
│   ├── TEAM04_SETUP.md               🚀 Your setup guide
│   └── COMPARISON.md                  📋 This file
│
└── (parent directory)                  ℹ️ Custom implementation
    ├── models/
    ├── utils/
    ├── clients/
    ├── server/
    ├── configs/
    ├── run_simulation.py
    ├── QUICK_START_SERVER.md
    └── ... (other custom files)
```

---

## Quick Decision Matrix

| If you want to... | Use... |
|-------------------|--------|
| **Submit to hackathon** | Official template (`coldstart/`) |
| **Get best AUROC** | Official template with EfficientNet B0 (done!) |
| **Understand FL concepts** | Either (both are valid) |
| **Work on actual server** | Official template (correct paths) |
| **Experiment locally** | Custom implementation (more flexible) |
| **Meet evaluation requirements** | Official template (compatible eval) |

---

## Bottom Line

**🎯 For the hackathon: Use `coldstart/` directory with our EfficientNet B0 modification!**

It has:
- ✅ Correct dataset paths
- ✅ Modern Flower 1.23.0 API
- ✅ Built-in W&B logging
- ✅ Automatic model saving
- ✅ Official evaluation script
- ✅ **EfficientNet B0** (your requested model)
- ✅ Pretrained weights
- ✅ Dropout regularization

Everything you need to succeed! 🚀

---

**Next Step:** Follow `TEAM04_SETUP.md` to get started!
