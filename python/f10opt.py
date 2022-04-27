#%%
import numpy as np
import matplotlib.pyplot as plt
import pandas as pd

plt.rcParams["figure.dpi"] = 600
plt.rcParams["savefig.dpi"] = 600
# plt.rcParams["font.sans-serif"] = ["SimSun"]
plt.rcParams["axes.unicode_minus"] = True

# %%
df_opt = pd.read_csv("../outputs/y_opt.csv")
df_opt.head()
# %%
#%%
data = df_opt.y
plt.hist(
    data,
    20,
    density=True,
    linewidth=1,
    edgecolor="k",
    align="mid",
)

# %%
data = df_opt.y_opt_1.abs()
plt.hist(
    data,
    20,
    density=True,
    linewidth=1,
    edgecolor="k",
    align="mid",
)

# %%
data = df_opt.y_opt_2
plt.hist(
    data,
    20,
    density=True,
    linewidth=1,
    edgecolor="k",
    align="mid",
)
#%%
df_opt.y_opt_1.abs()
# %%
df_fem = pd.read_csv("../opt.csv")
# %%
df_fem.head()
# %%
data = df_fem.d
plt.hist(
    data,
    20,
    density=True,
    linewidth=1,
    edgecolor="k",
    align="mid",
)

# %%
data_cut = df_opt[df_opt.y_opt_1 > 0]["y_opt_1"]
data_abs = df_opt.y_opt_1.abs()
data_opt_2 = df_opt.y_opt_2
data_fem = df_fem.d
plt.hist(
    # [data_fem.sample(1000), data_cut.sample(1000), data_abs.sample(1000)],
    [data_fem, data_cut, data_abs],
    20,
    density=True,
    linewidth=1,
    edgecolor="k",
    align="mid",
    label=["fem", "cut", "abs"],
)
plt.legend()
# %%
plt.hist(
    data_fem,
    20,
    density=True,
    linewidth=1,
    edgecolor="k",
    align="mid",
    label="FEM simulation",
)
plt.legend()

# %%
plt.hist(
    data_cut,
    20,
    density=True,
    linewidth=1,
    edgecolor="k",
    align="mid",
    label="LARS prediction",
)
plt.legend()

# %%
plt.hist(
    data_opt_2,
    20,
    density=True,
    linewidth=1,
    edgecolor="k",
    align="mid",
    label="LARS prediction",
)
plt.legend()
plt.xlabel("distance /cm")
plt.savefig("../figures/opt.tiff")
# %%
plt.figure(figsize=(5, 13))
plt.subplot(3, 1, 1)
plt.hist(
    data_opt_2,
    20,
    density=True,
    linewidth=1,
    edgecolor="k",
    align="mid",
    label="LARS prediction",
)
plt.legend()
plt.xlabel("distance /cm")

plt.subplot(3, 1, 2)
plt.hist(
    data_cut,
    20,
    density=True,
    linewidth=1,
    edgecolor="k",
    align="mid",
    label="LARS prediction",
)
plt.legend()
plt.xlabel("distance /cm")

plt.subplot(3, 1, 3)
plt.hist(
    data_fem,
    20,
    density=True,
    linewidth=1,
    edgecolor="k",
    align="mid",
    label="FEM simulation",
)
plt.legend()
plt.xlabel("distance /cm")
plt.savefig("../figures/opt.tiff")
# %%
plt.hist(
    [data_fem, data_cut],
    20,
    density=True,
    linewidth=1,
    edgecolor="k",
    align="mid",
    label="FEM simulation",
)

# %%
