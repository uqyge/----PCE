#%%
import numpy as np
import matplotlib.pyplot as plt
import pandas as pd


def cm_to_inch(value):
    return value / 2.54


# %%
df_opt = pd.read_csv("../outputs/y_opt.csv")
df_opt.head()
#%%
df_fem_1 = pd.read_csv("../outputs/fem_opt_1.csv")
df_fem_1.head()

#%%
df_fem_2 = pd.read_csv("../outputs/fem_opt_2.csv")
df_fem_2.head()

# %%
data_cut = df_opt[df_opt.y_opt_1 > 0]["y_opt_1"]
data_abs = df_opt.y_opt_1.abs()
data_opt_2 = df_opt.y_opt_2
data_fem_1 = df_fem_1.d
data_fem_2 = df_fem_2.d
plt.hist(
    [data_fem_1, data_cut, data_abs],
    20,
    density=True,
    linewidth=1,
    edgecolor="k",
    align="mid",
    label=["fem", "cut", "abs"],
)
plt.legend()
# %%
plt.figure(figsize=(cm_to_inch(8), cm_to_inch(6)), dpi=600)
plt.rc("font", family="Times New Roman")
plt.rc("font", size=8)

plt.hist(
    data_fem_1,
    20,
    density=True,
    linewidth=1,
    edgecolor="k",
    align="mid",
    # label="FEM simulation",
)
# plt.legend()
plt.xlim([0, 15])
plt.ylabel("density")
plt.xlabel("distance /cm")
plt.tight_layout()
plt.savefig("../figures/fem_opt_1.tiff")  # %%

# %%
plt.figure(figsize=(cm_to_inch(8), cm_to_inch(6)), dpi=600)
plt.rc("font", family="Times New Roman")
plt.rc("font", size=8)

plt.hist(
    data_fem_2,
    20,
    density=True,
    linewidth=1,
    edgecolor="k",
    align="mid",
    # label="FEM simulation",
)

# plt.legend()
plt.xlim([0, 15])
plt.ylabel("density")
plt.xlabel("distance /cm")
plt.tight_layout()
plt.savefig("../figures/fem_opt_2.tiff")  # %%

# %%
sum(data_fem_1<10)
# %%
sum(data_fem_2<10)
# %%
