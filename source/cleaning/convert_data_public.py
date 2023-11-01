import pandas as pd

# Read in the data_public.txt file
df = pd.read_csv('../data/data_public.txt', delimiter='\t')

# Convert to CSV
df.to_csv('data_public.csv', index=False)

# Convert to DTA
df.to_stata('data_public.dta', write_index=False)
