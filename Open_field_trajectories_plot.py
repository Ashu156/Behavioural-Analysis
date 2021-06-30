# -*- coding: utf-8 -*-
"""
Created on Thu Jun 24 19:39:48 2021

@author: Dell
"""
import numpy as np
import matplotlib as mpl
import matplotlib.pyplot as plt
import scipy.io
import pandas as pd
import seaborn as sns

data_raw = scipy.io.loadmat('E:/Behaviour/Open_field_anxiety/Control/05.04.2016/B_M/trajectories_in_m.mat')
x = np.array(list(data_raw["X1Coord"]))
y = np.array(list(data_raw["Y1Coord"]))
fig = plt.figure(figsize=(14, 6))
plt.plot(x, y)

max_X = np.max(x)
min_X = np.min(x)

max_Y = np.max(y)
min_Y = np.min(y)

center_X = (max_X + min_X)/2
center_Y = (max_Y + min_Y)/2

length_X = max_X - min_X
length_Y = max_Y - min_Y

center_ratio = 0.25

center_Xmin = center_X - (length_X*center_ratio)
center_Xmax = center_X + (length_X*center_ratio)

center_Ymin = center_Y - (length_Y*center_ratio)
center_Ymax = center_Y + (length_Y*center_ratio)

location = []

for k in range(len(x)):
    if x[k]<=center_Xmax and x[k]>=center_Xmin and y[k]<=center_Ymax and y[k]>= center_Ymin:
        loc = 1
        location.append(loc)
    else:
        loc = 0
        location.append(loc)
        
# x = list(data_raw["X1Coord"]) 
# y = list(data_raw["Y1Coord"])  
# df2 = pd.DataFrame({'XCoord':x, 'YCoord':y, 'State':location}, dtype = "category") 

color = ['red', 'pink']
df = pd.DataFrame(np.column_stack([x, y, location]), columns = ['x', 'y', 'location'])
groups = df.groupby('location')


# for name, group in groups:
#     plt.plot(group["x"],group["y"], marker = 'o', linestyle="", label = name, color = color[name])
    # plt.legend()
    
fig = plt.figure()   
sns.scatterplot(x="x", y="y",
              hue="location", edgecolor = "none",
              data=df, palette = ['red', 'pink']);
plt.xlim = ([-0.05, 1.05]) 
plt.ylim = ([-0.05, 1.05]) 
plt.tight_layout()
fig.savefig('Track.eps', dpi = 300)

# fig = plt.figure() 
# ax = fig.add_subplot(111)

# rect1 = mpl.patches.Rectangle((min_X, min_Y),
#                                      length_X, length_Y,
#                                      color ='black')

# rect2 = mpl.patches.Rectangle((center_Xmin, center_Ymin),
#                                      (center_Xmax-center_Xmin), (center_Ymax-center_Ymin),
#                                      color ='gray')


# ax.add_patch(rect1)
# ax.add_patch(rect2)


# plt.xlim([-0.05, 1.05])
# plt.ylim([-0.05, 1.05])
# fig.tight_layout()
# fig.savefig('Arena.eps', dpi = 300)


fig = plt.scatter(x, y)
x_line = arange(min(x), max(x), 1)
y_line = objective(x_line, a, b)
plt.plot(x_line, y_line, '--', color = 'red')
fig.savefig('Arena.eps', dpi = 300)