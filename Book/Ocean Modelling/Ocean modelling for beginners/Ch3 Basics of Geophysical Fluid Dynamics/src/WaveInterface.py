import numpy as np   
from matplotlib import pyplot as plt   
from matplotlib import animation   
  
# first set up the figure, the axis, and the plot element we want to animate   
fig = plt.figure()   
ax = plt.axes(xlim=(0, 1000), ylim=(-5, 5))
line, = ax.plot([], [], lw=2) 

 
# initialization function: plot the background of each frame   
def init():   
    line.set_data([], [])   
    return line,   
  
# animation function.  this is called sequentially   
def animate(i):
	lamda1 = 100
	T1 = 60
	lamda2 = 90
	T2 = -30;
	A0 = 1;
	x = np.linspace(0, 1000, 1000)
	dt = 0.2
	y = A0*(np.sin(2 * np.pi * (x/lamda1 - dt*i/T1))+np.sin(2 * np.pi * (x/lamda2 - dt*i/T2)) )
	line.set_data(x, y)   
	return line,

# call the animator.  blit=true means only re-draw the parts that have changed.   
anim = animation.FuncAnimation(fig, animate, init_func=init, frames=300, interval=5)   
  
# save the animation as an mp4.  this requires ffmpeg or mencoder to be   
# installed.  the extra_args ensure that the x264 codec is used, so that   
# the video can be embedded in html5.  you may need to adjust this for   
# your system: for more information, see   
# http://matplotlib.sourceforge.net/api/animation_api.html   
# anim.save(‘basic_animation.mp4′, fps=30, extra_args=['-vcodec', 'libx264'])   
  
plt.show() 