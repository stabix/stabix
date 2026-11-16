# Python Script, API Version = V242
"""
@author: d.mercier
"""
# Geometry script made with python script editor from Ansys Discovery
# Select 'Index' for the Script Editor settings

#+++++++++++++++++++++++++++++++++++++++++++++
# INITIALIZATION
#+++++++++++++++++++++++++++++++++++++++++++++
# !!! Discovery has to be set up in English language to run the script !!!

# Set Units in Discovery
# In 'Units and Display Precision', set Length scale to 'Small' and 'Length to 'µm'
# Small units (µm, nm, mils) are not supported in Explore and Refine stages. Physics can be defined,
# but the simulation cannot be solved in Discovery.
# Solving with shared topology is not supported. Remove topology sharing with the Unshare tool to solve.

#+++++++++++++++++++++++++++++++++++++++++++++
# IMPORTING REQUIRED LIBRARIES
#+++++++++++++++++++++++++++++++++++++++++++++

import math

#+++++++++++++++++++++++++++++++++++++++++++++
# PATHS DEFINITION
#+++++++++++++++++++++++++++++++++++++++++++++

# Cu SX indentation - Cacket Large indent
tipRadiusVal = 27 # Radius of the indenter tip in microns
# Cu SX indentation - Cacket small indent
tipRadiusVal = 7.4 # Radius of the indenter tip in microns

outputPath = r"C:\SX_indentationModellig\Cu_SX_indentation\SXgeomCyl_Cu_Rtip_{}.dsco".format(tipRadiusVal)

#+++++++++++++++++++++++++++++++++++++++++++++
# PARAMETERS DEFINITION
#+++++++++++++++++++++++++++++++++++++++++++++
# All dimensions are given in microns
#scaleFactor = Parameters.scaleFactor #Activate 'Embed script' and add scaleFactor as a script parameter
scaleFactor = 1

# Indenter tip parameters
tipRadius = tipRadiusVal/scaleFactor # Radius of the indenter tip in micron

# Sample parameters
box_zfrac = 0.5
box_xfrac = 0.8 # Usually 2x r_center_frac
r_center_frac = 0.4
h_sample = 5*tipRadius
D_sample = 5*tipRadius
r_sample = D_sample/2
a=r_center_frac*r_sample
RevolDegree = 360 # Used for the revolve operation
z_ini = 0
z_mid = z_ini-(h_sample*box_zfrac)
z_fin = z_ini-(h_sample)
x_mid = box_xfrac*r_sample

# ^ z axis
# |
# --> x axis
#
#+++++++++++++++++++++++++++++++++++++++++++++
# SAMPLE GEOMETRY
#+++++++++++++++++++++++++++++++++++++++++++++
#     |<---------- r_sample --------------->|
#
#          __--
#     __---
#     *N1-------------------------------N4*
#     |                                   |
#     |                                   |
#     |                                   |
#     |                                   |
#     |                                   |
#     |                                   |
#     *N2---------------------------------N3*
#
# N1 = [0,0,z_ini]
# N2 = [0,0,z_ini-h_sample]
# N3 = [a,0,z_ini-h_sample]
# N4 = [a,0,z_ini]

# Python Script, API Version = V242

#############################################
# Reset Discovery project
#############################################
# Reset Project
File.ResetProject()
# EndBlock

# Set Unit system
from SpaceClaim.Api.V242 import AngleUnit
from SpaceClaim.Api.V242 import MetricUnits
from SpaceClaim.Api.V242 import MetricLengthUnit
from SpaceClaim.Api.V242 import MetricMassUnit
from SpaceClaim.Api.V242 import UnitsSystemType

Window.ActiveWindow.Units.ActiveUnitsSystem = UnitsSystemType.Metric
Window.ActiveWindow.Units.MetricUnits = MetricUnits(MetricLengthUnit.Micrometers, MetricMassUnit.Grams, AngleUnit.Degrees)

#############################################
# Specimen Geometry
#############################################
# Sketch Circle
plane = Plane.PlaneXY
result = ViewHelper.SetSketchPlane(plane)
origin = Point2D.Create(UM(0), UM(0))
result = SketchCircle.Create(origin, UM(r_sample))

# Solidify Sketch
mode = InteractionMode.Solid
result = ViewHelper.SetViewMode(mode, Info1)
# EndBlock

ViewHelper.ZoomToEntity()

# Extrude 1 Face
selection = Face1
options = ExtrudeFaceOptions()
options.ExtrudeType = ExtrudeType.Cut
result = ExtrudeFaces.Execute(selection, UM(-h_sample), options, Info2)
# EndBlock

#############################################
# Save Project
#############################################

# Save Project As
File.SaveAs(outputPath)
# EndBlock

ViewHelper.ZoomToEntity()
