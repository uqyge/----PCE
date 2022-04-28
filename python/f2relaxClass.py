#%%
import matplotlib.pyplot as plt
import numpy as np


def cm_to_inch(value):
    return value / 2.54


def c1(x):
    x1, y1 = 0.1, 4
    x2, y2 = 0.3, 11
    return (y2 - y1) * (x - x1) / (x2 - x1) + y1


def c2(x):
    k, h = 1.2, 0.1
    a = 50
    return a * (x - h) ** 2 + k


def c3(x):
    k, h = 2, 0.1
    a = 100
    return a * (x - h) ** 2 + k


# %%
x = np.linspace(0.1, 0.3, 100)

plt.rc("font", family="Times New Roman")
plt.rc("font", size=8)
plt.rc("lines", linewidth=0.5)

plt.figure(figsize=(cm_to_inch(8), cm_to_inch(6)), dpi=600)


plt.xlim([0, 0.33])
plt.ylim([0, 12])
plt.plot(x, c1(x), "k", linewidth=0.75)
plt.plot(x, c2(x), "k", linewidth=0.75)
plt.plot(x, c3(x), "k", linewidth=0.75)
plt.plot(np.ones(10) * 0.1, np.linspace(0, 12, 10), "k--")
plt.plot(np.ones(10) * 0.2, np.linspace(0, 12, 10), "k--")
plt.plot(np.ones(10) * 0.3, np.linspace(0, 12, 10), "k--")
plt.xticks([0, 0.1, 0.2, 0.3], [0, 0.6, 0.7, 0.8], fontsize=8)
plt.yticks([2, 4, 6, 8, 10], [2, 4, 6, 8, 10], fontsize=8)
plt.ylabel(r"$\rho_{1000}$/%", fontsize=8)
plt.xlabel("$\sigma_{po}$/$f_{ptk}$", fontsize=8)

plt.annotate("Class 1", xy=(0.23, 10.5), fontsize=8)
plt.annotate("Class 2", xy=(0.23, 5.5), fontsize=8)
plt.annotate("Class 3", xy=(0.23, 3), fontsize=8)

plt.tight_layout()
plt.savefig("../figures/class.tiff", facecolor="w")

# plt.savefig("../figures/class.png")
#%%
