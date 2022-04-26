#%%
import matplotlib.pyplot as plt
import pandas as pd


plt.rcParams["figure.dpi"] = 600
plt.rcParams["savefig.dpi"] = 600
# plt.rcParams["font.sans-serif"] = ["SimSun"]
plt.rcParams["axes.unicode_minus"] = True

# %%
df_err_lars_25 = pd.read_csv("../outputs/errLars_qnorm_25_yid_36.csv")
df_err_lars_50 = pd.read_csv("../outputs/errLars_qnorm_50_yid_36.csv")
df_err_lars_75 = pd.read_csv("../outputs/errLars_qnorm_75_yid_36.csv")
df_err_lars_95 = pd.read_csv("../outputs/errLars_qnorm_95_yid_36.csv")
df_err_lars_50.head()
#%%
df_err_pce = pd.read_csv("../outputs/errPCE.csv")
df_err_pce.head()
# %%
plt.plot(df_err_lars_25.iter, df_err_lars_25.err_val, label="25_val")
plt.plot(df_err_lars_50.iter, df_err_lars_50.err_val, label="50_val")
# plt.plot(df_err_lars_50.iter, df_err_lars_50.err_loo)
plt.plot(df_err_lars_75.iter, df_err_lars_75.err_val, label="75_val")
plt.plot(df_err_lars_95.iter, df_err_lars_95.err_val, label="95_val")
plt.legend()

# %%
plt.semilogy(df_err_lars_50.iter, df_err_lars_50.err_val, "d-", label="LARS PCE")
# plt.semilogy(df_err_lars_25.iter, df_err_lars_25.err_val, "d-", label="25_val")
plt.semilogy(df_err_pce.iter, df_err_pce.err_var_1, "--^", label="1st order PCE")
plt.semilogy(df_err_pce.iter, df_err_pce.err_var_2, "--s", label="2nd order PCE")
plt.semilogy(df_err_pce.iter, df_err_pce.err_var_3, "--v", label="3rd order PCE")
plt.ylabel("error")
plt.xlabel("samples")
plt.legend()
plt.savefig("../figures/errhist.tiff")


# %%
