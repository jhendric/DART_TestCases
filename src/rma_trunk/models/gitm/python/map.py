#plotting the map without "basemap". If you want just the shores - uncomment line 25 and comment out 27-31
import numpy as np
import matplotlib.pyplot as plt

f = open('map.txt', 'r'); elev = np.array(map(int, f.read().split())).reshape((360, 180)).T; f.close()
C = plt.contour(np.linspace(0,359,360), np.linspace(-90,89,180), elev, 0, colors='black') #just a contour at 0 elevation

# DART $Id: map.py 11001 2017-02-03 23:08:55Z thoar@ucar.edu $
# from Alexey Morozov
#
# <next few lines under version control, do not edit>
# $URL: https://svn-dares-dart.cgd.ucar.edu/DART/branches/rma_trunk/models/gitm/python/map.py $
# $Revision: 11001 $
# $Date: 2017-02-03 16:08:55 -0700 (Fri, 03 Feb 2017) $
