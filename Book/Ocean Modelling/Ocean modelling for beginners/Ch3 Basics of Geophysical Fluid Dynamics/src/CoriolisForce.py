# -*- coding: utf-8 -*-
import numpy as np
from matplotlib import pyplot as plt   
from matplotlib import animation

# first set up the figure, the axis, and the plot element we want to animate   
fig = plt.figure()
lim = 20*10000;
ax = plt.axes(xlim=(-lim, lim), ylim=(-lim, lim))
line, = ax.plot([], [], lw=2)

# parameter
Omega =  -7.27*(10**-5)
n = 50*10000
X = np.zeros((n, 1))
Y = np.zeros((n, 1))
U = 0.864
V = 0.5
# seconds
dt = 0.5*3600
Y[0] = 5000

def timeEvolution(x,y,u,v,newx, newy):
	u = u - dt*Omega**2*x
	v = v - dt*Omega**2*y
	newx = x + dt*u
	newy = y + dt*v
	return newx,newy

def init():
	line.set_data([],[])
	return line,

def animate(i):
	[X[i+1],Y[i+1]] = timeEvolution(X[i],Y[i],U,V,X[i+1],Y[i+1])
	line.set_data(X, Y)
	return line,


# call the animator.  blit=true means only re-draw the parts that have changed.   
anim = animation.FuncAnimation(fig, animate, init_func=init, frames=n, interval=5)   
  
# save the animation as an mp4.  this requires ffmpeg or mencoder to be   
# installed.  the extra_args ensure that the x264 codec is used, so that   
# the video can be embedded in html5.  you may need to adjust this for   
# your system: for more information, see   
# http://matplotlib.sourceforge.net/api/animation_api.html   
# anim.save(‘basic_animation.mp4′, fps=30, extra_args=['-vcodec', 'libx264'])   
  
plt.show()

