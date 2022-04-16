#%%
import matplotlib.pyplot as plt
import numpy as np
import scipy.io as sio
import pandas as pd

# %%
df_sobol = pd.read_csv("../sobolIndex.csv")
# %%
df_sobol.plot.bar()

# %%
df_err_lars = pd.read_csv("../outputs/errLars.csv")

# %%
plt.plot(df_err_lars.iter, df_err_lars.err_val)
plt.plot(df_err_lars.iter, df_err_lars.err_loo)
# %%
plt.semilogy(df_err_lars.iter, df_err_lars.err_val)
plt.semilogy(df_err_lars.iter, df_err_lars.err_loo)
# %%
df_err_pce = pd.read_csv("../outputs/errPCE_6.csv")
df_err_pce = df_err_pce[df_err_pce.err_val < 1]
# %%
plt.plot(df_err_pce.iter, df_err_pce.err_val)
plt.plot(df_err_pce.iter, df_err_pce.err_loo)
plt.plot(df_err_lars.iter, df_err_lars.err_val)
plt.plot(df_err_lars.iter, df_err_lars.err_loo)

# %%
plt.semilogy(df_err_pce.iter, df_err_pce.err_val)
plt.semilogy(df_err_pce.iter, df_err_pce.err_loo)
plt.semilogy(df_err_lars.iter, df_err_lars.err_val)
plt.semilogy(df_err_lars.iter, df_err_lars.err_loo)

# %%
