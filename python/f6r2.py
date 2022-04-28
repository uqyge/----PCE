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
plt.figure(figsize=(5, 10))

plt.subplot(2, 1, 1)
x = df_r2_pce["eval"]
y = df_r2_pce["order_2"]
plt.plot(x, y, "ko", label="2nd order PCE")
plt.xlabel("pce prediction")
plt.ylabel("test values")
plt.legend()

plt.subplot(2, 1, 2)
x = df_r2_lars_50.YLARS
y = df_r2_lars_50.Yval
plt.plot(x, y, "ko", label="LARS")
plt.xlabel("pce prediction")
plt.ylabel("test values")
plt.legend()
plt.savefig("../figures/r2.png")


# %%
plt.figure(figsize=(cm_to_inch(7), cm_to_inch(7)), dpi=600)
plt.rc("font", family="Times New Roman")
plt.rc("font", size=8)
plt.xlabel("LARS prediction/cm")
plt.ylabel("FEM simulatons/cm")
x = df_r2_lars_50.YLARS
y = df_r2_lars_50.Yval

plt.plot(x, y, "ko", markersize=2)
plt.tight_layout()
plt.savefig("../figures/r2Lars.tiff")

# %%
plt.figure(figsize=(cm_to_inch(7), cm_to_inch(7)), dpi=600)
plt.rc("font", family="Times New Roman")
plt.rc("font", size=8)
plt.xlabel("2nd order PCE prediction/cm")
plt.ylabel("FEM simulatons/cm")

x = df_r2_pce["eval"]
y = df_r2_pce["order_2"]

plt.plot(x, y, "ko", markersize=2)
plt.tight_layout()
plt.savefig("../figures/r2pce.tiff")

# %%
