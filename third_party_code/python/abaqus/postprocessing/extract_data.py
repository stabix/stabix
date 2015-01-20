import csv
import numpy as np
from matplotlib.mlab import griddata
import os
import time

#Variables to be specified#
Indentation_Job_Name = 'Indentation_Job.odb'
name_output_file_curve = 'load_displacement_curve.txt'
name_output_file_topo = 'topography.txt'
resolution = 256 ## pixel resolution (resolution*resolution) of the final topography file
##########################################

#Fixed variables used in the script
root_raw_topo='raw_topography.csv'
delimiter_raw_topo=';'
root_raw_curve='load_displacement_curve.csv'
delimiter_raw_curve=';'
##########################################

system_script='abaqus cae nogui=auxiliary_script.py -- '+Indentation_Job_Name
os.system(system_script)
while not os.path.exists(root_raw_topo):
    time.sleep(1)
with open(root_raw_curve, 'rb') as file_raw_curve:
    raw_curve_data = list(csv.reader(file_raw_curve, delimiter=delimiter_raw_curve))
matrix_raw_curve=[] 
rownum=0 
for row in raw_curve_data:
    if row:
        matrix_raw_curve.append(row)
for i in range(len(matrix_raw_curve)):
    for j in range(len(matrix_raw_curve[i])):
        matrix_raw_curve[i][j] = float(matrix_raw_curve[i][j])
np.savetxt(name_output_file_curve, matrix_raw_curve, fmt='%2.5f', delimiter='\t', newline='\n')
file_raw_curve.close()
with open(root_raw_topo, 'rb') as file_raw_topo:
    raw_topo_data = list(csv.reader(file_raw_topo, delimiter=delimiter_raw_topo))
matrix_raw_topo=[] 
rownum=0 
for row in raw_topo_data:
    matrix_raw_topo.append(row)
for i in range(len(matrix_raw_topo)):
    for j in range(len(matrix_raw_topo[i])):
        matrix_raw_topo[i][j] = float(matrix_raw_topo[i][j])
matrix_raw_topo = np.asarray(matrix_raw_topo)
x = matrix_raw_topo[:,0]
y = matrix_raw_topo[:,1]
z = matrix_raw_topo[:,2]
range_max=max(x)
xi = np.linspace(-range_max, range_max, resolution)
yi = np.linspace(-range_max, range_max, resolution)
zi = griddata(x, y, z, xi, yi, interp='linear')
matrix_final_topo = []
counter = 0
for i in range(resolution):
    for j in range(resolution):
        matrix_final_topo.append([])
        matrix_final_topo[counter].append(xi[i])
        matrix_final_topo[counter].append(yi[j])
        matrix_final_topo[counter].append(zi[i][j])
        counter += 1
for i in range(resolution*resolution):
    if type(matrix_final_topo[i][-1]) != type(zi[int(resolution/2)][int(resolution/2)]):
        matrix_final_topo[i][-1] = 0.0
np.savetxt(name_output_file_topo, matrix_final_topo, fmt='%2.5f', delimiter='\t', newline='\n')
os.remove(root_raw_topo)
os.remove(root_raw_curve)
os.remove('abaqus.rpy')