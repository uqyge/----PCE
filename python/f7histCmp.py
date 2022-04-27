#%%
import matplotlib.pyplot as plt
import pandas as pd


def cm_to_inch(value):
    return value / 2.54


# %%
df_r2_lars_25 = pd.read_csv("../outputs/r2Lars_qnorm_25_yid_36.csv")
df_r2_lars_50 = pd.read_csv("../outputs/r2Lars_qnorm_50_yid_36.csv")
df_r2_lars_75 = pd.read_csv("../outputs/r2Lars_qnorm_75_yid_36.csv")
df_r2_lars_95 = pd.read_csv("../outputs/r2Lars_qnorm_95_yid_36.csv")
df_r2_lars_50.head()
#%%
df_r2_pce = pd.read_csv("../outputs/r2PCE.csv")
df_r2_pce.head()

#%%


# %%
pred = df_r2_lars_50.YLARS
# pred = df_r2_pce.order_2
evl = df_r2_lars_50.Yval

plt.figure(figsize=(cm_to_inch(8), cm_to_inch(6)), dpi=600)
plt.rc("font", family="Times New Roman")
plt.rc("font", size=8)
plt.rcParams["font.sans-serif"] = "Times"

plt.hist(
    [evl, pred],
    18,
    density=True,
    label=["FEM", "LARS"],
    histtype="bar",
    linewidth=1,
    # hatch=["//",''],
    edgecolor="k",
    align="mid",
    # color=["k", "w"],
)
plt.ylabel("density")
plt.xlabel("distance/cm")
plt.legend(frameon=False)
plt.tight_layout()
plt.savefig("../figures/histCmp.tiff")

# %%
df_r2_pce.head()
# %%
