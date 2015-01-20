from abaqus import *
from caeModules import * 
from odbAccess import *
from abaqusConstants import *
import csv
import sys

#Fixed variables used in the script
root_raw_topo='raw_topography.csv'
delimiter_raw_topo=';'
root_ini_curve='curve.csv'
delimiter_ini_curve=' '
root_raw_curve='load_displacement_curve.csv'
delimiter_raw_curve=';'
#################################################

Indentation_Job_Name = sys.argv[-1]
odb = openOdb(Indentation_Job_Name)
LastFrame = odb.steps['Indent'].frames[-1]
myAssembly = odb.rootAssembly
Surface_Nodes=myAssembly.instances['FINAL SAMPLE-1'].nodeSets['SURF SAMPLE']
total_coordinates = LastFrame.fieldOutputs['COORD']
coordinatesDisplacement = total_coordinates.getSubset(region=Surface_Nodes)
coordinatesSurfaceNodes = coordinatesDisplacement.values
counter = 0
matrix_raw_topo = []
for coord in coordinatesSurfaceNodes:
    matrix_raw_topo.append([])
    for i in range(3):
        matrix_raw_topo[counter].append(coord.data[i])
    counter += 1
with open(root_raw_topo, "wb") as file_raw_topo:
    writer = csv.writer(file_raw_topo, delimiter=delimiter_raw_topo)
    writer.writerows(matrix_raw_topo)
file_raw_topo.close()
session.XYDataFromHistory(name='Load', odb=odb, outputVariableName='Reaction force: RF3 PI: INDENTER-1 Node 1 in NSET REF_INDENTER',)
session.XYDataFromHistory(name='Displacement', odb=odb, 
    outputVariableName='Spatial displacement: U3 PI: INDENTER-1 Node 1 in NSET REF_INDENTER',)
xy1 = session.xyDataObjects['Displacement']
xy2 = session.xyDataObjects['Load']
xy3 = combine(-xy1, -xy2)
xy3.setValues(sourceDescription='combine ( -"Displacement", -"Load" )')
tmpName = xy3.name
session.xyDataObjects.changeKey(tmpName, 'Curve')
x0 = session.xyDataObjects['Curve']
session.writeXYReport(fileName=root_ini_curve, xyData=(x0, ))
with open(root_ini_curve, 'rb') as file_ini_curve:
    ini_curve_data = list(csv.reader(file_ini_curve, delimiter=delimiter_ini_curve))
matrix_1_curve=[] 
rownum=0 
for row in ini_curve_data:
    if row:
        matrix_1_curve.append(row)
matrix_2_curve = []
for i in range(1, len(matrix_1_curve)):
    matrix_2_curve.append([])
    for j in range(len(matrix_1_curve[i])):
        if matrix_1_curve[i][j]!= "":
            matrix_2_curve[i-1].append(matrix_1_curve[i][j])
print matrix_2_curve
with open(root_raw_curve, "wb") as file_raw_curve:
    writer = csv.writer(file_raw_curve, delimiter=delimiter_raw_curve)
    writer.writerows(matrix_2_curve)
file_ini_curve.close()
os.remove(root_ini_curve)