# Radiology-AI Collaboration
This repository contains the code for the figures and tables generated during the "A Dataset for Understanding Radiologist - Artificial Intelligence Collaboration" paper.

### Requirements:
- Stata (Stata 17 was used)
- Python 3. Packages include `pandas`.

### Steps for running the repository.

1. Download the data from LINK OSF, and place the data in the `source/data` folder.
2. Run `convert_data_public.py` followed by `clean.do`. Cleaned files are saved to `source/data`.
3. Run code to generate figures and tables in paper. Files are under `source/figures` and `source/tables`.

All the non-data output is contained in the `output` folder. The LaTeX document was originally generated in Overleaf and is saved under `paper`.

### Questions:

If you run into issues or errors, please submit an issue in this repository or email moehring@mit.edu and rayhuang@mitblueprintlabs.edu.
