#%%
import numpy as np
import matplotlib.pyplot as plt
import scipy.stats as stats


def cm_to_inch(value):
    return value / 2.54


def relax(t, r, k):
    return r * (t / 1000) ** k


# %%
t = stats.uniform(0, 1000).rvs(100000)


plt.figure(figsize=(cm_to_inch(8), cm_to_inch(6)), dpi=600)
plt.rc("font", family="Times New Roman")
plt.rc("font", size=8)
plt.rc("lines", linewidth=0.5)

plt.hist(relax(t, 4, 0.12), 30, density=True, edgecolor="k")
plt.xlabel("relaxation/%")
plt.ylabel("density")

plt.tight_layout()
plt.savefig("../figures/doe.tiff")
# %%
