import numpy as np
import matplotlib.pyplot as plt

fr = open("winethief.txt")
array = fr.readlines()
num = len(array)
returnMat = np.zeros((num,3))
index = 0 
for line in array:
    line = line.strip()
    linelist = line.split(' ')
    returnMat[index,:] = linelist
    index +=1

plt.figure(1)
plt.plot(returnMat[:,0], returnMat[:,2],'bo-')

plt.show()
# print returnMat

