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
# TYPE OF SIMULATION
#+++++++++++++++++++++++++++++++++++++++++++++
# For Discovery Simulation
mergeFlag = False
shareTopoFlag = False
unitCellFlag = True
DiscoFlag = True

# For Mechanical Simulation
mergeFlag = False
shareTopoFlag = True
unitCellFlag = False
DiscoFlag = False

#+++++++++++++++++++++++++++++++++++++++++++++
# MATERIALS DEFINITION
#+++++++++++++++++++++++++++++++++++++++++++++
# Cu SX indentation - Cacket Large indent
tipRadiusVal = 27 # Radius of the indenter tip in microns
MaterialSX = 'Cu'
cubicCell = True
# Cu SX indentation - Cacket small indent
tipRadiusVal = 7.4 # Radius of the indenter tip in microns
MaterialSX = 'Cu'
cubicCell = True
# Ti alloy
tipRadiusVal = 1.0 # Radius of the indenter tip in microns
MaterialSX = 'TiAlloy'
cubicCell = False

#+++++++++++++++++++++++++++++++++++++++++++++
# PARAMETERS DEFINITION
#+++++++++++++++++++++++++++++++++++++++++++++
# All dimensions are given in microns
#scaleFactor = Parameters.scaleFactor #Activate 'Embed script' and add scaleFactor as a script parameter
scaleFactor = 1e3
tipFactor = 5 # Factor to scale the sample dimensions with respect to the indenter tip radius

# Indenter tip parameters
tipRadius = tipRadiusVal/scaleFactor # Radius of the indenter tip in micron
coneAngle = 120 # Cone angle of the indenter tip in degrees
h_trans = tipRadius*(1-(math.sin(math.radians(coneAngle/2))))
arcXVal = math.pow((math.pow(tipRadius,2)-math.pow(tipRadius-h_trans,2)),0.5)
segXVal = arcXVal + (math.tan(math.radians(coneAngle/2))*(tipRadius-h_trans))

# Sample parameters
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

if DiscoFlag:
    maxZdisp = -1e-01 # Maximum displacement along the z axis in meters
else:
    maxZdisp = -1e-06 # Maximum displacement along the z axis in meters

MaterialIndenter = "Diamond (carbon)"
#"Sapphire (aluminum oxide)"
# "Tungsten carbide"

#+++++++++++++++++++++++++++++++++++++++++++++
# OUTPUT FILE PATH
#+++++++++++++++++++++++++++++++++++++++++++++
outputPath = r"C:\SX_indentationModellig\{}_SX_indentation\SXgeom_Rtip_{}_tipFactor{}.dsco".format(MaterialSX, tipRadiusVal, tipFactor)

#+++++++++++++++++++++++++++++++++++++++++++++
# SAMPLE GEOMETRY
#+++++++++++++++++++++++++++++++++++++++++++++
# ^ z axis
# |
# --> x axis
#
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
if DiscoFlag:
    Window.ActiveWindow.Units.MetricUnits = MetricUnits(MetricLengthUnit.Meters, MetricMassUnit.Grams, AngleUnit.Degrees)
else:
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

ViewHelper.ZoomToEntity()

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
# DESIGN TREE CLEANING
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
# ADD UNIT CELL
#############################################
if unitCellFlag:
    unitCellDim = 0.05*r_sample
    Zrot1 = -32 # Rotation angle about the z axis in degrees
    Yrot1 = -98 # Rotation angle about the y axis in degrees
    Zrot2 = 45 # Rotation angle about the z axis in degrees
    ViewHelper.SetSketchPlane(Plane.PlaneXY, None)

    if cubicCell:
        # Sketch Rectangle
        point1 = Point2D.Create(MM(unitCellDim),MM(unitCellDim))
        point2 = Point2D.Create(MM(-unitCellDim),MM(unitCellDim))
        point3 = Point2D.Create(MM(unitCellDim),MM(-unitCellDim))
        result = SketchRectangle.Create(point1, point2, point3)
    else:
        # Sketch Polygon
        startVertex = Point.Create(MM(0), MM(0), MM(0))
        endVertex = Point.Create(MM(0), MM(unitCellDim), MM(0))
        useInnerRadius = True
        numSides = 6
        result = SketchPolygon.Create(startVertex, endVertex, useInnerRadius, numSides)
    
    # Solidify Sketch
    mode = InteractionMode.Solid
    result = ViewHelper.SetViewMode(mode, None)
    # EndBlock

    # Extrude 1 Face
    selection = FaceSelection.Create(GetRootPart().Bodies[0].Faces[0])
    options = ExtrudeFaceOptions()
    options.ExtrudeType = ExtrudeType.Add
    result = ExtrudeFaces.Execute(selection, MM(2*unitCellDim), options)
    # EndBlock

    # Make Components
    selection = BodySelection.Create(GetRootPart().Bodies[0])
    result = ComponentHelper.MoveBodiesToComponent(selection, None)
    # EndBlock

    # Translate Along X Handle
    selection = ComponentSelection.Create(GetRootPart().Components[2])
    direction = Direction.DirX
    options = MoveOptions()
    result = Move.Translate(selection, direction, MM(0.9*r_sample), options)
    # EndBlock

    # Rotate About Z Handle
    selection = ComponentSelection.Create(GetRootPart().Components[2])
    axis = Move.GetAxis(selection)
    options = MoveOptions()
    result = Move.Rotate(selection, axis, DEG(Zrot1), options)
    # EndBlock

    # Rotate About Y Handle
    selection = ComponentSelection.Create(GetRootPart().Components[2])
    axis = Move.GetAxis(selection, HandleAxis.Y)
    options = MoveOptions()
    result = Move.Rotate(selection, axis, DEG(Yrot1), options)
    # EndBlock

    # Rotate About Z Handle
    selection = ComponentSelection.Create(GetRootPart().Components[2])
    axis = Move.GetAxis(selection)
    options = MoveOptions()
    result = Move.Rotate(selection, axis, DEG(Zrot2), options)
    # EndBlock

    # Rename 'Component1' to 'Unit Cell'
    selection = PartSelection.Create(GetRootPart().Components[2].Content)
    result = RenameObject.Execute(selection,"Unit Cell")
    # EndBlock

#############################################
# MATERIALS AND BOUNDARY CONDITIONS (ONLY FOR DISCOVERY SIMULATION)
#############################################
# Material assignement to the specimen (or to the single crystal)
materialAssignment = Materials.MaterialAssignment.GetByLabel("Structural steel, S275N")
selection = BodySelection.Create([GetRootPart().Components[0].Content.Bodies[3],
	GetRootPart().Components[0].Content.Bodies[0],
	GetRootPart().Components[0].Content.Bodies[1],
	GetRootPart().Components[0].Content.Bodies[2]])
material = Materials.Material.GetLibraryMaterial("Titanium, Grade 1")
result = Materials.MaterialAssignment.Create(selection, material)
# EndBlock

# Material assignement to the specimen (or to the single crystal)
materialAssignment = Materials.MaterialAssignment.GetByLabel("Structural steel, S275N")
material = Materials.Material.GetLibraryMaterial(MaterialIndenter)
materialAssignment.Material = material
# EndBlock

# Apply Fixed Support 1
selection = FaceSelection.Create([GetRootPart().Components[0].Content.Bodies[1].Faces[4],
    GetRootPart().Components[0].Content.Bodies[2].Faces[1]])
result = Conditions.Support.Create(selection, SupportType.Fixed)
# EndBlock

# Enable gravity self-weight
try:
    condition = Conditions.Gravity.GetByLabel("Gravity")
except:
    condition = Conditions.Gravity.GetByLabel("Gravité")
condition.EnableSelfWeight()
# EndBlock

# Apply Sliding Contact 1
contactType = Connections.ContactType.Sliding
selection1 = FaceSelection.Create(GetRootPart().Components[1].Content.Bodies[0].Faces[0])
selection2 = FaceSelection.Create([GetRootPart().Components[0].Content.Bodies[3].Faces[2],
    GetRootPart().Components[0].Content.Bodies[0].Faces[3],
    GetRootPart().Components[0].Content.Bodies[1].Faces[0]])
result = Connections.Contact.Create(selection1, selection2, contactType)
# EndBlock

# Apply Translational Displacement 1
selection = FaceSelection.Create(GetRootPart().Components[1].Content.Bodies[0].Faces[0])
result = Conditions.Displacement.Create(selection)
result.DisplacementType = DisplacementType.Translation
result.DX=LengthQuantity.Create(0, LengthUnit.Meter)
result.DY=LengthQuantity.Create(0, LengthUnit.Meter)
result.DZ=LengthQuantity.Create(maxZdisp, LengthUnit.Meter)
# EndBlock
# !!!!!! Bug = Not working because displacement is defined along the x axis and not the z axis !!!!!!
# Still not correct with the following lines !!!

# Toggle Displacement Degrees Of Freedom Component
try:
    condition = Conditions.Displacement.GetByLabel("Translational Displacement 1")
except:
    condition = Conditions.Displacement.GetByLabel("Translationnel Déplacement 1")
condition.IsDzFree=False
# EndBlock

# Toggle Displacement Degrees Of Freedom Component
try:
    condition = Conditions.Displacement.GetByLabel("Translational Displacement 1")
except:
    condition = Conditions.Displacement.GetByLabel("Translationnel Déplacement 1")
condition.IsDyFree=False
# EndBlock

# Change Displacement Degrees Of Freedom
try:
    condition = Conditions.Displacement.GetByLabel("Translational Displacement 1")
except:
    condition = Conditions.Displacement.GetByLabel("Translationnel Déplacement 1")
length = LengthQuantity.Create(maxZdisp, LengthUnit.Meter)
condition.DZ=length

#############################################
# COLORING OF THE BODIES
#############################################
# Modify Color of the specimen (or of the single crystal)
selection = BodySelection.Create([GetRootPart().Components[0].Content.Bodies[0],
	GetRootPart().Components[0].Content.Bodies[1],
	GetRootPart().Components[0].Content.Bodies[2],
	GetRootPart().Components[0].Content.Bodies[3]])
options = SetColorOptions()
options.EdgeColorTarget = EdgeColorTarget.Undefined
options.FaceColorTarget = FaceColorTarget.Undefined
ColorHelper.SetColor(selection, options, Color.FromArgb(255, 198, 156, 109))
# EndBlock

# Modify Color of the indenter
selection = BodySelection.Create(GetRootPart().Components[1].Content.Bodies[0])
options = SetColorOptions()
options.EdgeColorTarget = EdgeColorTarget.Undefined
options.FaceColorTarget = FaceColorTarget.Undefined
ColorHelper.SetColor(selection, options, Color.FromArgb(255, 105, 105, 105))
# EndBlock

if DiscoFlag:
    # Modify Color of the unit cell
    selection = BodySelection.Create(GetRootPart().Components[2].Content.Bodies[0])
    options = SetColorOptions()
    options.EdgeColorTarget = EdgeColorTarget.Undefined
    options.FaceColorTarget = FaceColorTarget.Undefined
    ColorHelper.SetColor(selection, options, Color.FromArgb(255, 6, 31, 44))
    # EndBlock

#############################################
# REMOVE UNIT CELL FROM SIMULATION
#############################################
if DiscoFlag:
    # Suppress/Unsuppress Physics
    simulation = Solution.Simulation.GetByLabel("Simulation 1")
    selection = BodySelection.Create(GetRootPart().Components[2].Content.Bodies[0])
    simulation.SuppressBodies(selection,True)
    # EndBlock

#############################################
# SHARE TOPOLOGY
#############################################
if shareTopoFlag:
    # !!!!!! Only for Ansys Mechanical, not supported in Ansys Discovery !!!!!!
    # Share Topology
    options = ShareTopologyOptions()
    options.Tolerance = UM(0.2)
    result = ShareTopology.FindAndFix(options)
    # EndBlock

#############################################
# SAVE PROJECT
#############################################
# Save Project As
File.SaveAs(outputPath)
# EndBlock