# Radiology-AI Collaboration
This repository contains the code for the figures and tables generated during the "A Dataset for Understanding Radiologist - Artificial Intelligence Collaboration" paper.

Abstract:
This dataset provides a unique resource to study human-AI collaboration in chest X-ray interpretation. We present experimentally generated data from 227 professional radiologists who assessed 324 historical cases under varying information conditions: with and without AI assistance, and with and without clinical history. Using a custom-designed interface, we collected probabilistic assessments for 104 thoracic pathologies using a comprehensive hierarchical reporting structure. This dataset is the largest known comparison of human-AI collaborative performance to either AI or humans alone in radiology, offering assessments across an extensive range of pathologies with rich metadata on radiologist characteristics and decision-making processes. Multiple experimental designs enable both within-subject and between-subject analyses. Researchers can leverage this dataset to investigate how radiologists incorporate AI assistance, factors influencing collaborative effectiveness, and impacts on diagnostic accuracy, speed, and confidence across different cases and pathologies. By enabling rigorous study of human-AI integration in clinical workflows, this dataset can inform AI tool development, implementation strategies, and ultimately improve patient care through optimized collaboration in medical imaging.

## Steps for running the repository.

1. Download & unzip the radiology experiment data (titled "A Dataset for Understanding Radiologist - Artificial Intelligence Collaboration") from the Open Science Framework (OSF). Store and unzip in the `source/data` folder.
2. Run `make.sh` in terminal.
3. To run the code associated with the summary statistics table, please see the replication package associated with "Combining human expertise with artificial intelligence: Experimental evidence from radiology" (Agarwal, Moehring, Rajpurkar, Salz (2023)). The output required to create the summary statistics is saved in `output/tables`.

All the non-data output is contained in the `output` folder. 

**Requirements:** Stata 17 and Python 3.

# Contact 
If you run into issues or errors, please submit an issue in this repository or email moehring@mit.edu and rayhuang@mitblueprintlabs.edu.
