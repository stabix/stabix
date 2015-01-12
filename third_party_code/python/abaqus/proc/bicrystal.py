# -*- coding: utf-8 -*-
"""
@authors: D. Mercier / R. Sanchez-Martin / C. Zambaldi
"""

from .base import Proc
from .indenter import Indenter

#import numpy as N # old
import numpy as np
import logging

logger = logging.getLogger('root')
logger.info('logger says : proc.bicrystal_indent')

class BicrystalIndent(Proc, Indenter):
    def __init__(self,
                 modelname = 'Bicrystal_indentation',
                 label = '',  # informative label
                 ori1 = None,  # orientation grain 1
                 ori2 = None,  # orientation grain 2
                 coneAngle = 90.,
                 friction = 0.3,  # Coulomb friction coefficient
                 geo = 'conical',  # angle of the conical indenter in degrees
                 h_indent = 0.3,  # depth of the indent in um
                 tipRadius = 1.4,  # radius of the spherical indenter in um
                 gbn = None,  # grain boundary normal in xyz
                 trace_ang = None,  # 0deg // X, 90deg // Y
                 inclination = None,  # vertical = 90deg, 0.. 90 cuts through grain 1, 90 ..180  through grain 2
                 d = None,  # distance of indent from GB
                 len_trace = None,
                 ind_size = None,
                 #lengthScale = 1.
                 wid = 4,  # width of the sample
                 hei = 4,  # height of the sample
                 len = 4,  # length of the sample
                 box_elm_nx = 4,  # number of elements in x direction
                 box_elm_nz = 4,  # number of elements in z direction
                 box_elm_ny1 = 6,  # number of elements in y direction in the grain B
                 box_elm_ny2_fac = 7,  # parameter which factorized the number of elements in y direction in the middle part
                 box_elm_ny3 = 6,  # number of elements in y direction in the grain A
                 box_bias_x = 0.2,  # bias in the x (width) direction
                 box_bias_z = 0.25,  # bias in the z (height) direction
                 box_bias_y1 = 0.3,  # bias in y direction in the grain B
                 box_bias_y2 = 0,  # bias in y direction in the middle part
                 box_bias_y3 = 0.3,  # bias in y direction in the grain A
                 lvl = 1,  # mesh quality value
                 ind_time = 10.,  # time of loading segment
                 dwell_time = 3,  # not used yet, needs Loadcase "dwell" (included in Abaqus)
                 unload_time = 2, # unload time in seconds (only Abaqus)
                 max_inc_indent = 10000, # maximum number of increments allowed in the simulation (only Abaqus)
                 ini_inc_indent = 0.0001, # initial increment (in seconds) of the calculation (only Abaqus)
                 min_inc_indent_time = 0.000001, # minimum increment (in seconds) allowed in the calculation (only Abaqus)
                 max_inc_indent_time = 0.05, # maximum increment (in seconds) allowed in the calculation (only Abaqus)
                 sep_ind_samp = 0.0005, #Distance between the indenter and the sample before indentation (to initialize contact) (only Abaqus)
                 Dexp = None,  # experimental indent diameter, for visualization purposes only
                 twoDimensional = False,  # 2D indentation model, experimental
                 divideMesh = False,  # subdivide each el. additionally into 8 els.
                 outStep = 5,  # write step for results
                 nSteps = 800,  # LC 'indent', No of increments
                 smv = 0.01,  # small value
                 free_mesh_inp = '', #name of the .inp file for AFM topo for indenter
                 ori_list = None):
        import math

        if ori1 == None:
            ori1 == [0., 0., 0.]
        if ori2 == None:
            ori2 == [0., 0., 0.]

        if ind_size == None: #ind_size = diameter of indent
            if h_indent <= tipRadius * (1 - math.sin((coneAngle / 180. * math.pi) / 2)):
                ind_size = 2. * math.sqrt(h_indent / tipRadius) #for spherical indenter
            else:
                ind_size = 2. * h_indent * math.tan((coneAngle / 180. * math.pi) / 2) #for conical indenter

        if d == None:
        #d = -0.8   # positive = with gbn (i.e. in grain #1 or grain A)
        # negative = against gbn (i.e. grain #2 or grain B)
            #d = np.random.rand()*2.
            #d = 2. * np.random.rand() * ind_size
            d = 2. * (np.random.rand() - 0.5) * ind_size #* lengthScale

        if len_trace == None:
            len_trace = 8. * ind_size #* lengthScale
            # h_sample
            # h_indent
            # len_sample
            # w_sample
            hei = 7. * h_indent
            wid = len_trace

            if inclination <= 90:
                if abs(d) <= (hei * math.tan((90 - inclination) / 180. * math.pi)):
                    len = 6 * (hei * math.tan((90 - inclination) / 180. * math.pi))
                else:
                    len = abs(d) + 3 * (ind_size)
            else:
                if abs(d) <= (hei * math.tan((inclination - 90) / 180. * math.pi)):
                    len = 6 * (hei * math.tan((inclination - 90) / 180. * math.pi))
                else:
                    len = abs(d) + 3 * (ind_size)
            if d == 0:
                len = 4.5 * (ind_size)
                # length in the model is defined later in the code with the variable min_margin

        self.proc = []
        self.start(title='INDENTATION-MODEL (%s) %s' % (modelname, label))
        self.procNewModel(modelname=(modelname))
        self.IndentParameters = {}
        self.IndentParameters['2D'] = False
        self.IndentParameters['D_sample'] = False
        self.IndentParameters['sample_rep'] = False
        self.IndentParameters['coneHalfAngle'] = coneAngle / 2
        self.IndentParameters['coneAngle'] = coneAngle
        self.IndentParameters['h_indent'] = h_indent
        self.IndentParameters['tipRadius'] = tipRadius
        self.IndentParameters['friction'] = friction
        self.IndentParameters['indAxis'] = 'z'
        self.IndentParameters['smv'] = 1e-3
        self.IndentParameters['friction'] = 0.3
        self.IndentParameters['nSteps'] = 800
        self.IndentParameters['outStep'] = 5
        self.IndentParameters['ind_time'] = 10.
        self.IndentParameters['h_sample'] = hei
        self.IndentParameters['w_sample'] = wid
        self.IndentParameters['len_sample'] = len/2
        self.IndentParameters['free_mesh_inp'] = free_mesh_inp
        self.procParameters(modelname = modelname,
                           coneAngle = coneAngle,
                           friction = friction,
                           geo = geo,
                           h_indent = h_indent, # indentation depth
                           tipRadius = tipRadius,
                           label = label,
                           ori1 = ori1, #not used yet
                           ori2 = ori2, # not used yet
                           gbn = gbn,
                           d = d,
                           hei = hei,
                           wid = wid,
                           len = len,
                           trace_ang = trace_ang,
                           inclination = inclination,
                           len_trace = len_trace,
                           ind_size = ind_size,
                           box_elm_nx = box_elm_nx,
                           box_elm_nz = box_elm_nz,
                           box_elm_ny1 = box_elm_ny1,
                           box_elm_ny2_fac = box_elm_ny2_fac,
                           box_elm_ny3 = box_elm_ny3,
                           box_bias_x = box_bias_x,
                           box_bias_z = box_bias_z,
                           box_bias_y1 = box_bias_y1,
                           box_bias_y2 = box_bias_y2,
                           box_bias_y3 = box_bias_y3,
                           lvl = lvl,
                           ind_time = ind_time,
                           dwell_time = dwell_time,
                           unload_time = unload_time,
                           max_inc_indent = max_inc_indent,
                           ini_inc_indent =ini_inc_indent,
                           min_inc_indent_time = min_inc_indent_time,
                           max_inc_indent_time = max_inc_indent_time,
                           sep_ind_samp = sep_ind_samp,
                           Dexp = Dexp,
                           twoDimensional = twoDimensional,
                           divideMesh = divideMesh,
                           outStep = outStep,
                           nSteps = nSteps,
                           smv = smv,
                           free_mesh_inp = free_mesh_inp,
                           ori_list = ori_list)
        if geo == 'conical':
            self.procIndenterConical(coneHalfAngle=self.IndentParameters['coneHalfAngle'])
        if geo == 'flatPunch':
            self.procIndenterFlatPunch(tipRadius=self.IndentParameters['tipRadius'])
        if geo == 'customized':
            self.procIndenterCustomizedTopo(free_mesh_inp=self.IndentParameters['free_mesh_inp'])
        self.procBicrystal(modelname = modelname,
                           coneAngle = coneAngle,
                           friction = friction,
                           geo = geo,
                           h_indent = h_indent, # indentation depth
                           tipRadius = tipRadius,
                           label = label,
                           ori1 = ori1, #not used yet
                           ori2 = ori2, # not used yet
                           gbn = gbn,
                           d = d,
                           hei = hei,
                           wid = wid,
                           len = len,
                           trace_ang = trace_ang,
                           inclination = inclination,
                           len_trace = len_trace,
                           ind_size = ind_size,
                           box_elm_nx = box_elm_nx,
                           box_elm_nz = box_elm_nz,
                           box_elm_ny1 = box_elm_ny1,
                           box_elm_ny2_fac = box_elm_ny2_fac,
                           box_elm_ny3 = box_elm_ny3,
                           box_bias_x = box_bias_x,
                           box_bias_z = box_bias_z,
                           box_bias_y1 = box_bias_y1,
                           box_bias_y2 = box_bias_y2,
                           box_bias_y3 = box_bias_y3,
                           lvl = lvl,
                           ind_time = ind_time,
                           dwell_time = dwell_time,
                           unload_time = unload_time,
                           max_inc_indent = max_inc_indent,
                           ini_inc_indent =ini_inc_indent,
                           min_inc_indent_time = min_inc_indent_time,
                           max_inc_indent_time = max_inc_indent_time,
                           sep_ind_samp = sep_ind_samp,
                           Dexp = Dexp,
                           twoDimensional = twoDimensional,
                           divideMesh = divideMesh,
                           outStep = outStep,
                           nSteps = nSteps,
                           smv = smv,
                           free_mesh_inp = free_mesh_inp,
                           ori_list = ori_list)
        self.procBoundaryConditionsIndent()
        self.procRotationTranslation()
        self.procMaterial()
        self.procSectionsBicrystal()
        self.proc.append('''
final_sample_name = 'Bicrystal-1'
''')
        self.procContactIndent()
        self.procLoadCaseIndent() #nSteps=self.IndentParameters['nSteps']
        self.procJobParameters()
        savename = modelname + '_' + label
        savename += '_fric%.1f' % self.IndentParameters['friction']
        if geo == 'conical':
            savename += '_R%.2f' % self.IndentParameters['tipRadius']
            savename += '_cA%.1f' % self.IndentParameters['coneAngle']
        if geo == 'flatPunch':
            savename += '_R%.2f' % self.IndentParameters['tipRadius']
        if geo == 'customized':
            savename += '_AFMtopo'
        savename += '_h%.3f' % self.IndentParameters['h_indent']
        savename += ['_' + label, ''][label == '']

    def procParameters(self,
                      modelname = None,
                      label = None,
                      ori1 = None, #not used yet
                      ori2 = None, # not used yet
                      gbn = None,
                      coneAngle = None,
                      friction = None,
                      geo = None,
                      h_indent = None,
                      tipRadius = None,
                      d = None,
                      hei = None,
                      wid = None,
                      len = None,
                      trace_ang = None,
                      inclination = None,
                      len_trace = None,
                      ind_size = None,
                      box_elm_nx = None,
                      box_elm_nz = None,
                      box_elm_ny1 = None,
                      box_elm_ny2_fac = None,
                      box_elm_ny3 = None,
                      box_bias_x = None,
                      box_bias_z = None,
                      box_bias_y1 = None,
                      box_bias_y2 = None,
                      box_bias_y3 = None,
                      lvl = None,
                      ind_time = None,
                      dwell_time = None,
                      unload_time = None,
                      max_inc_indent = None,
                      ini_inc_indent = None,
                      min_inc_indent_time = None,
                      max_inc_indent_time = None,
                      sep_ind_samp = None,
                      Dexp = None,
                      twoDimensional = None,
                      divideMesh = None,
                      outStep = None,
                      nSteps = None,
                      smv = None,
                      free_mesh_inp = None,
                      ori_list = None):
        print('trace_ang: ', trace_ang)
        print 'inclination: ', inclination, '(in degrees)'
        print 'd: ', d, '(Distance between indent and GB in um)'
        self.proc.append('''
#+++++++++++++++++++++++++++++++++++++++++++++
# PARAMETERS DEFINITION
#+++++++++++++++++++++++++++++++++++++++++++++
# Cross-section view of the bicrystal (Y-Z plane)
# NB: X-Y plane in Abaqus before rotation/translation !
#
#                distGB
#    d_box       |    |     d_box
#  ______________|____|________________
# |           \  /   /|                |
# |inclination \/   / |                |
# |            /   /  |                |
# | Gr1       /   /   |        Gr2     | height
# |          /   /    |                |
# |         /   /     |                |
# |        /   /      |                |
# |_______/___/_______|________________|
#             |       |
#              d_incgb
#

# SAMPLE
width = %f # width of the sample in um''' % wid + '''
height = %f # height of the sample in um''' % hei + '''
length = %f # length of the sample in um''' % len + '''
trace_ang = %f # trace angle in degrees''' % trace_ang + '''
inclination = %f # gb inclination in degrees''' % inclination + '''
distGB = %f # distance between gb and indenter in um''' % d + '''

if inclination < 90:
    d_incgb = height/tan(radians(inclination))
elif inclination > 90:
    d_incgb = height/tan(radians(180-inclination))
else:
    d_incgb = 0

d_box = (length - abs(distGB))/2

if distGB < 0:
    d_box_A = d_box
    d_box_B = -d_box + distGB
    box_y1 = 0
    box_y2 = distGB
    if inclination < 90:
        box_y3 = d_incgb + distGB
        box_y4 = d_incgb
    elif inclination > 90:
        box_y3 = -d_incgb + distGB
        box_y4 = -d_incgb
    else:
        box_y3 = distGB
        box_y4 = 0
elif distGB > 0:
    d_box_A = d_box + distGB
    d_box_B = -d_box
    box_y1 = distGB
    box_y2 = 0
    if inclination < 90:
        box_y3 = d_incgb
        box_y4 = d_incgb + distGB
    elif inclination > 90:
        box_y3 = -d_incgb
        box_y4 = -d_incgb + distGB
    else:
        box_y3 = 0
        box_y4 = distGB
elif distGB == 0:
    d_box_A = d_box
    d_box_B = -d_box
    box_y1 = 0
    box_y2 = 0
    box_y3 = 0
    box_y4 = 0

# MESH
box_elm_nx = %i''' % box_elm_nx + '''
box_elm_nz = %i''' % box_elm_nz + '''
box_elm_ny1 = %i''' % box_elm_ny1 + '''
box_elm_ny2 = %i''' % box_elm_ny2_fac + '''
box_elm_ny3 = %i''' % box_elm_ny3 + '''
box_bias_x = %i''' % box_bias_x + '''
box_bias_z = %i''' % box_bias_z + '''
box_bias_y1 = %i''' % box_bias_y1 + '''
box_bias_y2 = %i''' % box_bias_y2 + '''
box_bias_y3 = %i''' % box_bias_y3 + '''
linear_elements = 1

# INDENTER VELOCITY, "STRAIN RATE"
# Time used for LoadCase "indentation" (in [seconds] for model in mm)
ind_time = %f  # in [10e-3*seconds] for model in micrometer, gamma0?!!?''' % ind_time + '''
max_inc_indent = %i # maximum number of increments allowed in the simulation (only Abaqus) ''' % max_inc_indent + '''
ini_inc_indent = %f # initial increment (in seconds) of the calculation (only Abaqus) ''' % ini_inc_indent + '''
min_inc_indent_time = %f # minimum increment (in seconds) allowed in the calculation (only Abaqus) ''' % min_inc_indent_time + '''
max_inc_indent_time = %f # maximum increment (in seconds) allowed in the calculation (only Abaqus) ''' % max_inc_indent_time + '''
dwell_time = %f # dwell time in seconds (only Abaqus) ''' % dwell_time + '''
unload_time = %f # unload time in seconds (only Abaqus) ''' % unload_time + '''
sep_ind_samp = %f #Distance between the indenter and the sample before indentation (to initialize contact) ''' % sep_ind_samp + '''
friction = %f # friction coefficient between the sample and the indenter (only Abaqus)''' % friction + '''
freq_field_output = %i #Frequency of the output request (only Abaqus) ''' % outStep + '''
h_indent = %f #Indentation depth in um''' % h_indent + '''

tolerance = 0.01+(float(width)/1500)

# SIZE OF THE SHEET FOR THE SKETCH
if width > height:
    sheet_Size = 2 * width
else:
    sheet_Size = 2 * height
''')

    def procBicrystal(self,
                      modelname = None,
                      label = None,
                      ori1 = None, #not used yet
                      ori2 = None, # not used yet
                      gbn = None,
                      coneAngle = None,
                      friction = None,
                      geo = None,
                      h_indent = None,
                      tipRadius = None,
                      d = None,
                      hei = None,
                      wid = None,
                      len = None,
                      trace_ang = None,
                      inclination = None,
                      len_trace = None,
                      ind_size = None,
                      box_elm_nx = None,
                      box_elm_nz = None,
                      box_elm_ny1 = None,
                      box_elm_ny2_fac = None,
                      box_elm_ny3 = None,
                      box_bias_x = None,
                      box_bias_z = None,
                      box_bias_y1 = None,
                      box_bias_y2 = None,
                      box_bias_y3 = None,
                      lvl = None,
                      ind_time = None,
                      dwell_time = None,
                      unload_time = None,
                      max_inc_indent = None,
                      ini_inc_indent = None,
                      min_inc_indent_time = None,
                      max_inc_indent_time = None,
                      sep_ind_samp = None,
                      freq_field_output = None,
                      Dexp = None,
                      twoDimensional = None,
                      divideMesh = None,
                      outStep = None,
                      nSteps = None,
                      smv = None,
                      free_mesh_inp = None,
                      ori_list = None):
        self.proc.append('''
#+++++++++++++++++++++++++++++++++++++++++++++
# SAMPLE GEOMETRY
#+++++++++++++++++++++++++++++++++++++++++++++
p = model_name.Part(name='Bicrystal', dimensionality=THREE_D, type=DEFORMABLE_BODY)
s = model_name.ConstrainedSketch(name='__profile__', sheetSize=sheet_Size)
g, v, d, c = s.geometry, s.vertices, s.dimensions, s.constraints
s.setPrimaryObject(option=STANDALONE)

if distGB == 0:
    s.Line(point1=(d_box_A, 0), point2=(box_y1, 0))
    s.Line(point1=(box_y1, 0), point2=(d_box_B, 0))
    s.Line(point1=(d_box_B, 0), point2=(d_box_B, -height))
    s.Line(point1=(d_box_B, -height), point2=(box_y2, -height))
    s.Line(point1=(box_y2, -height), point2=(d_box_A, -height))
    s.Line(point1=(d_box_A, -height), point2=(d_box_A, 0))
else:
    s.Line(point1=(d_box_A, 0), point2=(box_y1, 0))
    s.Line(point1=(box_y1, 0), point2=(box_y2, 0))
    s.Line(point1=(box_y2, 0), point2=(d_box_B, 0))
    s.Line(point1=(d_box_B, 0), point2=(d_box_B, -height))
    s.Line(point1=(d_box_B, -height), point2=(box_y3, -height))
    s.Line(point1=(box_y3, -height), point2=(box_y4, -height))
    s.Line(point1=(box_y4, -height), point2=(d_box_A, -height))
    s.Line(point1=(d_box_A, -height), point2=(d_box_A, 0))

p = model_name.Part(name='Bicrystal', dimensionality=THREE_D, type=DEFORMABLE_BODY)
p = model_name.parts['Bicrystal']
p.BaseSolidExtrude(sketch=s, depth=width)
s.unsetPrimaryObject()
p = model_name.parts['Bicrystal']
session.viewports['Viewport: 1'].setValues(displayedObject=p)
del model_name.sketches['__profile__']

#+++++++++++++++++++++++++++++++++++++++++++++
# CELLS DEFINITION
#+++++++++++++++++++++++++++++++++++++++++++++
p = model_name.parts['Bicrystal']
c = p.cells
pickedCells = c.getSequenceFromMask(mask=('[#1 ]', ), )
v, e, d = p.vertices, p.edges, p.datums
p.PartitionCellByPlaneThreePoints(point1=v[10], point2=v[7], point3=v[4], cells=pickedCells)
if distGB != 0:
    pickedCells = c.getSequenceFromMask(mask=('[#2 ]', ), )
    v, e, d = p.vertices, p.edges, p.datums
    p.PartitionCellByPlaneThreePoints(point1=v[14], point2=v[7], point3=v[4], cells=pickedCells)

#+++++++++++++++++++++++++++++++++++++++++++++
# SETS/SURFACES DEFINITION
#+++++++++++++++++++++++++++++++++++++++++++++
p = model_name.parts['Bicrystal']

c = p.cells
if distGB != 0:
    #cells = c.getSequenceFromMask(mask=('[#1 ]', ), )
    cells = c.findAt(((d_box_A, 0, 0), ))   #Arbitrary ???
    region = p.Set(cells=cells, name='Grain1')
    cells = c.findAt(((d_box_B, 0, 0), ))   #Arbitrary ???
    region = p.Set(cells=cells, name='Grain2')

if distGB > 0:
    cells = c.findAt(((distGB / 2, 0, 0), )) #Arbitrary ???
    region = p.Set(cells=cells, name='Grain1_GB')
elif distGB < 0:
    cells = c.findAt(((distGB / 2, 0, 0), )) #Arbitrary ???
    region = p.Set(cells=cells, name='Grain2_GB')

e = p.edges
p.PartitionEdgeByPoint(edge=e.findAt(coordinates=(d_box_A, 0, width/2)),
    point=p.InterestingPoint(edge=e.findAt(coordinates=(d_box_A, 0, width/2)),
    rule=MIDDLE))
p.PartitionEdgeByPoint(edge=e.findAt(coordinates=(d_box_B, 0, width/2)),
    point=p.InterestingPoint(edge=e.findAt(coordinates=(d_box_B, 0, width/2)),
    rule=MIDDLE))
p.PartitionEdgeByPoint(edge=e.findAt(coordinates=(box_y1, 0, width/2)),
    point=p.InterestingPoint(edge=e.findAt(coordinates=(box_y1, 0, width/2)),
    rule=MIDDLE))
p.PartitionEdgeByPoint(edge=e.findAt(coordinates=(box_y2, 0, width/2)),
    point=p.InterestingPoint(edge=e.findAt(coordinates=(box_y2, 0, width/2)),
    rule=MIDDLE))
p.PartitionEdgeByPoint(edge=e.findAt(coordinates=(d_box_A, -height, width/2)),
    point=p.InterestingPoint(edge=e.findAt(coordinates=(d_box_A, -height, width/2)),
    rule=MIDDLE))
p.PartitionEdgeByPoint(edge=e.findAt(coordinates=(d_box_B, -height, width/2)),
    point=p.InterestingPoint(edge=e.findAt(coordinates=(d_box_B, -height, width/2)),
    rule=MIDDLE))
p.PartitionEdgeByPoint(edge=e.findAt(coordinates=(box_y3, -height, width/2)),
    point=p.InterestingPoint(edge=e.findAt(coordinates=(box_y3, -height, width/2)),
    rule=MIDDLE))
p.PartitionEdgeByPoint(edge=e.findAt(coordinates=(box_y4, -height, width/2)),
    point=p.InterestingPoint(edge=e.findAt(coordinates=(box_y4, -height, width/2)),
    rule=MIDDLE))

edges = e.findAt(((d_box_A, 0, width/4), ), ((d_box_B, 0, width/4), ),
    ((box_y1, 0, width/4), ), ((box_y2, 0, width/4), ),
    ((d_box_A, -height, width/4), ), ((d_box_B, -height, width/4), ),
    ((box_y3, -height, width/4), ), ((box_y4, -height, width/4), ))
p.Set(edges=edges, name='edges_x_neg')
edges = e.findAt(((d_box_A, 0, 3*width/4), ), ((d_box_B, 0, 3*width/4), ),
    ((box_y1, 0, 3*width/4), ), ((box_y2, 0, 3*width/4), ),
    ((d_box_A, -height, 3*width/4), ), ((d_box_B, -height, 3*width/4), ),
    ((box_y3, -height, 3*width/4), ), ((box_y4, -height, 3*width/4), ))
p.Set(edges=edges, name='edges_x_pos')
edges = e.findAt(((d_box_A, -height/2, 0), ), ((d_box_B, -height/2, 0), ),
    (((box_y1 + box_y4)/2, -height/2, 0), ), (((box_y2 + box_y3)/2, -height/2, 0), ),
    ((d_box_A, -height/2, width), ), ((d_box_B, -height/2, width), ),
    (((box_y1 + box_y4)/2, -height/2, width), ), (((box_y2 + box_y3)/2, -height/2, width), ))
p.Set(edges=edges, name='edges_z')
edges = e.findAt((((d_box_A + box_y1)/2, 0, 0), ), (((d_box_A + box_y4)/2, -height, 0), ),
    (((d_box_A + box_y1)/2, 0, width), ), (((d_box_A + box_y4)/2, -height, width), ))
p.Set(edges=edges, name='edges_y1')
edges = e.findAt((((box_y1 + box_y2)/2, 0, 0), ), (((box_y4 + box_y3)/2, -height, 0), ),
    (((box_y1 + box_y2)/2, 0, width), ), (((box_y4 + box_y3)/2, -height, width), ))
p.Set(edges=edges, name='edges_y2')
edges = e.findAt((((box_y2 + d_box_B)/2, 0, 0), ), (((box_y3 + d_box_B)/2, -height, 0), ),
    (((box_y2 + d_box_B)/2, 0, width), ), (((box_y3 + d_box_B)/2, -height, width), ))
p.Set(edges=edges, name='edges_y3')

f = p.faces
faces = f.findAt((((d_box_A + box_y1)/2, 0, width/2), ), (((box_y1 + box_y2)/2, 0, width/2), ),
    (((box_y2 + d_box_B)/2, 0, width/2), ))
p.Set(faces=faces, name='Surf-top')
faces = f.findAt((((d_box_A + box_y3)/2, -height, width/2), ), (((box_y3 + box_y4)/2, -height, width/2), ),
    (((box_y4 + d_box_B)/2, -height, width/2), ))
p.Set(faces=faces, name='Surf-bottom')
faces = f.findAt((((d_box_A + box_y1)/2 + d_incgb/2, -height/2, 0), ),
    (((box_y1 + box_y3)/2, -height/2, 0), ), (((box_y3 + d_box_B)/2 + d_incgb/2, -height/2, 0), ),
    ((d_box_A, -height/2, width/2), ), ((d_box_B, -height/2, width/2), ),
    (((d_box_A + box_y1)/2 + d_incgb/2, -height/2, width), ),
    (((box_y1 + box_y3)/2, -height/2, width), ), (((box_y3 + d_box_B)/2 + d_incgb/2, -height/2, width), ))
p.Set(faces=faces, name='Surf-sides')

side1Faces = f.findAt((((d_box_A + box_y1)/2, 0, width/2), ), (((box_y1 + box_y2)/2, 0, width/2), ),
    (((box_y2 + d_box_B)/2, 0, width/2), ))
p.Surface(side1Faces=side1Faces, name='Surf Sample')
p.Set(faces=faces, name='Surf Sample')

#+++++++++++++++++++++++++++++++++++++++++++++
# REFERENCE POINT
#+++++++++++++++++++++++++++++++++++++++++++++
p = model_name.parts['Bicrystal']
v = p.vertices
p.ReferencePoint(point=v.findAt(coordinates=(distGB, 0.0, width/2)))
r = p.referencePoints
refPoints=(r[26], ) #Function of the partitions done before
p.Set(referencePoints=refPoints, name='Set-RP')

#+++++++++++++++++++++++++++++++++++++++++++++
# INSTANCES DEFINITION
#+++++++++++++++++++++++++++++++++++++++++++++
a = model_name.rootAssembly
a.DatumCsysByDefault(CARTESIAN)
p = model_name.parts['Bicrystal']
a.Instance(name='Bicrystal-1', part=p, dependent=OFF)

#+++++++++++++++++++++++++++++++++++++++++++++
# SEEDS FOR MESH
#+++++++++++++++++++++++++++++++++++++++++++++
a = model_name.rootAssembly
e = a.instances['Bicrystal-1'].edges

# NB: pickedEdges1 and pickedEdges2 used for direction of bias

# edge_x_neg
pickedEdges1 = e.findAt(((box_y4, -height, width/4), ), ((box_y2, 0, width/4), ))
pickedEdges2 = e.findAt(((d_box_A, 0, width/4), ), ((d_box_B, 0, width/4), ),
    ((box_y1, 0, width/4), ), ((d_box_A, -height, width/4), ),
    ((box_y3, -height, width/4), ), ((d_box_B, -height, width/4), ))
a.seedEdgeByBias(biasMethod=SINGLE, end1Edges=pickedEdges1, end2Edges=pickedEdges2,
    ratio=box_bias_x, number=box_elm_nx, constraint=FINER)

# edge_x_pos
pickedEdges2 = e.findAt(((box_y4, -height, 3*width/4), ), ((box_y2, 0, 3*width/4), ))
pickedEdges1 = e.findAt(((d_box_A, 0, 3*width/4), ), ((d_box_B, 0, 3*width/4), ),
    ((box_y1, 0, 3*width/4), ), ((d_box_A, -height, 3*width/4), ),
    ((box_y3, -height, 3*width/4), ), ((d_box_B, -height, 3*width/4), ))
a.seedEdgeByBias(biasMethod=SINGLE, end1Edges=pickedEdges1, end2Edges=pickedEdges2,
    ratio=box_bias_x, number=box_elm_nx, constraint=FINER)

# edge_z
pickedEdges1 = e.findAt(((d_box_B, -height/2, 0), ), (((box_y2 + box_y3)/2, -height/2, 0), ),
    ((d_box_A, -height/2, width), ), (((box_y1 + box_y4)/2, -height/2, width), ))
pickedEdges2 = e.findAt(((d_box_A, -height/2, 0), ), (((box_y1 + box_y4)/2, -height/2, 0), ),
    ((d_box_B, -height/2, width), ), (((box_y2 + box_y3)/2, -height/2, width), ))
a.seedEdgeByBias(biasMethod=SINGLE, end1Edges=pickedEdges1, end2Edges=pickedEdges2,
    ratio=box_bias_z, number=box_elm_nz, constraint=FINER)

# edge_y1
pickedEdges1 = e.findAt((((d_box_A + box_y4)/2, -height, 0), ), (((d_box_A + box_y1)/2, 0, width), ))
pickedEdges2 = e.findAt((((d_box_A + box_y1)/2, 0, 0), ), (((d_box_A + box_y4)/2, -height, width), ))
a.seedEdgeByBias(biasMethod=SINGLE, end1Edges=pickedEdges1, end2Edges=pickedEdges2,
    ratio=box_bias_y1, number=box_elm_ny1, constraint=FINER)

if distGB > 0:
    # edge_y2
    pickedEdges1 = e.findAt((((box_y4 + box_y3)/2, -height, 0), ), (((box_y1 + box_y2)/2, 0, width), ))
    pickedEdges2 = e.findAt((((box_y1 + box_y2)/2, 0, 0), ), (((box_y4 + box_y3)/2, -height, width), ))
    a.seedEdgeByBias(biasMethod=SINGLE, end1Edges=pickedEdges1, end2Edges=pickedEdges2,
        ratio=box_bias_y2, number=box_elm_ny2, constraint=FINER)
elif distGB < 0:
    # edge_y2
    pickedEdges1 = e.findAt((((box_y1 + box_y2)/2, 0, 0), ), (((box_y4 + box_y3)/2, -height, width), ))
    pickedEdges2 = e.findAt((((box_y4 + box_y3)/2, -height, 0), ), (((box_y1 + box_y2)/2, 0, width), ))
    a.seedEdgeByBias(biasMethod=SINGLE, end1Edges=pickedEdges1, end2Edges=pickedEdges2,
        ratio=box_bias_y2, number=box_elm_ny2, constraint=FINER)

# edge_y3
pickedEdges1 = e.findAt((((box_y2 + d_box_B)/2, 0, 0), ), (((box_y3 + d_box_B)/2, -height, width), ))
pickedEdges2 = e.findAt((((box_y3 + d_box_B)/2, -height, 0), ), (((box_y2 + d_box_B)/2, 0, width), ))
a.seedEdgeByBias(biasMethod=SINGLE, end1Edges=pickedEdges1, end2Edges=pickedEdges2,
    ratio=box_bias_y3, number=box_elm_ny3, constraint=FINER)

#+++++++++++++++++++++++++++++++++++++++++++++
# MESHING
#+++++++++++++++++++++++++++++++++++++++++++++
a = model_name.rootAssembly
partInstances =(a.instances['Bicrystal-1'], )
a.generateMesh(regions=partInstances)

if linear_elements == 1:
    # Linear elements
    elemType1 = mesh.ElemType(elemCode=C3D8, elemLibrary=STANDARD,
        secondOrderAccuracy=OFF, distortionControl=DEFAULT)
    elemType2 = mesh.ElemType(elemCode=C3D6, elemLibrary=STANDARD)
    elemType3 = mesh.ElemType(elemCode=C3D4, elemLibrary=STANDARD)
else:
    # Quadratic elements
    elemType1 = mesh.ElemType(elemCode=C3D20, elemLibrary=STANDARD,
        secondOrderAccuracy=OFF, distortionControl=DEFAULT)
    elemType2 = mesh.ElemType(elemCode=C3D15, elemLibrary=STANDARD)
    elemType3 = mesh.ElemType(elemCode=C3D10, elemLibrary=STANDARD)

c = a.instances['Bicrystal-1'].cells
cells1 = c.findAt((((d_box_A + box_y1)/2, -height/2, width/2), ), (((box_y1 + box_y2)/2, -height/2, width/2),
    ), (((box_y3 + d_box_B)/2, -height/2, width/2), ))
pickedRegions =(cells1, )
a.setElementType(regions=pickedRegions, elemTypes=(elemType1, ))
''')

    def procBoundaryConditionsIndent(self):
        self.proc.append('''
#+++++++++++++++++++++++++++++++++++++++++++++
# BOUNDARIES CONDITIONS
#+++++++++++++++++++++++++++++++++++++++++++++
a = model_name.rootAssembly

region = a.instances['Bicrystal-1'].sets['Surf-bottom']
model_name.EncastreBC(name='BC_bottom', createStepName='Initial', region=region)

region = a.instances['Bicrystal-1'].sets['Surf-sides']
model_name.EncastreBC(name='BC_sides', createStepName='Initial', region=region)
''')

    def procRotationTranslation(self):
        self.proc.append('''
#+++++++++++++++++++++++++++++++++++++++++++++
# ROTATION / TRANSLATION
#+++++++++++++++++++++++++++++++++++++++++++++
a = model_name.rootAssembly

# Translation to set the reference point to (0,0,0)
a.translate(instanceList=('Bicrystal-1', ), vector=(-distGB, 0, -width/2))

# Rotations to set correctly the xyz coordinate system
a.rotate(instanceList=('Bicrystal-1', ), axisPoint=(0, 0, 0), axisDirection=(1, 0, 0), angle=90.0)
a.rotate(instanceList=('Bicrystal-1', ), axisPoint=(0, 0, 0), axisDirection=(0, 0, 1), angle=90.0)

# Rotation for the trace angle
if trace_ang !=0:
    a.rotate(instanceList=('Bicrystal-1', ), axisPoint=(0, 0, 0), axisDirection=(0.0, 0.0, 1.0), angle=trace_ang)
''')

    def procSectionsBicrystal(self):
        self.proc.append('''
#+++++++++++++++++++++++++++++++++++++++++++++
# SECTIONS DEFINITION
#+++++++++++++++++++++++++++++++++++++++++++++
model_name.HomogeneousSolidSection(name='Section_Grain1', material='ElastoPlastic_Material-1', thickness=None)
model_name.HomogeneousSolidSection(name='Section_Grain2', material='ElastoPlastic_Material-2', thickness=None)
if distGB > 0:
    model_name.HomogeneousSolidSection(name='Section_Grain1-GB', material='ElastoPlastic_Material-1', thickness=None)
elif distGB < 0:
    model_name.HomogeneousSolidSection(name='Section_Grain2-GB', material='ElastoPlastic_Material-2', thickness=None)

p = model_name.parts['Bicrystal']

set1 = p.sets['Grain1']
p.SectionAssignment(region=set1, sectionName='Section_Grain1',
    offset=0.0, offsetType=MIDDLE_SURFACE, offsetField='',
    thicknessAssignment=FROM_SECTION)

set3 = p.sets['Grain2']
p.SectionAssignment(region=set3, sectionName='Section_Grain2',
    offset=0.0, offsetType=MIDDLE_SURFACE, offsetField='',
    thicknessAssignment=FROM_SECTION)

if distGB > 0:
    set2 = p.sets['Grain1_GB']
    p.SectionAssignment(region=set2, sectionName='Section_Grain1-GB',
        offset=0.0, offsetType=MIDDLE_SURFACE, offsetField='',
        thicknessAssignment=FROM_SECTION)
elif distGB < 0:
    set2 = p.sets['Grain2_GB']
    p.SectionAssignment(region=set2, sectionName='Section_Grain2-GB',
    offset=0.0, offsetType=MIDDLE_SURFACE, offsetField='',
    thicknessAssignment=FROM_SECTION)

a.regenerate()
''')