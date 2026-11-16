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

outputPath = r"C:\SX_indentationModellig\Cu_SX_indentation\SXgeom_Rtip_{}.dsco".format(tipRadiusVal)

#+++++++++++++++++++++++++++++++++++++++++++++
# PARAMETERS DEFINITION
#+++++++++++++++++++++++++++++++++++++++++++++
# All dimensions are given in microns
#scaleFactor = Parameters.scaleFactor #Activate 'Embed script' and add scaleFactor as a script parameter
scaleFactor = 1e3
tipFactor = 5 # Factor to scale the sample dimensions with respect to the indenter tip radius
mergeFlag = False

# Indenter tip parameters
tipRadius = tipRadiusVal/scaleFactor # Radius of the indenter tip in micron
coneAngle = 120 # Cone angle of the indenter tip in degrees
h_trans = tipRadius*(1-(math.sin(math.radians(coneAngle/2))))
arcXVal = math.pow((math.pow(tipRadius,2)-math.pow(tipRadius-h_trans,2)),0.5)
segXVal = arcXVal + (math.tan(math.radians(coneAngle/2))*(tipRadius-h_trans))

# Sample parameters - Values are in microns
box_zfrac = 0.5
box_xfrac = 0.8 # Usually 2x r_center_frac
r_center_frac = 0.4
h_sample = tipFactor*tipRadius
D_sample = tipFactor*tipRadius
r_sample = D_sample/2
a=r_center_frac*r_sample
RevolDegree = 360 # Used for the revolve operation
z_ini = 0
z_mid = z_ini-(h_sample*box_zfrac)
z_fin = z_ini-(h_sample)
x_mid = box_xfrac*r_sample

maxZdisp = -1e-06 # Maximum displacement along the z axis in meters
MaterialIndenter = "Diamond (carbon)"
#"Sapphire (aluminum oxide)"
# "Tungsten carbide"

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

# Python Script, API Version = V251

#############################################
# Reset Discovery project
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
# Specimen Geometry
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

ViewHelper.ZoomToEntity()

#############################################
# Indenter Geometry
#############################################
# Set Sketch Plane
plane = Plane.PlaneZX
result = ViewHelper.SetSketchPlane(plane)

# Sketch Line
start = Point2D.Create(MM(h_trans), MM(arcXVal))
end = Point2D.Create(MM(tipRadius), MM(segXVal))
result = SketchLine.Create(start, end)
# EndBlock

# Solidify Sketch
mode = InteractionMode.Solid
result = ViewHelper.SetViewMode(mode, None)
# EndBlock

# Create Sweep Arc
origin = Point2D.Create(MM(tipRadius), MM(z_ini))
start = Point2D.Create(MM(z_ini), MM(0))
end = Point2D.Create(MM(h_trans), MM(arcXVal))
senseClockWise = True
result = SketchArc.CreateSweepArc(origin, start, end, senseClockWise)
# EndBlock

# Solidify Sketch
mode = InteractionMode.Solid
result = ViewHelper.SetViewMode(mode, None)
# EndBlock

# Revolve 1 Sketch Curve
selection = Selection.Create(GetRootPart().Curves[0])
result = RevolveEdges.Execute(selection, Line.Create(Point.Create(MM(0), MM(0), MM(0)), 
    Direction.DirZ), DEG(RevolDegree), False, ExtrudeType.None)
# EndBlock

# Revolve 1 Sketch Curve
selection = Selection.Create(GetRootPart().Curves[0])
result = RevolveEdges.Execute(selection, Line.Create(Point.Create(MM(0), MM(0), MM(0)), 
    Direction.DirZ), DEG(RevolDegree), False, ExtrudeType.None)
# EndBlock

# Make Components
selection = BodySelection.Create([GetRootPart().Bodies[0],
    GetRootPart().Bodies[1]])
result = ComponentHelper.MoveBodiesToComponent(selection, None)
# EndBlock

# Rename 'Component5' to 'Indenter'
selection = PartSelection.Create(GetRootPart().Components[4].Content)
result = RenameObject.Execute(selection,"Indenter")
# EndBlock

# Merge Bodies
targets = BodySelection.Create(GetRootPart().Components[4].Content.Bodies[0])
tools = BodySelection.Create(GetRootPart().Components[4].Content.Bodies[1])
result = Combine.Merge(targets, tools)
# EndBlock

# Rigid body doesn't exist in Ansys Mechanical and a surface needs to be converted into a body (using 'Pull' tool).
# Then Diamond material can be attributed to the indenter.
# Stitching could be an option to transform a surface into a solid body

# Thicken 2 Faces
selection = FaceSelection.Create([GetRootPart().Components[4].Content.Bodies[0].Faces[0],
    GetRootPart().Components[4].Content.Bodies[0].Faces[1]])
options = ThickenFaceOptions()
result = ThickenFaces.Execute(selection, Direction.Create(-0.258819045102521, 3.16961915143177E-17, -0.965925826289068), MM(-0.08), options)
# EndBlock

# !!! The new merged face seems to be different from the 2 original faces. Less straight and more curvy... !!!
# Create New Face
if mergeFlag:
    selection = FaceSelection.Create([GetRootPart().Components[4].Content.Bodies[0].Faces[0],
        GetRootPart().Components[4].Content.Bodies[0].Faces[1]])
    result = ReplaceFacesWithFace.Execute(selection)
# EndBlock

#############################################
# Design tree cleaning step
#############################################
# Move Solid
selections = BodySelection.Create(GetRootPart().Components[3].Content.Bodies[0])
component = PartSelection.Create(GetRootPart().Components[0].Content)
result = ComponentHelper.MoveBodiesToComponent(selections, component, False, None)
# EndBlock

# Move Solid
selections = BodySelection.Create(GetRootPart().Components[2].Content.Bodies[0])
component = PartSelection.Create(GetRootPart().Components[0].Content)
result = ComponentHelper.MoveBodiesToComponent(selections, component, False, None)
# EndBlock

# Move Solid
selections = BodySelection.Create(GetRootPart().Components[1].Content.Bodies[0])
component = PartSelection.Create(GetRootPart().Components[0].Content)
result = ComponentHelper.MoveBodiesToComponent(selections, component, False, None)
# EndBlock

# Delete Empty Components
selection = PartSelection.Create(GetRootPart())
ComponentHelper.DeleteEmptyComponents(selection, None)
# EndBlock

# Rename 'Component1' to 'Specimen'
selection = PartSelection.Create(GetRootPart().Components[0].Content)
result = RenameObject.Execute(selection,"Specimen")
# EndBlock

#############################################
# Share Topology and Save Project
#############################################

# !!!!!! Only for Ansys Mechanical, not supported in Ansys Discovery !!!!!!
# Share Topology
options = ShareTopologyOptions()
options.Tolerance = UM(0.2)
result = ShareTopology.FindAndFix(options)
# EndBlock

# Save Project As
File.SaveAs(outputPath)
# EndBlock