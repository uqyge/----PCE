#%%
import matplotlib.pyplot as plt
import pandas as pd
import plotly.express as px
import scipy.io as sio
import scipy.stats as stats
from scipy.special import kl_div, rel_entr

font_options = {
    "family": "serif",  # 设置字体家族
    "serif": "simsun",  # 设置字体
}
plt.rc("font", **font_options)
# plt.rcParams["font.family"] = ["sans-serif","serif"]
# plt.rcParams["font.sans-serif"] = [
#     "Segoe UI Symbol",
#     "simHei",
#     "Arial",
#     "sans-serif",
#     "simsum",
# ]
plt.rcParams["figure.dpi"] = 600
plt.rcParams["savefig.dpi"] = 600


# %%
df_err_lars_25 = pd.read_csv("../outputs/errLars_qnorm_25_yid_36.csv")
df_err_lars_50 = pd.read_csv("../outputs/errLars_qnorm_50_yid_36.csv")
df_err_lars_75 = pd.read_csv("../outputs/errLars_qnorm_75_yid_36.csv")
df_err_lars_95 = pd.read_csv("../outputs/errLars_qnorm_95_yid_36.csv")
df_err_lars_50.head()
# %%
plt.plot(df_err_lars_25.iter, df_err_lars_25.err_val, label="25_val")
plt.plot(df_err_lars_50.iter, df_err_lars_50.err_val, label="50_val")
# plt.plot(df_err_lars_50.iter, df_err_lars_50.err_loo)
plt.plot(df_err_lars_75.iter, df_err_lars_75.err_val, label="75_val")
plt.plot(df_err_lars_95.iter, df_err_lars_95.err_val, label="95_val")
plt.legend()
#%%
df_err_pce = pd.read_csv("../outputs/errPCE.csv")
df_err_pce
# %%
px.line(df_err_pce, x="iter", y=["err_var_1", "err_var_2", "err_var_3"], log_y=True)

# %%
# plt.semilogy(df_err_lars_50.iter, df_err_lars_50.err_val, "d-", label="50_val")
plt.semilogy(df_err_lars_25.iter, df_err_lars_25.err_val, "d-", label="25_val")
plt.semilogy(df_err_pce.iter, df_err_pce.err_var_1, "--^", label="pce 1")
plt.semilogy(df_err_pce.iter, df_err_pce.err_var_2, "--s", label="pce 2")
plt.semilogy(df_err_pce.iter, df_err_pce.err_var_3, "--v", label="pce 3")
plt.ylabel("mae")
plt.xlabel("No. Samples")
plt.legend()
# %%
