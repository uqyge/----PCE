#%%
import matplotlib.pyplot as plt
import pandas as pd


plt.rcParams["figure.dpi"] = 600
plt.rcParams["savefig.dpi"] = 600
# plt.rcParams["font.sans-serif"] = ["SimSun"]
plt.rcParams["axes.unicode_minus"] = True


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
plt.hist(
    [evl, pred],
    18,
    density=True,
    label=["test samples", "LARS prediction"],
    histtype="bar",
    linewidth=1,
    # hatch=["//",''],
    edgecolor="k",
    align="mid",
    # color=["k", "w"],
)
plt.xlabel("distance[cm]")
plt.legend()
plt.savefig("../figures/histCmp.tiff")

# %%
df_r2_pce.head()
# %%
