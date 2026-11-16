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

outputPath = r"C:\SX_indentationModellig\Cu_SX_indentation\Indentergeom_Cu_Rtip_{}.dsco".format(tipRadiusVal)

#+++++++++++++++++++++++++++++++++++++++++++++
# PARAMETERS DEFINITION
#+++++++++++++++++++++++++++++++++++++++++++++
# All dimensions are given in microns
scaleFactor = 1e3
z_ini = 0
tipRadius = tipRadiusVal/scaleFactor # Radius of the indenter tip in micron
coneAngle = 120 # Cone angle of the indenter tip in degrees
h_trans = tipRadius*(1-(math.sin(math.radians(coneAngle/2))))
arcXVal = math.pow((math.pow(tipRadius,2)-math.pow(tipRadius-h_trans,2)),0.5)
segXVal = arcXVal + (math.tan(math.radians(coneAngle/2))*(tipRadius-h_trans))
RevolDegree = 360 # Used for the revolve operation

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
# INDENTER GEOMETRY
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

ViewHelper.ZoomToEntity()

# Merge Bodies
targets = Body1
tools = Body2
result = Combine.Merge(targets, tools, Info1)
# EndBlock

# Fill
selection = Edge1
secondarySelection = Selection.Empty()
options = FillOptions()
result = Fill.Execute(selection, secondarySelection, options, FillMode.ThreeD, Info2)
# EndBlock

#############################################
# Save Project
#############################################

# Save Project As
File.SaveAs(outputPath)
# EndBlock