# Python Script, API Version = V251
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
tipRadiusVal = 1 # Radius of the indenter tip in microns

outputPath = r"C:\SX_indentationModellig\Cu_SX_indentation\BXgeom_Ti_Rtip_{}.dsco".format(tipRadiusVal)
outputPath = r"C:\SX_indentationModellig\0_Final_demo_Files\Ti_BX\BXgeom_Ti_Rtip_{}.dsco".format(tipRadiusVal)

#+++++++++++++++++++++++++++++++++++++++++++++
# PARAMETERS DEFINITION
#+++++++++++++++++++++++++++++++++++++++++++++
# All dimensions are given in microns
#scaleFactor = Parameters.scaleFactor #Activate 'Embed script' and add scaleFactor as a script parameter
scaleFactor = 1e3
tipFactor = 10 # Factor to scale the sample dimensions with respect to the indenter tip radius
mergeFlag = False

# Indenter parameters
tipRadius = tipRadiusVal/scaleFactor # Radius of the indenter tip in micron
coneAngle = 120 # Cone angle of the indenter tip in degrees
h_trans = tipRadius*(1-(math.sin(math.radians(coneAngle/2))))
arcXVal = math.pow((math.pow(tipRadius,2)-math.pow(tipRadius-h_trans,2)),0.5)
segXVal = arcXVal + (math.tan(math.radians(coneAngle/2))*(tipRadius-h_trans))
RevolDegree = 360 # Used for the revolve operation

# Sample parameters
h_sample = tipFactor*tipRadius*scaleFactor
l_sample = tipFactor*tipRadius*scaleFactor
w_sample = tipFactor*tipRadius*scaleFactor
z_ini = 0
z_fin = z_ini-(h_sample)

distIndSam = 1.2 # Distance between the indenter and the sample in microns
angGB = 113.7 # Angle of the grain boundary in degrees
#angGB = 0 # Angle of the grain boundary in degrees

maxZdisp = -1e-06 # Maximum displacement along the z axis in meters
MaterialIndenter = "Diamond (carbon)"
#"Sapphire (aluminum oxide)"
# "Tungsten carbide"

# ^ y axis
# |
# --> x axis
#
#+++++++++++++++++++++++++++++++++++++++++++++
# SAMPLE GEOMETRY (top view)
#+++++++++++++++++++++++++++++++++++++++++++++
#     |<---------- l_sample ------------->|
#
#     *N1-------------------------------N4*
#     |                |                  |
#     |                |                  |
#     |                |                  |
#     |      SX1       N0      SX2        |
#     |                |                  |
#     |                |                  |
#     |                |                  |
#     *N2-------------------------------N3*
#
# N0 = [0,0,z_ini]
# N1 = [-l_sample/2,w_sample/2,z_ini]
# N2 = [-l_sample/2,-w_sample/2,z_ini]
# N3 = [l_sample/2,-w_sample/2,z_ini]
# N4 = [l_sample/2,w_sample/2,z_ini]

# Python Script, API Version = V251

#############################################
# RESET PROJECT AND SET UNITS
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

# Set Sketch Plane
plane = Plane.PlaneXY
result = ViewHelper.SetSketchPlane(plane)

# Sketch Rectangle
point1 = Point2D.Create(UM(-l_sample/2),UM(w_sample/2))
point2 = Point2D.Create(UM(l_sample/2),UM(-w_sample/2))
point3 = Point2D.Create(UM(l_sample/2),UM(w_sample/2))
result = SketchRectangle.Create(point1, point2, point3)
# EndBlock

# Solidify Sketch
mode = InteractionMode.Solid
result = ViewHelper.SetViewMode(mode)
# EndBlock

ViewHelper.ZoomToEntity()

# Extrude 1 Face
selection = FaceSelection.Create(GetRootPart().Bodies[0].Faces[0])
options = ExtrudeFaceOptions()
options.ExtrudeType = ExtrudeType.Cut
result = ExtrudeFaces.Execute(selection, UM(z_fin), options)
# EndBlock

ViewHelper.ZoomToEntity()

#############################################
# SPLIT THE SAMPLE IN TWO PARTS (2 SXs)
#############################################
# Create Datum Plane
selection = Selection.Create(GetRootPart().CoordinateSystems[0].Axes[0])
result = DatumPlaneCreator.Create(selection, False, None)
# EndBlock

# Slice Bodies by Plane
selection = BodySelection.Create(GetRootPart().Bodies[0])
datum = Selection.Create(GetRootPart().DatumPlanes[0])
result = SplitBody.ByCutter(selection, datum)
# EndBlock

# Delete Selection
selection = Selection.Create(GetRootPart().DatumPlanes[0])
result = Delete.Execute(selection)
# EndBlock

# Rename 'Solid' to 'SX1'
selection = BodySelection.Create(GetRootPart().Bodies[0])
result = RenameObject.Execute(selection,"SX1")
# EndBlock

# Rename 'Solid1' to 'SX2'
selection = BodySelection.Create(GetRootPart().Bodies[1])
result = RenameObject.Execute(selection,"SX2")
# EndBlock

# Make Components
selection = BodySelection.Create([GetRootPart().Bodies[0],
    GetRootPart().Bodies[1]])
result = ComponentHelper.MoveBodiesToComponent(selection, None)
# EndBlock

# Rename 'Component1' to 'BiCrystal'
selection = PartSelection.Create(GetRootPart().Components[0].Content)
result = RenameObject.Execute(selection,"BiCrystal")
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

# Rename 'Component1' to 'Indenter'
selection = PartSelection.Create(GetRootPart().Components[1].Content)
result = RenameObject.Execute(selection,"Indenter")
# EndBlock

# Merge Bodies
targets = BodySelection.Create(GetRootPart().Components[1].Content.Bodies[0])
tools = BodySelection.Create(GetRootPart().Components[1].Content.Bodies[1])
result = Combine.Merge(targets, tools)
# EndBlock

# Rigid body doesn't exist in Ansys Mechanical and a surface needs to be converted into a body (using 'Pull' tool).
# Then Diamond material can be attributed to the indenter.
# Stitching could be an option to transform a surface into a solid body

# Thicken 2 Faces
selection = FaceSelection.Create([GetRootPart().Components[1].Content.Bodies[0].Faces[0],
    GetRootPart().Components[1].Content.Bodies[0].Faces[1]])
options = ThickenFaceOptions()
result = ThickenFaces.Execute(selection, Direction.Create(-0.258819045102521, 3.16961915143177E-17, -0.965925826289068), MM(-0.08), options)
# EndBlock

# !!! The new merged face seems to be different from the 2 original faces. Less straight and more curvy... !!!
# Create New Face
if mergeFlag:
    selection = FaceSelection.Create([GetRootPart().Components[1].Content.Bodies[0].Faces[0],
        GetRootPart().Components[1].Content.Bodies[0].Faces[1]])
    result = ReplaceFacesWithFace.Execute(selection)
# EndBlock

# Translate Along X Handle
selection = BodySelection.Create(GetRootPart().Components[1].Content.Bodies[0])
direction = Direction.DirX
options = MoveOptions()
result = Move.Translate(selection, direction, UM(distIndSam), options)
# EndBlock


# Rotate Radially About Z Handle
selection = ComponentSelection.Create([GetRootPart().Components[0],
    GetRootPart().Components[1]])
radialAxis = Selection.Create(GetRootPart().CoordinateSystems[0].Axes[2])
direction = Direction.DirZ
anchorPoint = Point.Create(UM(0), UM(0), UM(0))
localAxis = Line.Create(anchorPoint, direction)
options = MoveOptions()
result = Move.RotateRadiallyAboutAxis(selection, radialAxis, localAxis, DEG(angGB), options)
# EndBlock

#############################################
# Share Topology and Save Project
#############################################

# !!!!!! Only for Ansys Mechanical, not supported in Ansys Discovery !!!!!!
# Share Topology
options = ShareTopologyOptions()
options.Tolerance = UM(0)
result = ShareTopology.FindAndFix(options)
# EndBlock

# Save Project As
File.SaveAs(outputPath)
# EndBlock