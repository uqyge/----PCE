#%%
import matplotlib.pyplot as plt
import numpy as np
import scipy.io as sio
import pandas as pd
import plotly.express as px
import scipy.stats as stats
from scipy.special import rel_entr, kl_div


def cm_to_inch(value):
    return value / 2.54


# %%
df_sobol = pd.read_csv("../outputs/sobolIndex.csv")
df_sobol.head()
# %%
df_sobol.sort_values(by="FirstOrder", ascending=False)[:12].plot.bar()
#%%
# plt.figure(figsize=(cm_to_inch(8), cm_to_inch(6)), dpi=600)
plt.rc("font", family="Times New Roman")
plt.rc("font", size=8)
plt.rc("lines", linewidth=0.5)

df_sobol_sort = df_sobol.sort_values(by="FirstOrder", ascending=False)[:12]
labels = df_sobol_sort.index
x = np.arange(len(labels))
width = 0.4

fig, ax = plt.subplots(figsize=(cm_to_inch(8), cm_to_inch(6)), dpi=600)

rects1 = ax.bar(x - width / 2, df_sobol_sort.FirstOrder, width, edgecolor="k")
rects2 = ax.bar(x + width / 2, df_sobol_sort.TotalOrder, width, edgecolor="k")
ax.set_xticks(x)
ax.set_xticklabels(labels + 1)
ax.set_xlabel("cable number")
ax.set_ylabel("sensitivity indexes")
ax.legend(["first order", "total order"], frameon=False)
fig.tight_layout()
fig.savefig("../figures/sobolIndex.tiff")

#%%
