# XIAO HANLIN (G2000309D)

# a
import numpy as np
from sympy import symbols, solve, exp

k = symbols('k')
solve(2 * np.pi * k**2 - exp(-1 * k ** 2), k)
# output: [-0.372238898035619, 0.372238898035619]



# c
# package import
import pandas as pd
import numpy as np
import seaborn as sns
from scipy.stats import norm
# parameter setting
alpha = 0.5
theta = 50
k = 0.372238898035619
# lognormal distribution (1)
def f_1(x):
  if x <= 0:
    return 0
  else:
    return (alpha / (np.sqrt(2*np.pi) * x * k)) * np.exp(-0.5 * (alpha *
np.log(x / theta) / k + k)**2)
# pareto distribution (2)
def f_2(x):
  if x <= theta:
    return 0
  else:
    return (alpha * (theta**alpha) ) / (x ** (alpha + 1))
# combined distribution (3)
def f_3(x):
  if x <= 0:
    return 0
  f_x = 1 / (1 + norm.cdf(k)) * alpha * (theta ** alpha) / (x ** (alpha +
1))
  if 0 < x <= theta:
    return f_x * np.exp(-1 * (alpha ** 2) / (2 * (k ** 2)) *
(np.log(x/theta) ** 2))
  else:
return f_x
# plot them out
x_axis = np.arange(0.01, 200, 0.01)
data = pd.DataFrame({
    'Lognormal (1)': [f_1(x) for x in x_axis],
    'Pareto (2)': [f_2(x) for x in x_axis],
    'Combined (3)': [f_3(x) for x in x_axis]
}, index=x_axis)
sns.lineplot(data=data)


# e
import pandas as pd
import numpy as np
import scipy.optimize as optimize
from scipy.stats import norm

df = pd.read_csv('loss_data.csv')
k = 0.372238898035619

def f_3(x, alpha, theta):
    # the pdf of combined distribution (3)
    if x <= 0:
        return 0
    f_x = 1 / (1 + norm.cdf(k)) * alpha * \
        (theta ** alpha) / (x ** (alpha + 1))
    if 0 < x <= theta:
        return f_x * np.exp(-1 * (alpha ** 2) / (2 * (k ** 2)) *
(np.log(x/theta) ** 2))
    else:
return f_x

def mle_f_3(params):
    # mle function
    return -sum([np.log(f_3(x, *params)) for x in df.loss])

# use optimizer to solve it
initial_guess = [1, 1]
result = optimize.minimize(mle_f_3, initial_guess, method='Nelder-Mead')

if result.success:
    fitted_params = result.x
    print(fitted_params)
# [α, θ]
# [1.43633786 1.38514635]


# plotting
# import libraries
import numpy as np
import pandas as pd
import seaborn as sns
from scipy.stats import norm
from matplotlib import pyplot as plt

# constant setting
k = 0.372238898035619
c = 1 / (1 + norm.cdf(k))
# lognormal distribution (1)
def f_1(x):
  mu = 0.67185367
  sigma = 0.73231666
  if x <= 0:
    return 0
  else:
    return (1 / (np.sqrt(2*np.pi) * x * sigma)) * np.exp(
          -0.5 * (np.log(x) - mu)**2 / sigma**2)
# pareto distribution (2)
def f_2(x):
  alpha = 0.54581705
  theta = 0.31340405
  if x < theta:
    return 0
  else:
    return (alpha * (theta**alpha) ) / (x ** (alpha + 1))
# combined distribution (3)
def f_3(x):
  alpha = 1.43633786
  theta = 1.38514635
  if x <= 0:
    return 0
  f_x = c * alpha * (theta ** alpha) / (x ** (alpha + 1))
  if 0 < x <= theta:
    return f_x * np.exp(-1 * (alpha ** 2) / (2 * (k ** 2)) *
(np.log(x/theta) ** 2))
  else:
    return f_x
# generating distribution samples
x_axis = np.arange(0.01, 20, 0.01)
data = pd.DataFrame({
    'Lognormal (1)': [f_1(x) for x in x_axis],
    'Pareto (2)': [f_2(x) for x in x_axis],
    'Combined (3)': [f_3(x) for x in x_axis]
}, index=x_axis)
# read in the csv data
df = pd.read_csv('loss_data.csv')
# canvas setting
sns.set(rc={'axes.facecolor':'white', 'figure.facecolor':'white'})
fig=plt.figure(figsize=(20,10))
ax1 = fig.add_subplot(111)
ax1.set(xlim=(0, 10))
ax2 = ax1.twinx()
ax1.set(ylim=(0, 0.8))
# plot them out
sns.lineplot(data=data, ax=ax1)
sns.histplot(data=df.loss,ax=ax2,fill=False,color='#AAAAAA')