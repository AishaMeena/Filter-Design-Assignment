#!/usr/bin/env python
# coding: utf-8

# In[5]:


import numpy as np
import scipy as sp
import scipy.signal as sg
import matplotlib.pyplot as plt
import pylab as pl
omega_c= 1.084
B= 0.326
N=8
poles = np.zeros([2*N-1],dtype='complex64')
iterable = ((2*k+1)*np.pi/(2*N) for k in range(2*int(N)))
xp = np.fromiter(iterable,float)
poles = (1.j)*omega_c*np.exp(1.j*xp)
plt.scatter(poles.real,poles.imag)
plt.ylabel('Imaginary')
plt.xlabel('Real')
plt.axhline(y=0,color='black')
plt.axvline(x=0, color='black')
plt.show()
print(poles)
for x in poles:
       plt.polar([0,np.angle(x)],[0,abs(x)],marker='o')


# In[4]:


for x in poles:
       plt.polar([0,np.angle(x)],[0,abs(x)],marker='o')


# In[ ]:




