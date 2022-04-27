#%%
import matplotlib.pyplot as plt
import numpy as np
import scipy.io as sio
import pandas as pd
import plotly.express as px
import scipy.stats as stats
from scipy.special import rel_entr, kl_div

plt.rcParams["figure.dpi"] = 600
plt.rcParams["savefig.dpi"] = 600

# %%
df_sobol = pd.read_csv("../outputs/sobolIndex.csv")
df_sobol.head()
# %%
df_sobol.sort_values(by="FirstOrder", ascending=False)[:12].plot.bar()
#%%
df_sobol_sort = df_sobol.sort_values(by="FirstOrder", ascending=False)[:12]
labels = df_sobol_sort.index
x = np.arange(len(labels))
width = 0.4
plt.figure(figsize=(5, 5))
fig, ax = plt.subplots()
rects1 = ax.bar(x - width / 2, df_sobol_sort.FirstOrder, width, edgecolor="k")
# rects2 = ax.bar(x + width / 2, df_sobol_sort.TotalOrder, width, color="k")
rects2 = ax.bar(x + width / 2, df_sobol_sort.TotalOrder, width, edgecolor="k")
ax.set_xticks(x)
ax.set_xticklabels(labels)
ax.set_xlabel("cable number")
ax.legend(["first order", "total order"])
fig.savefig("../figures/sobolIndex.tiff")

#%%
