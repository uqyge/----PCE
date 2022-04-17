#%%
import matplotlib.pyplot as plt
import numpy as np
import scipy.io as sio
import pandas as pd
import plotly.express as px
import scipy.stats as stats
from scipy.special import rel_entr, kl_div

# %%
df_sobol = pd.read_csv("../outputs/sobolIndex.csv")
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
    range_y=[1e-5, 1e-1],
    log_y=True,
)
#%%
df_r2_pce = pd.read_csv("../outputs/r2PCE.csv")
# %%
px.scatter(df_r2_pce, x="eval", y=["order_1", "order_2", "order_3", "order_4"])
# %%
df_mle_lars = pd.read_csv("../outputs/y_opt.csv")
df_mle_lars.head()
# %%
y = df_mle_lars.y
plt.hist(y, density=True)
xt = plt.xticks()[0]
x_l, x_u = min(xt), max(xt)
x_test = np.linspace(x_l, x_u, 100)
# %%
a = plt.hist(y, 50, density=True)
y_kl = a[0]
x_kl = a[1][:-1]
m, s = stats.norm.fit(y)
pdf_g = stats.norm.pdf(x_test, m, s)
d_kl = sum(kl_div(y_kl, stats.norm.pdf(x_kl, m, s)))
plt.plot(x_test, pdf_g, label=f"Gaussian {d_kl=}")

ag, bg, cg = stats.gamma.fit(y)
pdf_gamma = stats.gamma.pdf(x_test, ag, bg, cg)
d_kl = sum(kl_div(y_kl, stats.gamma.pdf(x_kl, ag, bg, cg)))
plt.plot(x_test, pdf_gamma, label=f"Gamma {d_kl=}")


# guess what :)
# ab, bb, cb, db = stats.beta.fit(y)
# pdf_beta = stats.beta.pdf(x_test, ab, bb, cb, db)
# plt.plot(x_test, pdf_beta, label="Beta")

# a, b, c = stats.lognorm.fit(y)
# pdf_lognorm = stats.lognorm.pdf(x_test, a, b, c)
# plt.plot(x_test, pdf_lognorm, label="lognorm")

m, s = stats.logistic.fit(y)
pdf_g = stats.logistic.pdf(x_test, m, s)
d_kl = sum(kl_div(y_kl, stats.logistic.pdf(x_kl, m, s)))
plt.plot(x_test, pdf_g, label=f"logistic {d_kl=}")
plt.legend()
# %%


# %%
def reliablity(y_rel):
    return sum((y_rel > 50) & (y_rel < 60)) / len(y_rel)


# %%
rel_org = reliablity(df_mle_lars.y)
rel_opt_1 = reliablity(df_mle_lars.y_opt_1)
rel_opt_2 = reliablity(df_mle_lars.y_opt_2)

print(f"{rel_org=}")
print(f"{rel_opt_1=}")
print(f"{rel_opt_2=}")
# %%
