import argparse
import numpy as np
import matplotlib.pyplot as plt
import re

parser = argparse.ArgumentParser()
parser.add_argument('--file', type=str)
args = parser.parse_args()

with open(args.file) as f:
    lines = f.readlines()
lines = [x.strip() for x in lines]

n_rows = 10
n_cols = 10
lab = np.zeros((n_rows, n_cols))

def remove_chars(line):
    return re.sub(r'\(|\)|\.|\_|[a-z]', '', line)

for line in lines:
    if "colonne" in line:
        line = remove_chars(line)
        n_cols = int(line)+1
        lab = np.zeros((n_rows, n_cols))
    elif "righe" in line:
        line = remove_chars(line)
        n_rows = int(line)+1
        lab = np.zeros((n_rows, n_cols))
    elif "occupata" in line:
        line = remove_chars(line)
        x,y = list([int(n) for n in line.split(',')])
        lab[x,y] = 1
    elif "iniziale" in line:
        line = remove_chars(line)
        x,y = list([int(n) for n in line.split(',')])
        lab[x,y] = 2
    elif "finale" in line:
        line = remove_chars(line)
        x,y = list([int(n) for n in line.split(',')])
        lab[x,y] = 3

lab[0, :] = 4
lab[:, 0] = 4

print(lab)

fig = plt.figure(figsize=(20, 20))
ax = fig.add_subplot(1, 1, 1)

major_ticks = np.arange(0.5, 22, 1)

ax.set_xticks(major_ticks)
ax.set_yticks(major_ticks)

# And a corresponding grid
ax.grid(which='both')

# Or if you want different settings for the grids:
ax.grid(which='major', alpha=0.5)
plt.imshow(lab)
plt.savefig('img.png')    
