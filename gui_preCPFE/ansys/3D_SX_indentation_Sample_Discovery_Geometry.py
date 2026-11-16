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
# Solving in Discovery with shared topology is not supported. Remove topology sharing with the Unshare tool to solve.

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

outputPath = r"C:\SX_indentationModellig\Cu_SX_indentation\SXgeom_Cu_Rtip_{}.dsco".format(tipRadiusVal)

#+++++++++++++++++++++++++++++++++++++++++++++
# PARAMETERS DEFINITION
#+++++++++++++++++++++++++++++++++++++++++++++
# All dimensions are given in microns
#scaleFactor = Parameters.scaleFactor #Activate 'Embed script' and add scaleFactor as a script parameter
scaleFactor = 1e3

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
#     *N1-----------*N4-------------------*
#     |             |                     |
#     |             |                     |
#     *N2-----------*N3                   |
#     |                 _                 |
#     |                     _             |
#     |                         _         |
#     |                             _     |
#     *-----------------------------------*
#
# N1 = [0,0,z_ini]
# N2 = [0,0,z_ini-h_sample*box_zfrac]
# N3 = [a,0,z_ini-h_sample*box_zfrac]
# N4 = [a,0,z_ini]

# Python Script, API Version = V242

#############################################
# RESET PROJECT AND SET UNITS
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
# SPECIMEN GEOMETRY
#############################################
# Set Sketch Plane
plane = Plane.PlaneZX
result = ViewHelper.SetSketchPlane(plane)

# Sketch Rectangle
point1 = Point2D.Create(MM(0),MM(z_ini))
point2 = Point2D.Create(MM(z_mid),MM(0))
point3 = Point2D.Create(MM(z_mid),MM(a))
result = SketchRectangle.Create(point1, point2, point3)
# EndBlock

# Sketch Rectangle
point1 = Point2D.Create(MM(z_mid),MM(0))
point2 = Point2D.Create(MM(z_fin),MM(0))
point3 = Point2D.Create(MM(z_fin),MM(a))
result = SketchRectangle.Create(point1, point2, point3)
# EndBlock

# Sketch Rectangle
point1 = Point2D.Create(MM(z_ini),MM(a))
point2 = Point2D.Create(MM(z_mid),MM(a))
point3 = Point2D.Create(MM(z_mid),MM(x_mid))
result = SketchRectangle.Create(point1, point2, point3)
# EndBlock

# Sketch Line
start = Point2D.Create(MM(z_ini), MM(x_mid))
end = Point2D.Create(MM(z_ini), MM(r_sample))
result = SketchLine.Create(start, end)
# EndBlock

# Sketch Line
start = Point2D.Create(MM(z_ini), MM(r_sample))
end = Point2D.Create(MM(z_fin), MM(r_sample))
result = SketchLine.Create(start, end)
# EndBlock

# Sketch Line
start = Point2D.Create(MM(z_fin), MM(r_sample))
end = Point2D.Create(MM(z_fin), MM(a))
result = SketchLine.Create(start, end)
# EndBlock

# Sketch Line
start = Point2D.Create(MM(z_fin), MM(a))
end = Point2D.Create(MM(z_mid), MM(a))
result = SketchLine.Create(start, end)
# EndBlock

# Sketch Line
start = Point2D.Create(MM(z_mid), MM(a))
end = Point2D.Create(MM(z_mid), MM(x_mid))
result = SketchLine.Create(start, end)
# EndBlock

# Sketch Line
start = Point2D.Create(MM(z_mid), MM(x_mid))
end = Point2D.Create(MM(z_ini), MM(x_mid))
result = SketchLine.Create(start, end)
# EndBlock

# Solidify Sketch
mode = InteractionMode.Solid
result = ViewHelper.SetViewMode(mode, None)
# EndBlock

# Revolve 1 Face
selection = FaceSelection.Create(GetRootPart().Bodies[0].Faces[1])
axisSelection = Selection.Create(GetRootPart().CoordinateSystems[0].Axes[2])
axis = RevolveFaces.GetAxisFromSelection(selection, axisSelection)
options = RevolveFaceOptions()
options.ExtrudeType = ExtrudeType.Add
result = RevolveFaces.Execute(selection, axis, DEG(RevolDegree), options)
# EndBlock

# Make Components
selection = BodySelection.Create(GetRootPart().Bodies[1])
result = ComponentHelper.MoveBodiesToComponent(selection, None)
# EndBlock

# Revolve 1 Face
selection = FaceSelection.Create(GetRootPart().Bodies[0].Faces[2])
axisSelection = Selection.Create(GetRootPart().CoordinateSystems[0].Axes[2])
axis = RevolveFaces.GetAxisFromSelection(selection, axisSelection)
options = RevolveFaceOptions()
options.ExtrudeType = ExtrudeType.Add
result = RevolveFaces.Execute(selection, axis, DEG(RevolDegree), options)
# EndBlock

# Make Components
selection = BodySelection.Create(GetRootPart().Bodies[1])
result = ComponentHelper.MoveBodiesToComponent(selection, None)
# EndBlock

# Revolve 1 Face
selection = FaceSelection.Create(GetRootPart().Bodies[0].Faces[1])
axisSelection = Selection.Create(GetRootPart().CoordinateSystems[0].Axes[2])
axis = RevolveFaces.GetAxisFromSelection(selection, axisSelection)
options = RevolveFaceOptions()
options.ExtrudeType = ExtrudeType.Add
result = RevolveFaces.Execute(selection, axis, DEG(RevolDegree), options)
# EndBlock

# Make Components
selection = BodySelection.Create(GetRootPart().Bodies[1])
result = ComponentHelper.MoveBodiesToComponent(selection, None)
# EndBlock

# Revolve 1 Face
selection = FaceSelection.Create(GetRootPart().Bodies[0].Faces[0])
axisSelection = Selection.Create(GetRootPart().CoordinateSystems[0].Axes[2])
axis = RevolveFaces.GetAxisFromSelection(selection, axisSelection)
options = RevolveFaceOptions()
options.ExtrudeType = ExtrudeType.Add
result = RevolveFaces.Execute(selection, axis, DEG(RevolDegree), options)
# EndBlock

# Make Components
selection = BodySelection.Create(GetRootPart().Bodies[0])
result = ComponentHelper.MoveBodiesToComponent(selection, None)
# EndBlock

#############################################
# Design tree cleaning step
#############################################
# Move all at the root level
bodiessel = Selection.Create(GetRootPart().GetAllBodies())
rootsel = Selection.Create(GetRootPart())
ComponentHelper.MoveBodiesToComponent(bodiessel, rootsel)

# Delete Empty Components
selection = PartSelection.Create(GetRootPart())
ComponentHelper.DeleteEmptyComponents(selection, None)
# EndBlock

## Rename 'Component1' to 'Specimen'
#selection = PartSelection.Create(GetRootPart().Components[0].Content)
#result = RenameObject.Execute(selection,"Specimen")
## EndBlock
GetRootPart().SetName('Specimen')

#############################################
# SHARE TOPOLOGY and SAVE PROJECT
#############################################

# !!!!!! Only for Ansys Mechanical, not supported in Ansys Discovery !!!!!!
# Share Topology
options = ShareTopologyOptions()
options.Tolerance = UM(0.2) ##MM if not in microns system unit
result = ShareTopology.FindAndFix(options)
# EndBlock

# Save Project As
File.SaveAs(outputPath)
# EndBlock

ViewHelper.ZoomToEntity()