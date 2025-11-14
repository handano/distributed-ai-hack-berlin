#!/bin/bash
# Quick Test Submission Script - Run this on the server
# Copy this to the server or run the commands directly

set -e

echo "=============================================="
echo "Team04 - Quick Test Submission"
echo "EfficientNet B0 - 5 Rounds"
echo "=============================================="

cd ~/distributed-ai-hack-berlin/coldstart
source ~/hackathon-venv/bin/activate
export DATASET_DIR=~/xray-data

echo ""
echo "✓ Environment activated"
echo "✓ Dataset: $DATASET_DIR"
echo ""

# Verify dataset exists
if [ ! -d "$DATASET_DIR/xray_fl_datasets_preprocessed_128" ]; then
    echo "ERROR: Dataset not found at $DATASET_DIR/xray_fl_datasets_preprocessed_128"
    exit 1
fi

echo "✓ Dataset verified"
echo ""
echo "Current config:"
grep -A 5 "tool.flwr.app.config" pyproject.toml
echo ""

# Submit job in background
echo "Submitting quick test job..."
nohup flwr run . local-simulation --stream > ~/quick_test.log 2>&1 &
JOB_PID=$!
echo $JOB_PID > ~/quick_test.pid

echo ""
echo "=============================================="
echo "✓ Job submitted successfully!"
echo "  PID: $JOB_PID"
echo "  Log: ~/quick_test.log"
echo "=============================================="
echo ""
echo "Monitor with:"
echo "  tail -f ~/quick_test.log"
echo ""
echo "Check status with:"
echo "  ps -p $(cat ~/quick_test.pid)"
echo ""

# Show initial output
sleep 3
echo "=== Initial output ==="
head -20 ~/quick_test.log

echo ""
echo "Training started! This will take 5-10 minutes."
echo "Use 'tail -f ~/quick_test.log' to monitor progress."
