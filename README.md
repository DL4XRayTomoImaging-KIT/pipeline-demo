# Demonstration of the Pipeline Work

This repository hosts demonstration of the workflow with the pipeline on a very simple example.
The script will:

1. Select a very small subset (4 volumes) of the Medaka samples from LSDF, downsample it in size and color space (with conversion to uint8).
2. Process it with a small model to segment brain areas.
3. Clean those segmentations to remove small disconnected areas.
4. Calculate some morphological metrics and write them down to TinyDB database.

## Pre-Requisits

I expect you to have:

1. Have python3 at `/usr/bin/python3`. If it's not the case, modify line 3 of the `run_medaka_test.sh` file.
2. LSDF mounted at `/mnt/LSDF`. If it's not the case, modify line 2 of the `medaka_52.yaml` file.
3. GPUs available and CUDA-11.6 installed. If the CUDA version differs, you will need to modify requirements of the training-repo or re-install PyTorch manually.
4. Around 110GB of free space in the folder where the script runs (after first interaction with the LSDF all processing is done locally)
5. Have around 160GB of RAM free. If it's not the case, modify line 12 of the `run_medaka_test.sh` file to change `--multithread` to 1.

## How To Run

```
git clone git@github.com:DL4XRayTomoImaging-KIT/pipeline-demo.git
cd pipeline-demo
bash run_medaka_test.sh
```
