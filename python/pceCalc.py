#%%
import numpy as np

# %%
def pceCalc(m, p):
    return int(np.math.factorial(m + p) / (np.math.factorial(m) * np.math.factorial(p)))


# %%
if __name__ == "__main__":
    print(f"{pceCalc(32,1)=}")
    print(f"{pceCalc(32,2)=}")
    print(f"{pceCalc(32,3)=}")
    print(f"{pceCalc(32,4)=}")

# %%
