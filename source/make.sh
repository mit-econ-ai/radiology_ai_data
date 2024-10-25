#!/bin/bash

# Create output folders
mkdir -p output/figures
mkdir -p output/tables
mkdir -p source/data

echo "Running cleaning scripts..."
python3 cleaning/convert_data_public.py
stata -b cleaning/clean.do

echo "Creating figures..."
ipython figures/post_survey.ipynb

echo "All scripts executed!"

