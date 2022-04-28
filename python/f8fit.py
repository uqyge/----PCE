#%%
import matplotlib.pyplot as plt
import pandas as pd
import scipy.stats as stats
from scipy.special import kl_div
import numpy as np


def cm_to_inch(value):
    return value / 2.54


# %%
df_r2_lars_50 = pd.read_csv("../outputs/r2Lars_qnorm_50_yid_36.csv")
df_r2_lars_50.head()

#%%
y = df_r2_lars_50.Yval
plt.hist(y, density=True, label="histogram")
xt = plt.xticks()[0]
x_l, x_u = min(xt), max(xt)
x_test = np.linspace(x_l, x_u, 100)

# %%

plt.figure(figsize=(cm_to_inch(8), cm_to_inch(6)), dpi=600)
plt.rc("font", family="Times New Roman")
plt.rc("font", size=8)
plt.rc("lines", linewidth=0.5)

hist = plt.hist(
    y,
    20,
    density=True,
    label="histogram",
    histtype="bar",
    linewidth=1,
    # hatch="//",
    edgecolor="k",
    align="mid",
    # color="w",
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

plt.legend(["LARS", "logitic distribution"], loc=2, frameon=False)

#%%
plt.figure(figsize=(cm_to_inch(8), cm_to_inch(6)), dpi=600)
plt.rc("font", family="Times New Roman")
plt.rc("font", size=8)
plt.rc("lines", linewidth=0.5)

plt.plot(x_test, pdf_g, "k", linewidth=0.75)
plt.hist(
    y,
    20,
    density=True,
    label="histogram",
    histtype="bar",
    linewidth=1,
    # hatch="//",
    edgecolor="k",
    align="mid",
    # color="w",
)
plt.xlabel("distance/cm")
plt.ylabel("density")
plt.legend(["logitic distribution", "LARS"], loc=2, frameon=False)
plt.ylim([0, 0.29])
# plt.yticks([0, 0.1, 0.2])
plt.tight_layout()
plt.savefig("../figures/mle.tiff")
# %%
