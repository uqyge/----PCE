#%%
import matplotlib.pyplot as plt
import numpy as np
import scipy.io as sio
import pandas as pd
import plotly.express as px
import scipy.stats as stats
from scipy.special import rel_entr, kl_div


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
plt.rcParams["figure.dpi"] = 300
plt.rcParams["savefig.dpi"] = 300


# %%
df_sobol = pd.read_csv("../outputs/sobolIndex.csv")
df_sobol.head()
# %%
df_sobol.sort_values(by="FirstOrder", ascending=False)[:12].plot.bar()
#%%
df_sobol_sort = df_sobol.sort_values(by="FirstOrder", ascending=False)[:12]
labels = df_sobol_sort.index
x = np.arange(len(labels))
width = 0.4

fig, ax = plt.subplots()
rects1 = ax.bar(
    x - width / 2, df_sobol_sort.FirstOrder, width, hatch="//", color="w", edgecolor="k"
)
rects2 = ax.bar(x + width / 2, df_sobol_sort.TotalOrder, width, color="k")
ax.set_xticks(x)
ax.set_xticklabels(labels)
ax.set_xlabel("cable number")
ax.legend(["first order", "total order"])
fig.savefig("sobolIndex.tiff")

# %%
df_err_lars = pd.read_csv("../outputs/errLars.csv")
df_err_lars.head()
# %%
plt.plot(df_err_lars.iter, df_err_lars.err_val)
plt.plot(df_err_lars.iter, df_err_lars.err_loo)

# %%
df_err_pce = pd.read_csv("../outputs/errPCE.csv")
df_err_pce.head()

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
x, y = df_err_pce[df_err_pce.err_var_1 < 1][["iter", "err_var_1"]].values.T
plt.semilogy(x, y, "k--d", label="pce 1阶")
x, y = df_err_pce[df_err_pce.err_var_2 < 1][["iter", "err_var_2"]].values.T
plt.semilogy(x, y, "k--^", label="2")
x, y = df_err_pce[df_err_pce.err_var_6 < 1][["iter", "err_var_6"]].values.T
plt.semilogy(x, y, "k--s", label="6")
x, y = df_err_lars[["iter", "err_val"]].values.T
plt.semilogy(x, y, "k-.o", label="lars")
plt.ylim([1.5e-5, 0.5])
plt.legend()
plt.savefig("errHistory.tiff")

#%%
df_r2_pce = pd.read_csv("../outputs/r2PCE.csv")
# %%
px.scatter(df_r2_pce, x="eval", y=["order_1", "order_2", "order_3", "order_4"])
# %%
# df_mle_lars = pd.read_csv("../outputs/y_opt.csv")
df_mle_lars = pd.read_csv("../outputs/r2Lars.csv")
df_mle_lars.head()
# %%
y = df_mle_lars.y
plt.hist(y, density=True, label="histogram")
xt = plt.xticks()[0]
x_l, x_u = min(xt), max(xt)
x_test = np.linspace(x_l, x_u, 100)
# %%
hist = plt.hist(
    y,
    20,
    density=True,
    label="histogram",
    histtype="bar",
    linewidth=1,
    hatch="//",
    edgecolor="k",
    align="mid",
    color="w",
)

y_kl = hist[0]
x_kl = hist[1][:-1]
m, s = stats.norm.fit(y)
pdf_g = stats.norm.pdf(x_test, m, s)
d_kl = sum(kl_div(y_kl, stats.norm.pdf(x_kl, m, s)))
# plt.plot(x_test, pdf_g, label=f"Gaussian {d_kl=}")

ag, bg, cg = stats.gamma.fit(y)
pdf_gamma = stats.gamma.pdf(x_test, ag, bg, cg)
d_kl = sum(kl_div(y_kl, stats.gamma.pdf(x_kl, ag, bg, cg)))
# plt.plot(x_test, pdf_gamma, label=f"Gamma {d_kl=}")

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
plt.plot(x_test, pdf_g, "k", label=f"一二三logistic {d_kl=}")

plt.legend(["概率分布直方图", "logitic拟合分布"], loc=2)
# plt.legend()
plt.xlabel("displacement/mm")
plt.savefig("up.tiff")
#%%
# min(y)
np.var(y)
# %%
a, b, c = stats.weibull_max.fit(y)
pdf_w = stats.weibull_max.pdf(x_test, a, b, c)
plt.plot(x_test, pdf_w)

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
# plt.hist(
#     df_mle_lars.YLARS,
#     20,
#     density=True,
#     label="histogram",
#     histtype="bar",
#     linewidth=2,
#     hatch="//",
#     edgecolor="k",
#     align="mid",
#     color="w",
# )
plt.hist(
    [df_mle_lars.Yval, df_mle_lars.YLARS],
    20,
    density=True,
    label="histogram",
    histtype="bar",
    linewidth=2,
    hatch="//",
    edgecolor="k",
    align="mid",
    color=["k", "w"],
)
plt.savefig("up_cmp.tiff")
# %%
df_mle_lars
# %%
max(y) / 52
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