"""
@author: d.mercier
12/9/2024
"""
#Geometry script made with python script editor from Ansys Mechanical

import math

#+++++++++++++++++++++++++++++++++++++++++++++
# PARAMETERS DEFINITION
#+++++++++++++++++++++++++++++++++++++++++++++
maxZdisp = -1e-06 # Maximum displacement along the z axis in meters

#+++++++++++++++++++++++++++++++++++++++++++++
# INITIALIZATION
#+++++++++++++++++++++++++++++++++++++++++++++
#region UI Action
Model.Name = r"""Indentation_Model"""
#endregion

#+++++++++++++++++++++++++++++++++++++++++++++
# INDENTER SETTINGS
#+++++++++++++++++++++++++++++++++++++++++++++
try:
    # Change indenter solid into a rigid body
    # !! Not possible to apply all kind of BCs to rigid body, only remote displacement !!
    #region Details View Action
    body_29 = DataModel.GetObjectById(29)
    body_29.StiffnessBehavior = StiffnessBehavior.Rigid
    #endregion
except:
    # Assign Diamond material to the indenter
    #region Context Menu Action
    material_assignment_47 = materials_17.AddMaterialAssignment()

    selection = ExtAPI.SelectionManager.CreateSelectionInfo(SelectionTypeEnum.GeometryEntities)
    selection.Ids = [35]
    material_assignment_47.Location = selection
    #endregion

    #region UI Action
    with Transaction(True):
        material_assignment_47.Material = "1b9d544d-9dce-403d-a09d-6cff63f43c1a"
    #endregion

#+++++++++++++++++++++++++++++++++++++++++++++
# SPECIMEN SETTINGS
#+++++++++++++++++++++++++++++++++++++++++++++
try:
    # Assign Steel material to the indenter
    selection = ExtAPI.SelectionManager.CreateSelectionInfo(SelectionTypeEnum.GeometryEntities)
    selection.Ids = [23, 6, 15, 19] # Ids of the specimen's faces might be updated ?
    material_assignment_specimen.Location = selection
    #endregion

    #region UI Action
    with Transaction(True):
        material_assignment_specimen.Material = "9ad48705-5175-473a-930d-1618f64a88f7"
    #endregion
except:
    print("No material assignment for the specimen")

#+++++++++++++++++++++++++++++++++++++++++++++
# CONTACT SETTINGS
#+++++++++++++++++++++++++++++++++++++++++++++
#region Context Menu Action
Model.Connections.CreateAutomaticConnections()
#endregion

#region Details View Action
contact_region_35 = DataModel.GetObjectById(35)
selection = ExtAPI.SelectionManager.CreateSelectionInfo(SelectionTypeEnum.GeometryEntities)
contact_region_35.ContactType = ContactType.Frictionless
#endregion

#region Context Menu Action
analysis_38 = DataModel.GetObjectById(38)
fixed_support_76 = analysis_38.AddFixedSupport()
#endregion

# !!!! Rigid body is invalid for BCs (fixed support, displacement, etc.) !!!!
# Let's use a remote displacement instead
##region Context Menu Action
#displacement_1 = analysis_38.AddDisplacement()
##endregion

#region Context Menu Action
remote_displacement_96 = analysis_38.AddRemoteDisplacement()
remote_displacement_96.ZComponent.Output.SetDiscreteValue(0, Quantity(maxZdisp, "m"))
#endregion

#region Details View Action
remote_displacement_45 = DataModel.GetObjectById(45)
selection = ExtAPI.SelectionManager.CreateSelectionInfo(SelectionTypeEnum.GeometryEntities)
selection.Ids = [33]
remote_displacement_45.Location = selection
#endregion

#region Details View Action
selection = ExtAPI.SelectionManager.CreateSelectionInfo(SelectionTypeEnum.GeometryEntities)
selection.Ids = [28]
displacement_1.Location = selection
#endregion

#+++++++++++++++++++++++++++++++++++++++++++++
# MESH SETTINGS
#+++++++++++++++++++++++++++++++++++++++++++++
mesh_15 = Model.Mesh

#region Context Menu Action
automatic_method_50 = mesh_15.AddAutomaticMethod()
#endregion

#region Details View Action
automatic_method_50.Method = MethodType.MultiZone
#endregion

#region Details View Action
automatic_method_50.DecompositionType = DecompositionType.MedialAxis
#endregion

#+++++++++++++++++++++++++++++++++++++++++++++
# SOLUTIONS SETTINGS
#+++++++++++++++++++++++++++++++++++++++++++++
#region Context Menu Action
solution_39 = DataModel.GetObjectById(39)
total_deformation_82 = solution_39.AddTotalDeformation()
#endregion

#region Context Menu Action
equivalent_stress_83 = solution_39.AddEquivalentStress()
#endregion