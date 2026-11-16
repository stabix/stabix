# Python Script, API Version = V251
"""
@author: d.mercier
"""
# Geometry script made with python script editor from Ansys Discovery
# Select 'Index' for the Script Editor settings

#+++++++++++++++++++++++++++++++++++++++++++++
# INITIALIZATION
#+++++++++++++++++++++++++++++++++++++++++++++
# Python Script, API Version = V251
# !!! Discovery has to be set up in English language to run the script !!!

# Set Units in Discovery
# In 'Units and Display Precision', set Length scale to 'Small' and 'Length to 'µm'
# Small units (µm, nm, mils) are not supported in Explore and Refine stages. Physics can be defined,
# but the simulation cannot be solved in Discovery.
# Solving with shared topology is not supported. Remove topology sharing with the Unshare tool to solve.

# Check language in Discovery (Settings -> Advanced -> Language)
# Select English (or French) and restart Discovery if language was changed

# Run Script Editor in 'Conception' workspace
# Then copy and paste the script below in the Script Editor window

#+++++++++++++++++++++++++++++++++++++++++++++
# IMPORTING REQUIRED LIBRARIES
#+++++++++++++++++++++++++++++++++++++++++++++
import math

#+++++++++++++++++++++++++++++++++++++++++++++
# MATERIALS DEFINITION
#+++++++++++++++++++++++++++++++++++++++++++++
# Cu SX indentation - Cacket Large indent
MaterialSX = 'Cu'
cubicCell = True
# Cu SX indentation - Cacket small indent
MaterialSX = 'Cu'
cubicCell = True
# Ti alloy
MaterialSX = 'TiAlloy'
cubicCell = False

#+++++++++++++++++++++++++++++++++++++++++++++
# PARAMETERS DEFINITION
#+++++++++++++++++++++++++++++++++++++++++++++
# All dimensions are given in microns
#scaleFactor = Parameters.scaleFactor #Activate 'Embed script' and add scaleFactor as a script parameter
scaleFactor = 1e3

# Sample parameters - Values are in microns
h_sample = 5
r_sample = 5
D_sample = 2*r_sample
h_pillar = h_sample/2
r_pillar = r_sample/5
h_total = h_sample + h_pillar
curvatureRadius = 0.04 # Radius of curvature at the pillar base in microns
RevolDegree = 360 # Used for the revolve operation
z_ini = 0

MaterialIndenter = "Diamond (carbon)"
#"Sapphire (aluminum oxide)"
# "Tungsten carbide"

#+++++++++++++++++++++++++++++++++++++++++++++
# OUTPUT FILE PATH
#+++++++++++++++++++++++++++++++++++++++++++++
outputPath = r"C:\SX_indentationModellig\{}_SX_indentation\SX_PillarGeom_Radius{}um_Height{}um.dsco".format(MaterialSX, r_pillar, h_pillar)

#+++++++++++++++++++++++++++++++++++++++++++++
# SAMPLE GEOMETRY
#+++++++++++++++++++++++++++++++++++++++++++++
# ^ z axis
# |
# --> x axis
#
#     |<---------- r_sample ------------->|
#     |<- r_pillar ->|
#
#     *N1------------*N2   
#     |               |                      
#     |                \                     
#     *N4--------------*N3----------------*
#     |                     _             |
#     |                         _         |
#     |                             _     |
#     *-----------------------------------*
#
# N1 = [0,0,z_ini]
# N2 = [r_pillar,0,z_ini]
# N3 = [r_pillar,0,z_ini-h_sample]
# N4 = [0,0,z_ini-h_sample]

#############################################
# RESET AND UNITS
#############################################
# Reset Project
File.ResetProject()
# EndBlock

# Set Unit system
from SpaceClaim.Api.V251 import AngleUnit
from SpaceClaim.Api.V251 import MetricUnits
from SpaceClaim.Api.V251 import MetricLengthUnit
from SpaceClaim.Api.V251 import MetricMassUnit
from SpaceClaim.Api.V251 import UnitsSystemType

Window.ActiveWindow.Units.ActiveUnitsSystem = UnitsSystemType.Metric
Window.ActiveWindow.Units.MetricUnits = MetricUnits(MetricLengthUnit.Micrometers, MetricMassUnit.Grams, AngleUnit.Degrees)

#############################################
# SPECIMEN GEOMETRY
#############################################
# Python Script, API Version = V251

# Create sample
# Sketch Circle
plane = Plane.PlaneXY
result = ViewHelper.SetSketchPlane(plane)
origin = Point2D.Create(UM(0), UM(0))
result = SketchCircle.Create(origin, UM(r_sample))
baseSel = SelectionPoint.Create(GetRootPart().DatumPlanes[0].Curves[0].GetChildren[ICurvePoint]()[0])
targetSel = SelectionPoint.Create(GetRootPart().DatumPlanes[0].GetChildren[IDatumPoint]()[0])
result = Constraint.CreateCoincident(baseSel, targetSel)
# EndBlock
# Solidify Sketch
mode = InteractionMode.Solid
result = ViewHelper.SetViewMode(mode, None)
# EndBlock
# Extrude 1 Face
selection = FaceSelection.Create(GetRootPart().Bodies[0].Faces[0])
options = ExtrudeFaceOptions()
options.ExtrudeType = ExtrudeType.Add
result = ExtrudeFaces.Execute(selection, UM(-h_sample), options)
# EndBlock

# Create pillar
# Sketch Circle
plane = Plane.PlaneXY
result = ViewHelper.SetSketchPlane(plane)
origin = Point2D.Create(UM(0), UM(0))
result = SketchCircle.Create(origin, UM(r_pillar))
baseSel = SelectionPoint.Create(GetRootPart().DatumPlanes[0].Curves[0].GetChildren[ICurvePoint]()[0])
targetSel = SelectionPoint.Create(GetRootPart().DatumPlanes[0].GetChildren[IDatumPoint]()[0])
result = Constraint.CreateCoincident(baseSel, targetSel)
# EndBlock
# Solidify Sketch
mode = InteractionMode.Solid
result = ViewHelper.SetViewMode(mode, None)
# EndBlock
# Extrude 1 Face
selection = FaceSelection.Create(GetRootPart().Bodies[0].Faces[3])
options = ExtrudeFaceOptions()
options.ExtrudeType = ExtrudeType.Add
result = ExtrudeFaces.Execute(selection, UM(h_pillar), options)
# EndBlock

# Create 1 Fillet
# Create 1 Round
selection = EdgeSelection.Create(GetRootPart().Bodies[0].Edges[2])
options = ConstantRoundOptions()
result = ConstantRound.Execute(selection, UM(curvatureRadius), options, None)
# EndBlock

ViewHelper.ZoomToEntity()

#############################################
# SAVE PROJECT
#############################################
# Save Project As
File.SaveAs(outputPath)
# EndBlock