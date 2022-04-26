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
plt.savefig("../figures/r2.tiff")


# %%
plt.figure(figsize=(5, 5))
x = df_r2_pce["eval"]
y = df_r2_pce["order_2"]
# plt.subplot(2, 1, 1)
plt.plot(x, y, "ko")
plt.xlabel("pce prediction")
plt.ylabel("test values")

# %%
plt.figure(figsize=(5, 5))
plt.xlabel("pce prediction")
plt.ylabel("test values")
x = df_r2_lars_50.YLARS
y = df_r2_lars_50.Yval

plt.plot(x, y, "ko")

# %%
