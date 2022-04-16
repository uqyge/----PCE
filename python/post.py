#%%
import matplotlib.pyplot as plt
import numpy as np
import scipy.io as sio
import pandas as pd
import plotly.express as px

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
df_err_pce = pd.read_csv("../outputs/errPCE.csv")
df_err_pce.head()
# %%

#%%
px.line(
    df_err_pce,
    x="iter",
    y=df_err_pce.columns.drop("iter"),
    # range_y=[0, 0.1],
    range_y=[1e-5,1e-1],
    log_y=True,
)
#%%
df_r2_pce = pd.read_csv('../outputs/r2PCE.csv')
# %%
px.scatter(df_r2_pce,x='eval',y=['order_1','order_2','order_3','order_4'])
# %%
