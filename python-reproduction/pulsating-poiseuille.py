'''
Simulation of the 2-D velocity distribution in the pulsating Poiseuille flow,
with the PCA approximation with nPC number of principal components.
_______________________________
    |\                y ^
    |  \                |
    |   |  u(y)          ---> x
    |  /
____|/_________________________

Data is collected in a matrix of size (Ns x Nt).
The rows are spatial coordinates and columns are time coordinates.
'''
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.animation as animation
from sklearn.decomposition import PCA
import math

## Styles:
csfont = {'fontname':'Lato', "weight": "light"}
hfont = {'fontname':'Lato', "weight": "medium"}
solution_col = '#282850'
approx_col = '#f44242'
background_col = "#f9f7f2"
fontLabel = 10
fontTitle = 12

## Data:
Wo = 10
Pa = 60
nPC = 1 # number of principal components in the approximation

## Solution:
Nt = 200
Ns = 100
time = np.linspace(0,50,Nt)
space = np.linspace(-1,1,Ns)
u = np.zeros((Ns, Nt))

for k in range(0, Nt):
    Y = (1 - np.cosh(Wo*((1j)**0.5)*space)/(np.cosh(Wo*((1j)**0.5))))*1j*Pa/Wo**2
    temp_val = Y*np.exp(1j*time[k])
    u[:,k] = temp_val.real

u_mean = np.tile(((1 - space**2)*0.5), [Nt, 1])
u_R = u + np.transpose(u_mean)

## Perform PCA on a data set:
pca = PCA(n_components=nPC)
pca.fit(np.transpose(u_R))
scores = pca.transform(np.transpose(u_R))
u_R_PCA = np.transpose(pca.inverse_transform(scores))

## Simulation:
fig = plt.figure()
ax = plt.axes(xlim=(-0.5,1.25), ylim=(-1, 1))
line, = ax.plot([], [], lw=2, color=solution_col)
line_PCA, = ax.plot([], [], '--', lw=2, color=approx_col)
dashLine = "#cccccc"
plt.plot([-0.5, 1.25], [0, 0], "--", lw=2, color=dashLine, zorder=-1)
plt.title("Velocity profile $u(y)$ in the pulsating Poiseuille flow", **csfont, fontsize=fontTitle)
plt.text(1, 0.85, "Exact", **hfont, fontsize=fontLabel, color=solution_col)
plt.text(1, 0.75, "First PC", **hfont, fontsize=fontLabel, color=approx_col)
plt.ylabel("$y$", **csfont, fontsize=fontLabel)
plt.xlabel("$u(y)$", **csfont, fontsize=fontLabel)

# Adjust grid markers:
major_ticks = np.arange(-1, 1.1, 1)
ax.set_yticks(major_ticks)
minor_ticks = np.arange(-1, 1.1, 0.5)
ax.set_yticks(minor_ticks, minor=True)

# Set the tick labels font
for label in (ax.get_xticklabels()):
    label.set_fontname('Lato')
    label.set_fontweight('light')
    label.set_fontsize(10)

for label in (ax.get_yticklabels()):
    label.set_fontname('Lato')
    label.set_fontweight('light')
    label.set_fontsize(10)

def init():
    line.set_data([], [])
    line_PCA.set_data([], [])
    return line, line_PCA,

def animate(i):
    line.set_data(u_R[:,i], space)
    line_PCA.set_data(u_R_PCA[:,i], space)
    return line, line_PCA,

anim = animation.FuncAnimation(fig, animate, init_func=init, frames=Nt, interval=100, blit=True, repeat=False)

anim.save("./pulsating-poiseuille.gif", writer='imagemagick', fps=10, bitrate=-1)

plt.show()
