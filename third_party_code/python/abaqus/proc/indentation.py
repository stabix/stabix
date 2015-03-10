# -*- coding: utf-8 -*-
"""
@authors: R. Sanchez-Martin / C. Zambaldi / D. Mercier
"""

from tools import Tools
from .indenter import Indenter
import logging

logger = logging.getLogger('root')
logger.info('logger says : proc.indent')

class Indentation(Indenter, Tools):
    """ Generates an Abaqus Python file for indentation simulation.
        The implemented mesh geometries were used in the following references:
            C. Zambaldi, F. Roters, D. Raabe, U. Glatzel (2007) Modeling and
            experiments on the indentation deformation and recrystallization of
            a single-crystal nickel-base superalloy, Mater. Sci. Engr. A 454 433-440,
            doi: 10.1016/j.msea.2006.11.068

            C. Zambaldi, D. Raabe (2010) Plastic anisotropy of gamma-TiAl
            revealed by axisymmetric indentation, Acta Mater. 58(9) 3516-3530,
            doi: 10.1016/j.actamat.2010.02.025

            C. Zambaldi, Y. Yang, T.R. Bieler, D. Raabe (2012) Orientation
            informed nanoindentation of alpha-titanium: Indentation pileup
            in hexagonal metals deforming by prismatic slip, JMR, 27(1), 356-367,
            doi: 10.1557/jmr.2011.334
    """

    def __init__(self,
                modelname = 'SX_indentation',
                h_indent = 0.20,  # maximum simulated indentation depth
                D_sample = 2.,  # diameter of sample
                h_sample = None,  # sample height, only for overriding default estimate
                geo = 'conical',  # indenter geometry
                coneAngle = 90,  # full cone angle (deg)
                tipRadius = 1,  # indenter tip radius
                friction = 0.3,  # Coulomb friction coefficient
                sample_rep = 24,  # 16, 24, 32, 48 # number of segments,
                                 # must be dividable by 8 if used with r_center_frac != 0
                r_center_frac = 0.25,  # if >0 ==>insert a cylindrical column of brick
                                      # elements in the center to avoid collapsed elements
                                      # under the indenter
                box_xfrac = 0.3,  # size of the finer mesh box in horizontal direction
                box_zfrac = 0.2,  # ... in vertical dimension
                box_elm_nx = 5,  # number of horizontal elements in box
                box_elm_nz = 5,  # number of vertical elements in box
                box_bias_x = 0.25,  # bias in x direction
                box_bias_z = 0.25,  # bias in z direction
                box_bias_conv_x = 0.25,  # bias in x direction for the outer cylinder
                radial_divi = 5,  # radial subdivisions of the outer part of the model
                ind_time = 10.,  # time of loading segment
                dwell_time = 3,  # not used yet, needs Loadcase "dwell" (included in Abaqus)
                unload_time = 2, # unload time in seconds (only Abaqus)
                max_inc_indent = 10000, # maximum number of increments allowed in the simulation (only Abaqus)
                ini_inc_indent = 0.0001, # initial increment (in seconds) of the calculation (only Abaqus)
                min_inc_indent_time = 0.000001, # minimum increment (in seconds) allowed in the calculation (only Abaqus)
                max_inc_indent_time = 0.05, # maximum increment (in seconds) allowed in the calculation (only Abaqus)
                sep_ind_samp = 0.0005, # distance between the indenter and the sample before indentation (to initialize contact) (only Abaqus)
                Dexp = None,  # experimental indent diameter, for visualization purposes only
                twoDimensional = False,  # 2D indentation model, experimental
                divideMesh = False,  # subdivide each el. additionally into 8 els.
                outStep = 5,  # write step for results
                nSteps = 800,  # LC 'indent', No of increments
                smv = 0.01,  # small value
                label = '',
                free_mesh_inp = '', # name of the .inp file for AFM topo for indenter
                ori_list = None):
        self.callerDict = locals()
        if r_center_frac is not 0 and sample_rep not in [8, 16, 24, 32, 40, 48, 56]:
            print('For r_center_frac not 0, sample_rep needs to be dividable by 8')
            sample_rep = 24
            print('sample_rep=', sample_rep)
            # create dictionary of parameters
        self.IndentParameters = {
            'modelname': modelname,
            'coneAngle': coneAngle,
            'coneHalfAngle': coneAngle / 2.,
            'tipRadius': tipRadius,
            'friction': friction,
            'geo': geo,
            'h_indent': h_indent, # indentation depth
            'sample_rep': sample_rep,
            'r_center_frac': r_center_frac, # avoid collapsed elements in center by values>0
            'box_xfrac': box_xfrac, # lateral fraction of fine meshed box
            'box_zfrac': box_zfrac, # vertical fraction of fine meshed box
            'box_elm_nx': box_elm_nx, # lateral subdivisions of fine meshed box
            'box_elm_nz': box_elm_nz, # vertical subdivisions of fine meshed box
            'box_bias_x': box_bias_x,  # bias in x direction
            'box_bias_z': box_bias_z,  # bias in z direction
            'box_bias_conv_x': box_bias_conv_x,  # bias in x direction for the outer cylinder
            'radial_divi': radial_divi,
            'D_sample': D_sample, # not yet implemented, governed by h_indent
            'h_sample': h_sample,
            'ind_time': ind_time, # in seconds, since dotgamma_0 is in perSecond
            'dwell_time': dwell_time, # time at maximum load
            'max_inc_indent': max_inc_indent, # maximum number of increments allowed in the simulation (only Abaqus)
            'ini_inc_indent': ini_inc_indent, # initial increment (in seconds) of the calculation (only Abaqus)
            'min_inc_indent_time': min_inc_indent_time, # minimum increment (in seconds) allowed in the calculation (only Abaqus)
            'max_inc_indent_time': max_inc_indent_time, # maximum increment (in seconds) allowed in the calculation (only Abaqus)
            'unload_time': unload_time, # unload time in seconds (only Abaqus)
            'sep_ind_samp': sep_ind_samp, #Distance between the indenter and the sample before indentation (to initialize contact) (only Abaqus)
            'Dexp': Dexp, # experimental remaining indent diameter
            'indAxis': 'z', # however, indDirection is -z
            '2D': twoDimensional, #2D model flag
            'divideMesh': divideMesh, # refine by additional subdivisions
            'outStep': outStep,  # post increment write step
            'nSteps': nSteps,  # number of increments for indentation to hmax
            'smv': smv,  # small length for node selection
            'free_mesh_inp': free_mesh_inp, #name of the .inp file for AFM topo for indenter
            'label': label
        }
        if twoDimensional:
            self.IndentParameters['indAxis'] = 'y'
        print(repr(self.IndentParameters))
        self.proc = []
        self.start(title='INDENTATION-MODEL (%s) %s' % (modelname, label))
        self.procNewModel(modelname=self.IndentParameters['modelname'])
        self.procParametersIndent()
        self.procSampleIndent()
        self.procInstance()
        self.procMeshParameters()
        self.procSampleMeshing()
        self.procBoundaryConditionsIndent()
        self.procMaterial()
        #self.procElastoPlasticMaterial # for elasto-plastic material
        self.procSectionsIndent()
        if geo == 'conical':
            self.procIndenterConical(coneHalfAngle=self.IndentParameters['coneHalfAngle'])
        if geo == 'flatPunch':
            self.procIndenterFlatPunch(tipRadius=self.IndentParameters['tipRadius'])
        if geo == 'customized':
            self.procIndenterCustomizedTopo(free_mesh_inp=self.IndentParameters['free_mesh_inp'])
        self.proc.append('''
final_sample_name = 'Final Sample-1'
''')
        self.procContactIndent()
        self.procRefPointIndenter()
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
        if Dexp is not None:
            self.procExpIndent(D=Dexp, Z=h_indent)
        self.write_dat()
        if ori_list is not None:
            for ori in ori_list:
                self.proc_copy_job(jobname='ori', number=ori)
                #TODO needs update in initial conditions

    def procParametersIndent(self):
        if self.IndentParameters['h_sample'] is None:
            self.IndentParameters['h_sample'] = h_indent * 12.
        if self.IndentParameters['D_sample'] is not None:
            dSamp = self.IndentParameters['D_sample']
        elif self.IndentParameters['Dexp'] is not None:
            dSamp = self.IndentParameters['Dexp'] * 4.6
        else:
            dSamp = 20 * self.IndentParameters['h_indent'] # 90deg~20*
        self.proc.append('''
#+++++++++++++++++++++++++++++++++++++++++++++
# PARAMETERS DEFINITION
#+++++++++++++++++++++++++++++++++++++++++++++
# SAMPLE
D_sample = %f''' % dSamp + '''
r_sample = D_sample/2
h_sample = %f
''' % self.IndentParameters['h_sample'] +
#d_sample = 20*h_indent  # Berkovich
#d_samp>!7*d_indentation
#d_sample = 16*h_indent  # CubeCorner
#h_sample = 12*h_indent  # Berkovich
#h_sample = 14*h_indent  # large tip radii
#h_sample = 10*h_indent  # CubeCorner
# large tip radii
'''
# MESH
r_center_frac = %f #0 to 1 # if >0 ==>insert a cylindrical column of brick elements in the centre to avoid collapsed elements under the indenter''' % (self.IndentParameters['r_center_frac']) + '''
box_xfrac = %f  # size of the finer mesh box in horizontal direction''' % (self.IndentParameters['box_xfrac']) + '''
box_zfrac = %f  # ... in vertical dimension''' % (self.IndentParameters['box_zfrac']) + '''
box_bias_x = %f  # bias in x direction''' % (self.IndentParameters['box_bias_x']) + '''
box_bias_z = %f  # bias in z direction''' % (self.IndentParameters['box_bias_z']) + '''
box_bias_conv_x = %f  # bias in x direction for the outer cylinder''' % (self.IndentParameters['box_bias_conv_x']) + '''
box_elm_nx = %i # number of horizontal elements in box''' % (self.IndentParameters['box_elm_nx']) + '''
box_elm_nz = %i # number of vertical elements in box''' % (self.IndentParameters['box_elm_nz']) + '''
smv = %f''' % (self.IndentParameters['smv']) + '''
radial_divi = %i # number of horizontal elements between the big sample and the box''' % (self.IndentParameters['radial_divi']) + '''
c_divi = 2 # subdivisions of the core sample in the radial direction
sample_rep = %i # 24 No of Sample Sectors...''' % (self.IndentParameters['sample_rep']) + '''
sectors_45 = sample_rep/8
# Sector Angle is 360/sample_rep...
# 12=>30 deg, 16=>22.5 deg, 18=>20 deg, 24=>15 deg, 36=>10 deg, 72=>5 deg
linear_elements = 1

# INDENTER VELOCITY, "STRAIN RATE"
# Time used for LoadCase "indentation" (in [seconds] for model in mm)
ind_time = %f  # in [10e-3*seconds] for model in micrometer, gamma0?!!?''' % (self.IndentParameters['ind_time']) + '''
max_inc_indent  = %i # maximum number of increments allowed in the simulation (only Abaqus) ''' % (self.IndentParameters['max_inc_indent']) + '''
ini_inc_indent = %f # initial increment (in seconds) of the calculation (only Abaqus) ''' % (self.IndentParameters['ini_inc_indent']) + '''
min_inc_indent_time = %f # minimum increment (in seconds) allowed in the calculation (only Abaqus) ''' % (self.IndentParameters['min_inc_indent_time']) + '''
max_inc_indent_time = %f # maximum increment (in seconds) allowed in the calculation (only Abaqus) ''' % (self.IndentParameters['max_inc_indent_time']) + '''
dwell_time = %f # dwell time in seconds (only Abaqus) ''' % (self.IndentParameters['dwell_time']) + '''
unload_time = %f # unload time in seconds (only Abaqus) ''' % (self.IndentParameters['unload_time']) + '''
sep_ind_samp = %f #Distance between the indenter and the sample before indentation (to initialize contact) ''' % (self.IndentParameters['sep_ind_samp']) + '''
friction =  %f # friction coefficient between the sample and the indenter (only Abaqus)''' % (self.IndentParameters['friction']) + '''
freq_field_output = %i #Frequency of the output request (only Abaqus) ''' % (self.IndentParameters['outStep']) + '''
h_indent = %f #Indentation depth in um''' % self.IndentParameters['h_indent'] + '''

tolerance = 0.01+(float(D_sample)/1500)

orphanMesh = 0

# SIZE OF THE SHEET FOR THE SKETCH
if D_sample > h_sample:
    sheet_Size = 2 * D_sample
else:
    sheet_Size = 2 * h_sample''')

    def procSampleIndent(self):
        self.proc.append('''
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
#define sample large initial

sample_large_ini = model_name.Part(name= 'Sample_Large_Ini', dimensionality=THREE_D, type=DEFORMABLE_BODY)
    
p = model_name.parts['Sample_Large_Ini']
s = model_name.ConstrainedSketch(name='__profile__', sheetSize=sheet_Size)
    
g, v, d, c = s.geometry, s.vertices, s.dimensions, s.constraints
s.setPrimaryObject(option=STANDALONE)

number_points_base_sample_large = 8*sectors_45
points_base_sample_large = [[0for i in range(2)] for j in 
    range(number_points_base_sample_large)]

for i in range(number_points_base_sample_large):
    points_base_sample_large[i][0] = \
        0.5*D_sample*cos(i*(2*pi/number_points_base_sample_large))
    points_base_sample_large[i][1] = \
        0.5*D_sample*sin(i*(2*pi/number_points_base_sample_large))

for i in range(number_points_base_sample_large-1):
    s.Line(point1=(points_base_sample_large[i][0], \
        points_base_sample_large[i][1]), \
            point2=(points_base_sample_large[i+1][0], \
                points_base_sample_large[i+1][1]))

s.Line(point1=(points_base_sample_large[-1][0], \
    points_base_sample_large[-1][1]), \
        point2=(points_base_sample_large[0][0], \
            points_base_sample_large[0][1]))

p = model_name.Part(name='Sample_Large_Ini', dimensionality=THREE_D, type=DEFORMABLE_BODY)
p = model_name.parts['Sample_Large_Ini']
p.BaseSolidExtrude(sketch=s, depth=h_sample)
s.unsetPrimaryObject()
p = model_name.parts['Sample_Large_Ini']

#define sample small initial
sample_small_ini = model_name.Part(name=
    'Sample_Small_Ini', dimensionality=THREE_D,
    type=DEFORMABLE_BODY)

p = model_name.parts['Sample_Small_Ini']
s = model_name.ConstrainedSketch(name='__profile__', 
    sheetSize=sheet_Size)
    
g, v, d, c = s.geometry, s.vertices, s.dimensions, s.constraints
s.setPrimaryObject(option=STANDALONE)

number_points_base_sample_small = 8*sectors_45
points_base_sample_small = [[0for i in range(2)] for j in 
    range(number_points_base_sample_small)]

for i in range(number_points_base_sample_small):
    points_base_sample_small[i][0] = \
        box_xfrac*0.5*D_sample*cos(i*(2*pi/number_points_base_sample_small))
    points_base_sample_small[i][1] = \
        box_xfrac*0.5*D_sample*sin(i*(2*pi/number_points_base_sample_small))

for i in range(number_points_base_sample_small-1):
    s.Line(point1=(points_base_sample_small[i][0], \
        points_base_sample_small[i][1]), \
            point2=(points_base_sample_small[i+1][0], \
                points_base_sample_small[i+1][1]))

s.Line(point1=(points_base_sample_small[-1][0], \
    points_base_sample_small[-1][1]), \
        point2=(points_base_sample_small[0][0], \
            points_base_sample_small[0][1]))

p = model_name.Part(name='Sample_Small_Ini', dimensionality=THREE_D, type=DEFORMABLE_BODY)
p = model_name.parts['Sample_Small_Ini']
p.BaseSolidExtrude(sketch=s, depth=box_zfrac*h_sample)
s.unsetPrimaryObject()
p = model_name.parts['Sample_Small_Ini']

#define core sample top
core_sample = model_name.Part(name= 'Core_Sample_Top', dimensionality=THREE_D, type=DEFORMABLE_BODY)

p = model_name.parts['Core_Sample_Top']
s = model_name.ConstrainedSketch(name='__profile__', sheetSize=sheet_Size)
g, v, d, c = s.geometry, s.vertices, s.dimensions, s.constraints
s.setPrimaryObject(option=STANDALONE)

number_points_base_core_sample_top = 8*sectors_45
points_base_core_sample_top = [[0for i in range(2)] for j in 
    range(number_points_base_core_sample_top)]

for i in range(number_points_base_core_sample_top):
    points_base_core_sample_top[i][0] = \
        r_center_frac*box_xfrac*0.5*D_sample*cos(i*(2*pi/number_points_base_core_sample_top))
    points_base_core_sample_top[i][1] = \
        r_center_frac*box_xfrac*0.5*D_sample*sin(i*(2*pi/number_points_base_core_sample_top))

for i in range(number_points_base_core_sample_top-1):
    s.Line(point1=(points_base_core_sample_top[i][0], \
        points_base_core_sample_top[i][1]), \
            point2=(points_base_core_sample_top[i+1][0], \
                points_base_core_sample_top[i+1][1]))

s.Line(point1=(points_base_core_sample_top[-1][0], \
    points_base_core_sample_top[-1][1]), \
        point2=(points_base_core_sample_top[0][0], \
            points_base_core_sample_top[0][1]))

p = model_name.Part(name='Core_Sample_Top', dimensionality=THREE_D, type=DEFORMABLE_BODY)
p = model_name.parts['Core_Sample_Top']
p.BaseSolidExtrude(sketch=s, depth=h_sample*box_zfrac)
s.unsetPrimaryObject()
p = model_name.parts['Core_Sample_Top']

#define core sample top inner
core_sample_top_inner = model_name.Part(name='Core_Sample_Top_Inner', dimensionality=THREE_D, type=DEFORMABLE_BODY)
    
p = model_name.parts['Core_Sample_Top_Inner']
s = model_name.ConstrainedSketch(name='__profile__', sheetSize=sheet_Size)
g, v, d, c = s.geometry, s.vertices, s.dimensions, s.constraints
s.setPrimaryObject(option=STANDALONE)

number_points_base_core_sample_top_inner = 8
points_base_core_sample_top_inner = [[0for i in range(2)] for j in 
    range(number_points_base_core_sample_top_inner)]

for i in range(number_points_base_core_sample_top_inner):
    if i%2 == 0:
        radius = D_sample*0.5*box_xfrac*r_center_frac/c_divi
        points_base_core_sample_top_inner[i][0] = \
            radius*cos(i*(2*pi/number_points_base_core_sample_top_inner))
        points_base_core_sample_top_inner[i][1] = \
            radius*sin(i*(2*pi/number_points_base_core_sample_top_inner))
    else:
        radius = D_sample*0.5*box_xfrac*r_center_frac/c_divi*1.131371
        points_base_core_sample_top_inner[i][0] = \
            radius*cos(i*(2*pi/number_points_base_core_sample_top_inner))
        points_base_core_sample_top_inner[i][1] = \
            radius*sin(i*(2*pi/number_points_base_core_sample_top_inner))

for i in range(number_points_base_core_sample_top_inner-1):
    s.Line(point1=(points_base_core_sample_top_inner[i][0], \
        points_base_core_sample_top_inner[i][1]), \
            point2=(points_base_core_sample_top_inner[i+1][0], \
                points_base_core_sample_top_inner[i+1][1]))

s.Line(point1=(points_base_core_sample_top_inner[-1][0], \
    points_base_core_sample_top_inner[-1][1]), \
        point2=(points_base_core_sample_top_inner[0][0], \
            points_base_core_sample_top_inner[0][1]))

p = model_name.Part(name='Core_Sample_Top_Inner', dimensionality=THREE_D, type=DEFORMABLE_BODY)
p = model_name.parts['Core_Sample_Top_Inner']
p.BaseSolidExtrude(sketch=s, depth=h_sample*box_zfrac)
s.unsetPrimaryObject()
p = model_name.parts['Core_Sample_Top_Inner']

#define core sample button
core_sample = model_name.Part(name= 'Core_Sample_Bottom', dimensionality=THREE_D, type=DEFORMABLE_BODY)
  
p = model_name.parts['Core_Sample_Bottom']
s = model_name.ConstrainedSketch(name='__profile__', sheetSize=sheet_Size)
g, v, d, c = s.geometry, s.vertices, s.dimensions, s.constraints
s.setPrimaryObject(option=STANDALONE)

number_points_base_core_sample_bottom = 8*sectors_45
points_base_core_sample_bottom = [[0for i in range(2)] for j in 
    range(number_points_base_core_sample_bottom)]

for i in range(number_points_base_core_sample_bottom):
    points_base_core_sample_bottom[i][0] = \
        r_center_frac*box_xfrac*0.5*D_sample*cos(i*(2*pi/number_points_base_core_sample_bottom))
    points_base_core_sample_bottom[i][1] = \
        r_center_frac*box_xfrac*0.5*D_sample*sin(i*(2*pi/number_points_base_core_sample_bottom))

for i in range(number_points_base_core_sample_bottom-1):
    s.Line(point1=(points_base_core_sample_bottom[i][0], \
        points_base_core_sample_bottom[i][1]), \
            point2=(points_base_core_sample_bottom[i+1][0], \
                points_base_core_sample_bottom[i+1][1]))

s.Line(point1=(points_base_core_sample_bottom[-1][0], \
    points_base_core_sample_bottom[-1][1]), \
        point2=(points_base_core_sample_bottom[0][0], \
            points_base_core_sample_bottom[0][1]))

p = model_name.Part(name='Core_Sample_Bottom', dimensionality=THREE_D, type=DEFORMABLE_BODY)
p = model_name.parts['Core_Sample_Bottom']
p.BaseSolidExtrude(sketch=s, depth=h_sample*(1-box_zfrac))
s.unsetPrimaryObject()
p = model_name.parts['Core_Sample_Bottom']

#define core sample bottom inner
core_sample_bottom_inner = model_name.Part(name='Core_Sample_Bottom_Inner',dimensionality=THREE_D,type=DEFORMABLE_BODY)
    
p = model_name.parts['Core_Sample_Bottom_Inner']
s = model_name.ConstrainedSketch(name='__profile__', sheetSize=sheet_Size)
g, v, d, c = s.geometry, s.vertices, s.dimensions, s.constraints
s.setPrimaryObject(option=STANDALONE)

number_points_base_core_sample_bottom_inner = 8
points_base_core_sample_bottom_inner = [[0for i in range(2)] for j in 
    range(number_points_base_core_sample_bottom_inner)]

for i in range(number_points_base_core_sample_bottom_inner):
    if i%2 == 0:
        radius = D_sample*0.5*box_xfrac*r_center_frac/c_divi
        points_base_core_sample_bottom_inner[i][0] = \
            radius*cos(i*(2*pi/number_points_base_core_sample_bottom_inner))
        points_base_core_sample_bottom_inner[i][1] = \
            radius*sin(i*(2*pi/number_points_base_core_sample_bottom_inner))
    else:
        radius = D_sample*0.5*box_xfrac*r_center_frac/c_divi*1.131371
        points_base_core_sample_bottom_inner[i][0] = \
            radius*cos(i*(2*pi/number_points_base_core_sample_bottom_inner))
        points_base_core_sample_bottom_inner[i][1] = \
            radius*sin(i*(2*pi/number_points_base_core_sample_bottom_inner))

for i in range(number_points_base_core_sample_bottom_inner-1):
    s.Line(point1=(points_base_core_sample_bottom_inner[i][0], \
        points_base_core_sample_bottom_inner[i][1]), \
            point2=(points_base_core_sample_bottom_inner[i+1][0], \
                points_base_core_sample_bottom_inner[i+1][1]))

s.Line(point1=(points_base_core_sample_bottom_inner[-1][0], \
    points_base_core_sample_bottom_inner[-1][1]), \
        point2=(points_base_core_sample_bottom_inner[0][0], \
            points_base_core_sample_bottom_inner[0][1]))

p = model_name.Part(name='Core_Sample_Bottom_Inner', 
    dimensionality=THREE_D, type=DEFORMABLE_BODY)
p = model_name.parts['Core_Sample_Bottom_Inner']
p.BaseSolidExtrude(sketch=s, depth=h_sample*(1-box_zfrac))
s.unsetPrimaryObject()
p = model_name.parts['Core_Sample_Bottom_Inner']''')

    def procInstance(self):
        self.proc.append('''
#+++++++++++++++++++++++++++++++++++++++++++++
# INSTANCES DEFINITION
#+++++++++++++++++++++++++++++++++++++++++++++
InstanceRoot = model_name.rootAssembly
session.viewports['Viewport: 1'].setValues(displayedObject=InstanceRoot)
InstanceRoot .DatumCsysByDefault(CARTESIAN)
p = model_name.parts['Sample_Large_Ini']
InstanceRoot .Instance(name='Sample_Large_Ini-1', part=p, dependent=ON)
p = model_name.parts['Sample_Small_Ini']
InstanceRoot .Instance(name='Sample_Small_Ini-1', part=p, dependent=ON)
InstanceRoot .translate(instanceList=('Sample_Large_Ini-1', ), vector=(0.0, 0.0, -h_sample))
InstanceRoot .translate(instanceList=('Sample_Small_Ini-1', ), vector=(0.0, 0.0, -box_zfrac*h_sample))
InstanceRoot .InstanceFromBooleanCut(name='Sample_Large_Inter', 
    instanceToBeCut=model_name.rootAssembly.instances['Sample_Large_Ini-1'],
    cuttingInstances=(InstanceRoot .instances['Sample_Small_Ini-1'], ), 
    originalInstances=SUPPRESS)

p = model_name.parts['Core_Sample_Top']
InstanceRoot .Instance(name='Core_Sample_Top-1', part=p, dependent=ON)
InstanceRoot .translate(instanceList=('Core_Sample_Top-1', ), vector=(0.0, 0.0, -box_zfrac*h_sample))

p = model_name.parts['Core_Sample_Bottom']
InstanceRoot .Instance(name='Core_Sample_Bottom-1', part=p, dependent=ON)
InstanceRoot .translate(instanceList=('Core_Sample_Bottom-1', ), vector=(0.0, 0.0, -h_sample))

InstanceRoot.InstanceFromBooleanCut(name='Sample_Large_Def', 
    instanceToBeCut=model_name.rootAssembly.instances['Sample_Large_Inter-1'],
    cuttingInstances=(InstanceRoot .instances['Core_Sample_Bottom-1'], ), 
    originalInstances=SUPPRESS)

InstanceRoot.features['Core_Sample_Bottom-1'].resume()
InstanceRoot.features['Sample_Small_Ini-1'].resume()

InstanceRoot.InstanceFromBooleanCut(name='Sample_Small_Def', 
    instanceToBeCut=model_name.rootAssembly.instances['Sample_Small_Ini-1'], 
    cuttingInstances=(InstanceRoot.instances['Core_Sample_Top-1'], ), 
    originalInstances=SUPPRESS)

InstanceRoot.features['Core_Sample_Top-1'].resume()

p = model_name.parts['Core_Sample_Bottom_Inner']
InstanceRoot.Instance(name='Core_Sample_Bottom_Inner-1', part=p, dependent=ON)
InstanceRoot.translate(instanceList=('Core_Sample_Bottom_Inner-1', ), vector=(0.0, 0.0, -h_sample))
    
p = model_name.parts['Core_Sample_Top_Inner']
InstanceRoot.Instance(name='Core_Sample_Top_Inner-1', part=p, dependent=ON)
InstanceRoot.translate(instanceList=('Core_Sample_Top_Inner-1', ), vector=(0.0, 0.0, -h_sample*box_zfrac))
    
InstanceRoot.InstanceFromBooleanCut(name='Core_Sample_Top_Outer', 
    instanceToBeCut=model_name.rootAssembly.instances['Core_Sample_Top-1'], 
    cuttingInstances=(InstanceRoot.instances['Core_Sample_Top_Inner-1'], ), 
    originalInstances=SUPPRESS)
InstanceRoot = model_name.rootAssembly
InstanceRoot.features['Core_Sample_Top_Inner-1'].resume()
    
InstanceRoot.InstanceFromBooleanCut(name='Core_Sample_Bottom_Outer', 
    instanceToBeCut=model_name.rootAssembly.instances['Core_Sample_Bottom-1'], 
    cuttingInstances=(InstanceRoot.instances['Core_Sample_Bottom_Inner-1'], ), 
    originalInstances=SUPPRESS)
InstanceRoot = model_name.rootAssembly
InstanceRoot.features['Core_Sample_Bottom_Inner-1'].resume()''')

    def procSampleMeshing(self):
        self.proc.append('''
#+++++++++++++++++++++++++++++++++++++++++++++
# SAMPLE-MODELING AND MESHING
#+++++++++++++++++++++++++++++++++++++++++++++
# Meshing Sample Small Def
p = model_name.parts['Sample_Small_Def']
c, v, e, d = p.cells, p.vertices, p.edges, p.datums

for i in range(0, 4*sectors_45):
    radius = 0.5*D_sample*box_xfrac*(1+r_center_frac)*0.5
    pickedCells = c.findAt(((radius*cos(pi/(4*sectors_45)*i+pi/200), radius*sin(pi/(4*sectors_45)*i+pi/200), \
        -0.5*box_zfrac*h_sample), ))
    p.PartitionCellByPlaneThreePoints(
        point1=v.findAt(coordinates=(box_xfrac*D_sample*0.5*cos(pi/(4*sectors_45)*i), box_xfrac*D_sample*0.5*sin(pi/(4*sectors_45)*i), 0.0)),
        point2=v.findAt(coordinates=(r_center_frac*box_xfrac*D_sample*0.5*cos(pi/(4*sectors_45)*i), r_center_frac*box_xfrac*D_sample*0.5*sin(pi/(4*sectors_45)*i), 0.0)), cells=pickedCells,
        point3=p.InterestingPoint(edge=e.findAt(coordinates=(box_xfrac*D_sample*0.5*cos(pi/(4*sectors_45)*i), box_xfrac*D_sample*0.5*sin(pi/(4*sectors_45)*i),-0.5*box_zfrac*h_sample)),
        rule=MIDDLE))

for i in range(4*sectors_45+1, 8*sectors_45):
    radius = 0.5*D_sample*box_xfrac*(1+r_center_frac)*0.5
    pickedCells = c.findAt(((radius*cos(pi/(4*sectors_45)*i+pi/200), radius*sin(pi/(4*sectors_45)*i+pi/200), \
        -0.5*box_zfrac*h_sample), ))
    p.PartitionCellByPlaneThreePoints(
        point1=v.findAt(coordinates=(box_xfrac*D_sample*0.5*cos(pi/(4*sectors_45)*i), box_xfrac*D_sample*0.5*sin(pi/(4*sectors_45)*i), 0.0)),
        point2=v.findAt(coordinates=(r_center_frac*box_xfrac*D_sample*0.5*cos(pi/(4*sectors_45)*i), r_center_frac*box_xfrac*D_sample*0.5*sin(pi/(4*sectors_45)*i), 0.0)), cells=pickedCells,
        point3=p.InterestingPoint(edge=e.findAt(coordinates=(box_xfrac*D_sample*0.5*cos(pi/(4*sectors_45)*i), box_xfrac*D_sample*0.5*sin(pi/(4*sectors_45)*i),-0.5*box_zfrac*h_sample)),
        rule=MIDDLE))

for i in range(0, 8*sectors_45):
    if i == 4*sectors_45:
        pickedEdges1 = e.findAt((((r_center_frac*box_xfrac*D_sample*0.5+0.02)*cos(pi/(4*sectors_45)*i),
            (r_center_frac*box_xfrac*D_sample*0.5+0.02)*sin(pi/(4*sectors_45)*i), 0), ))
        p.seedEdgeByBias(biasMethod=SINGLE,
            end1Edges=pickedEdges1, ratio=box_bias_x, number=box_elm_nx, constraint=FIXED)
    else:
        pickedEdges2 = e.findAt((((r_center_frac*box_xfrac*D_sample*0.5+0.02)*cos(pi/(4*sectors_45)*i),
            (r_center_frac*box_xfrac*D_sample*0.5+0.02)*sin(pi/(4*sectors_45)*i), 0), ))
        p.seedEdgeByBias(biasMethod=SINGLE,
            end2Edges=pickedEdges2, ratio=box_bias_x, number=box_elm_nx, constraint=FIXED)

for i in range(0, 8*sectors_45):
    if i == 4*sectors_45:
        pickedEdges2 = e.findAt((((r_center_frac*box_xfrac*D_sample*0.5+0.02)*cos(pi/(4*sectors_45)*i),
            (r_center_frac*box_xfrac*D_sample*0.5+0.02)*sin(pi/(4*sectors_45)*i), -box_zfrac*h_sample), ))
        p.seedEdgeByBias(biasMethod=SINGLE,
            end2Edges=pickedEdges2, ratio=box_bias_x, number=box_elm_nx, constraint=FIXED)
    else:
        pickedEdges1 = e.findAt((((r_center_frac*box_xfrac*D_sample*0.5+0.02)*cos(pi/(4*sectors_45)*i),
            (r_center_frac*box_xfrac*D_sample*0.5+0.02)*sin(pi/(4*sectors_45)*i), -box_zfrac*h_sample), ))
        p.seedEdgeByBias(biasMethod=SINGLE,
            end1Edges=pickedEdges1, ratio=box_bias_x, number=box_elm_nx, constraint=FIXED)

r = [0, 0]
angle = pi/(sectors_45*8)
for i in range(8*sectors_45):
    r = box_xfrac*D_sample*0.5*cos(angle)
    pickedEdges = e.findAt(((r*cos(angle*(2*i+1)), r*sin(angle*(2*i+1)), 0.0), ))
    p.seedEdgeByNumber(edges=pickedEdges, number=1, constraint=FIXED)

for i in range(8*sectors_45):
    r = box_xfrac*D_sample*0.5*r_center_frac*cos(angle)
    pickedEdges = e.findAt(((r*cos(angle*(2*i+1)), r*sin(angle*(2*i+1)), 0.0), ))
    p.seedEdgeByNumber(edges=pickedEdges, number=1, constraint=FIXED)

for i in range(8*sectors_45):
    r = box_xfrac*D_sample*0.5*cos(angle)
    pickedEdges = e.findAt(((r*cos(angle*(2*i+1)), r*sin(angle*(2*i+1)), -box_zfrac*h_sample), ))
    p.seedEdgeByNumber(edges=pickedEdges, number=1, constraint=FIXED)

for i in range(8*sectors_45):
    r = box_xfrac*D_sample*0.5*r_center_frac*cos(angle)
    pickedEdges = e.findAt(((r*cos(angle*(2*i+1)), r*sin(angle*(2*i+1)), -box_zfrac*h_sample), ))
    p.seedEdgeByNumber(edges=pickedEdges, number=1, constraint=FIXED)

angle = pi/(sectors_45*4)
for i in range(8*sectors_45):
    r = box_xfrac*D_sample*0.5
    pickedEdges2 = e.findAt(((r*cos(angle*i), r*sin(angle*i), -0.5*box_zfrac*h_sample), ))
    p.seedEdgeByBias(biasMethod=SINGLE,
        end2Edges=pickedEdges2, ratio=box_bias_z, number=box_elm_nz, constraint=FIXED)

for i in range(8*sectors_45):
    r = box_xfrac*D_sample*0.5*r_center_frac
    pickedEdges2 = e.findAt(((r*cos(angle*i), r*sin(angle*i), -0.5*box_zfrac*h_sample), ))
    p.seedEdgeByBias(biasMethod=SINGLE,
        end2Edges=pickedEdges2, ratio=box_bias_z, number=box_elm_nz, constraint=FIXED)

r = (1+r_center_frac)*0.5*D_sample*0.5*box_xfrac
cells = c.findAt(((r, 0.0, -h_sample*box_zfrac*0.5), ))
pickedRegions =(cells, )
p.setElementType(regions=pickedRegions, elemTypes=(elemType1, elemType2, elemType3))
p = model_name.parts['Sample_Small_Def']
p.generateMesh()
#---------------------------------------------
# Meshing Sample Large Def

for i in range(0, 4*sectors_45):
    p = model_name.parts['Sample_Large_Def']
    c, v, e, d = p.cells, p.vertices, p.edges, p.datums
    pickedCells = c.findAt((((1+box_xfrac)*0.5*D_sample*0.5*cos(pi/(4*sectors_45)*i+pi/200),
        (1+box_xfrac)*0.5*D_sample*0.5*sin(pi/(4*sectors_45)*i+pi/200), \
        -0.5*h_sample), ))
    p.PartitionCellByPlaneThreePoints(
        point1=v.findAt(coordinates=(D_sample*0.5*cos(pi/(4*sectors_45)*i), D_sample*0.5*sin(pi/(4*sectors_45)*i), 0.0)),
        point2=v.findAt(coordinates=(box_xfrac*D_sample*0.5*cos(pi/(4*sectors_45)*i), box_xfrac*D_sample*0.5*sin(pi/(4*sectors_45)*i), 0.0)), cells=pickedCells,
        point3=p.InterestingPoint(edge=e.findAt(coordinates=(D_sample*0.5*cos(pi/(4*sectors_45)*i), D_sample*0.5*sin(pi/(4*sectors_45)*i),-0.5*h_sample)),
        rule=MIDDLE))

for i in range(4*sectors_45+1, 8*sectors_45):
    p = model_name.parts['Sample_Large_Def']
    c, v, e, d = p.cells, p.vertices, p.edges, p.datums
    pickedCells = c.findAt((((1+box_xfrac)*0.5*D_sample*0.5*cos(pi/(4*sectors_45)*i+pi/200),
        (1+box_xfrac)*0.5*D_sample*0.5*sin(pi/(4*sectors_45)*i+pi/200), \
        -0.5*h_sample), ))
    p.PartitionCellByPlaneThreePoints(
        point1=v.findAt(coordinates=(D_sample*0.5*cos(pi/(4*sectors_45)*i), D_sample*0.5*sin(pi/(4*sectors_45)*i), 0.0)),
        point2=v.findAt(coordinates=(box_xfrac*D_sample*0.5*cos(pi/(4*sectors_45)*i), box_xfrac*D_sample*0.5*sin(pi/(4*sectors_45)*i), 0.0)), cells=pickedCells,
        point3=p.InterestingPoint(edge=e.findAt(coordinates=(D_sample*0.5*cos(pi/(4*sectors_45)*i), D_sample*0.5*sin(pi/(4*sectors_45)*i),-0.5*h_sample)),
        rule=MIDDLE))

for i in range (8*sectors_45):
    p = model_name.parts['Sample_Large_Def']
    c, v, e, d = p.cells, p.vertices, p.edges, p.datums
    angle = pi/(4*sectors_45)
    r_cell = 0.5*0.5*D_sample*(1+box_xfrac)
    pickedCells = c.findAt(((r_cell*cos((i+0.5)*angle), r_cell*sin((i+0.5)*angle), -h_sample*box_zfrac), ))
    v, e, d = p.vertices, p.edges, p.datums
    r = D_sample*0.5*box_xfrac
    angle = pi/(4*sectors_45)
    p.PartitionCellByPlaneThreePoints(
        point1=v.findAt(coordinates=(r*cos(i*angle), r*sin(i*angle), -h_sample*box_zfrac)),
        point2=v.findAt(coordinates=(r*cos((i+1)*angle), r*sin((i+1)*angle), -h_sample*box_zfrac)),
        point3=v.findAt(coordinates=(0.5*D_sample*cos(i*angle), 0.5*D_sample*sin(i*angle), -h_sample)), cells=pickedCells)

p = model_name.parts['Sample_Large_Def']
c, v, e, d = p.cells, p.vertices, p.edges, p.datums

angle = pi/(4*sectors_45)

for i in range(0, 8*sectors_45):
    radius = 0.5*0.5*D_sample*(1+box_xfrac)
    if i == 4*sectors_45:
        pickedEdges1 = e.findAt(((radius*cos(i*angle), radius*sin(i*angle), 0), ))
        p.seedEdgeByBias(biasMethod=SINGLE,
            end1Edges=pickedEdges1, ratio=box_bias_conv_x, number=radial_divi, constraint=FIXED)
    else:
        pickedEdges2 = e.findAt(((radius*cos(i*angle), radius*sin(i*angle), 0), ))
        p.seedEdgeByBias(biasMethod=SINGLE,
            end2Edges=pickedEdges2, ratio=box_bias_conv_x, number=radial_divi, constraint=FIXED)

for i in range(0, 8*sectors_45):
    radius = 0.5*0.5*D_sample*(1+r_center_frac)*box_xfrac
    if i == 4*sectors_45:
        pickedEdges1 = e.findAt(((radius*cos(i*angle), radius*sin(i*angle), -h_sample*box_zfrac), ))
        p.seedEdgeByBias(biasMethod=SINGLE,
            end1Edges=pickedEdges1, ratio=box_bias_x, number=box_elm_nx, constraint=FIXED)
    else:
        pickedEdges2 = e.findAt(((radius*cos(i*angle), radius*sin(i*angle), -h_sample*box_zfrac), ))
        p.seedEdgeByBias(biasMethod=SINGLE,
            end2Edges=pickedEdges2, ratio=box_bias_x, number=box_elm_nx, constraint=FIXED)

for i in range(8*sectors_45):
    r = box_xfrac*D_sample*0.5
    pickedEdges2 = e.findAt(((r*cos(angle*i), r*sin(angle*i), -0.5*box_zfrac*h_sample), ))
    p.seedEdgeByBias(biasMethod=SINGLE,
        end2Edges=pickedEdges2, ratio=box_bias_z, number=box_elm_nz, constraint=FIXED)

for i in range(8*sectors_45):
    r = D_sample*0.5
    pickedEdges2 = e.findAt(((r*cos(angle*i), r*sin(angle*i), -0.5*h_sample), ))
    p.seedEdgeByBias(biasMethod=SINGLE,
        end2Edges=pickedEdges2, ratio=box_bias_z, number=box_elm_nz, constraint=FIXED)

for i in range(8*sectors_45):
    r = D_sample*0.5*box_xfrac*r_center_frac
    pickedEdges2 = e.findAt(((r*cos(angle*i), r*sin(angle*i), -0.5*(1+box_zfrac)*h_sample), ))
    p.seedEdgeByBias(biasMethod=SINGLE,
        end2Edges=pickedEdges2, ratio=box_bias_conv_x, number=radial_divi, constraint=FIXED)

for i in range(8*sectors_45):
    if i != 4*sectors_45:
        r = 0.25*D_sample*(1+box_xfrac)
        pickedEdges2 = e.findAt(((r*cos(angle*i), r*sin(angle*i), -0.5*(1+box_zfrac)*h_sample), ))
        p.seedEdgeByBias(biasMethod=SINGLE,
            end2Edges=pickedEdges2, ratio=box_bias_conv_x, number=radial_divi, constraint=FIXED)
    else:
        r = 0.25*D_sample*(1+box_xfrac)
        pickedEdges1 = e.findAt(((r*cos(angle*i), r*sin(angle*i), -0.5*(1+box_zfrac)*h_sample), ))
        p.seedEdgeByBias(biasMethod=SINGLE,
            end1Edges=pickedEdges1, ratio=box_bias_conv_x, number=radial_divi, constraint=FIXED)

angle = pi/(sectors_45*8)

for i in range(8*sectors_45):
    r = D_sample*0.5*cos(angle)
    pickedEdges = e.findAt(((r*cos(angle*(2*i+1)), r*sin(angle*(2*i+1)), 0.0), ))
    p.seedEdgeByNumber(edges=pickedEdges, number=1, constraint=FIXED)

for i in range(8*sectors_45):
    r = D_sample*0.5*cos(angle)
    pickedEdges = e.findAt(((r*cos(angle*(2*i+1)), r*sin(angle*(2*i+1)), -h_sample), ))
    p.seedEdgeByNumber(edges=pickedEdges, number=1, constraint=FIXED)

for i in range(8*sectors_45):
    r = D_sample*0.5*cos(angle)*box_xfrac
    pickedEdges = e.findAt(((r*cos(angle*(2*i+1)), r*sin(angle*(2*i+1)), 0.0), ))
    p.seedEdgeByNumber(edges=pickedEdges, number=1, constraint=FIXED)

for i in range(8*sectors_45):
    r = D_sample*0.5*cos(angle)*box_xfrac
    pickedEdges = e.findAt(((r*cos(angle*(2*i+1)), r*sin(angle*(2*i+1)), -h_sample*box_zfrac), ))
    p.seedEdgeByNumber(edges=pickedEdges, number=1, constraint=FIXED)

for i in range(8*sectors_45):
    r = D_sample*0.5*cos(angle)*box_xfrac*r_center_frac
    pickedEdges = e.findAt(((r*cos(angle*(2*i+1)), r*sin(angle*(2*i+1)), -h_sample*box_zfrac), ))
    p.seedEdgeByNumber(edges=pickedEdges, number=1, constraint=FIXED)

for i in range(8*sectors_45):
    r = D_sample*0.5*cos(angle)*box_xfrac*r_center_frac
    pickedEdges = e.findAt(((r*cos(angle*(2*i+1)), r*sin(angle*(2*i+1)), -h_sample), ))
    p.seedEdgeByNumber(edges=pickedEdges, number=1, constraint=FIXED)

angle = pi/(4*sectors_45)

for i in range(8*sectors_45):
    r_cell = 0.5*0.5*D_sample*(1+box_xfrac)
    cells = c.findAt(((r_cell*cos((i+0.5)*angle), r_cell*sin((i+0.5)*angle), -h_sample*box_zfrac), ))
    pickedRegions =(cells, )
    p.setElementType(regions=pickedRegions, elemTypes=(elemType1, elemType2, elemType3))
    p.generateMesh(regions=pickedRegions)

for i in range(8*sectors_45):
    r_cell = 0.5*0.5*D_sample*(1+r_center_frac)*box_xfrac
    z_select = -h_sample*0.5*(1+2*box_zfrac)
    cells = c.findAt(((r_cell*cos((i+0.5)*angle), r_cell*sin((i+0.5)*angle), -h_sample*box_zfrac), ))
    pickedRegions =(cells, )
    p.setElementType(regions=pickedRegions, elemTypes=(elemType1, elemType2, elemType3))
    p.generateMesh(regions=pickedRegions)
#---------------------------------------------
# Meshing core sample top inner
p = model_name.parts['Core_Sample_Top_Inner']
c, v, e, d = p.cells, p.vertices, p.edges, p.datums

pickedCells = c.findAt(((0.0, 0.0, 0.5*h_sample*box_zfrac), ))
radius = D_sample*0.5*box_xfrac*r_center_frac/c_divi
p.PartitionCellByPlaneThreePoints(
    point1=v.findAt(coordinates=(-radius, 0.0, h_sample*box_zfrac)),
    point2=v.findAt(coordinates=(radius, 0.0,  h_sample*box_zfrac)),
    point3=v.findAt(coordinates=(radius, 0.0, 0.0)),
    cells=pickedCells)

pickedCells = c.findAt(((0.0, 0.0, 0.5*h_sample*box_zfrac), ))
radius = D_sample*0.5*box_xfrac*r_center_frac/c_divi
p.PartitionCellByPlaneThreePoints(
    point1=v.findAt(coordinates=(0.0, radius, h_sample*box_zfrac)),
    point2=v.findAt(coordinates=(0.0, -radius, 0.0)),
    point3=v.findAt(coordinates=(0.0, radius, 0.0)),
    cells=pickedCells)

radius = D_sample*0.5*box_xfrac*r_center_frac/c_divi
pickedCells = c.findAt(((0.0, 0.5*radius, 0.5*h_sample*box_zfrac), ))
radius = D_sample*0.5*box_xfrac*r_center_frac/c_divi
p.PartitionCellByPlaneThreePoints(
    point1=v.findAt(coordinates=(0.0, radius, h_sample*box_zfrac)),
    point2=v.findAt(coordinates=(0.0, -radius, 0.0)),
    point3=v.findAt(coordinates=(0.0, radius, 0.0)),
    cells=pickedCells)

angle = pi/2
for i in range(4):
    r = D_sample*0.5*box_xfrac*r_center_frac/c_divi
    pickedEdges2 = e.findAt(((r*cos(angle*i), r*sin(angle*i), 0.5*h_sample*box_zfrac), ))
    p.seedEdgeByBias(biasMethod=SINGLE,
        end2Edges=pickedEdges2, ratio=box_bias_z, number=box_elm_nz, constraint=FIXED)

for i in range(4):
    r = D_sample*0.5*box_xfrac*r_center_frac/c_divi*1.131371
    pickedEdges2 = e.findAt(((r*cos(angle*(i+0.5)), r*sin(angle*(i+0.5)), 0.5*h_sample*box_zfrac), ))
    p.seedEdgeByBias(biasMethod=SINGLE,
        end2Edges=pickedEdges2, ratio=box_bias_z, number=box_elm_nz, constraint=FIXED)

pickedEdges2 = e.findAt(((0, 0, 0.5*h_sample*box_zfrac), ))
p.seedEdgeByBias(biasMethod=SINGLE,
    end2Edges=pickedEdges2, ratio=box_bias_z, number=box_elm_nz, constraint=FIXED)

r = D_sample*0.5*box_xfrac*r_center_frac/c_divi

x = [0.5*r*(1+1.131371*cos(pi/4)), 0.5*r*(0+1.131371*cos(pi/4)),
    -0.5*r*(0+1.131371*cos(pi/4)), -0.5*r*(1+1.131371*cos(pi/4)),
    -0.5*r*(1+1.131371*cos(pi/4)), -0.5*r*(0+1.131371*cos(pi/4)),
    0.5*r*(0+1.131371*cos(pi/4)), 0.5*r*(1+1.131371*cos(pi/4))]

y = [0.5*r*(0+1.131371*sin(pi/4)), 0.5*r*(1+1.131371*sin(pi/4)),
    0.5*r*(1+1.131371*sin(pi/4)), 0.5*r*(0+1.131371*sin(pi/4)),
    -0.5*r*(0+1.131371*sin(pi/4)), -0.5*r*(1+1.131371*sin(pi/4)),
    -0.5*r*(1+1.131371*sin(pi/4)), -0.5*r*(0+1.131371*sin(pi/4))]

for i in range(8):
    pickedEdges = e.findAt(((x[i], y[i], h_sample*box_zfrac), ))
    p.seedEdgeByNumber(edges=pickedEdges, number=sectors_45, constraint=FIXED)

for i in range(8):
    pickedEdges = e.findAt(((x[i], y[i], 0.0), ))
    p.seedEdgeByNumber(edges=pickedEdges, number=sectors_45, constraint=FIXED)

for i in range(4):
    radius = D_sample*0.5*box_xfrac*r_center_frac/c_divi*0.5
    cells = c.findAt(((radius*cos(angle*(i+0.5)), radius*sin(angle*(i+0.5)), h_sample*box_zfrac*0.5, ), ))

pickedRegions =(cells, )
p.setElementType(regions=pickedRegions, elemTypes=(elemType1, elemType2, elemType3))
p = model_name.parts['Core_Sample_Top_Inner']
p.generateMesh()
#---------------------------------------------
# Meshing core sample button inner
p = model_name.parts['Core_Sample_Bottom_Inner']
c, v, e, d = p.cells, p.vertices, p.edges, p.datums

pickedCells = c.findAt(((0.0, 0.0, 0.5*h_sample*(1-box_zfrac)), ))
radius = D_sample*0.5*box_xfrac*r_center_frac/c_divi
p.PartitionCellByPlaneThreePoints(
    point1=v.findAt(coordinates=(-radius, 0.0, h_sample*(1-box_zfrac))),
    point2=v.findAt(coordinates=(radius, 0.0,  h_sample*(1-box_zfrac))),
    point3=v.findAt(coordinates=(radius, 0.0, 0.0)),
    cells=pickedCells)

pickedCells = c.findAt(((0.0, 0.0, 0.5*h_sample*(1-box_zfrac)), ))
radius = D_sample*0.5*box_xfrac*r_center_frac/c_divi
p.PartitionCellByPlaneThreePoints(
    point1=v.findAt(coordinates=(0.0, radius, h_sample*(1-box_zfrac))),
    point2=v.findAt(coordinates=(0.0, -radius, 0.0)),
    point3=v.findAt(coordinates=(0.0, radius, 0.0)),
    cells=pickedCells)

radius = D_sample*0.5*box_xfrac*r_center_frac/c_divi
pickedCells = c.findAt(((0.0, 0.5*radius, 0.5*h_sample*(1-box_zfrac)), ))
radius = D_sample*0.5*box_xfrac*r_center_frac/c_divi
p.PartitionCellByPlaneThreePoints(
    point1=v.findAt(coordinates=(0.0, radius, h_sample*(1-box_zfrac))),
    point2=v.findAt(coordinates=(0.0, -radius, 0.0)),
    point3=v.findAt(coordinates=(0.0, radius, 0.0)),
    cells=pickedCells)

angle = pi/2
for i in range(4):
    r = D_sample*0.5*box_xfrac*r_center_frac/c_divi
    pickedEdges2 = e.findAt(((r*cos(angle*i), r*sin(angle*i), 0.5*h_sample*(1-box_zfrac)), ))
    p.seedEdgeByBias(biasMethod=SINGLE,
        end2Edges=pickedEdges2, ratio=box_bias_conv_x, number=radial_divi, constraint=FIXED)

for i in range(4):
    r = D_sample*0.5*box_xfrac*r_center_frac/c_divi*1.131371
    pickedEdges2 = e.findAt(((r*cos(angle*(i+0.5)), r*sin(angle*(i+0.5)), 0.5*h_sample*(1-box_zfrac)), ))
    p.seedEdgeByBias(biasMethod=SINGLE,
        end2Edges=pickedEdges2, ratio=box_bias_conv_x, number=radial_divi, constraint=FIXED)

pickedEdges2 = e.findAt(((0, 0, 0.5*h_sample*(1-box_zfrac)), ))
p.seedEdgeByBias(biasMethod=SINGLE,
    end2Edges=pickedEdges2, ratio=box_bias_conv_x, number=radial_divi, constraint=FIXED)

r = D_sample*0.5*box_xfrac*r_center_frac/c_divi

x = [0.5*r*(1+1.131371*cos(pi/4)), 0.5*r*(0+1.131371*cos(pi/4)),
    -0.5*r*(0+1.131371*cos(pi/4)), -0.5*r*(1+1.131371*cos(pi/4)),
    -0.5*r*(1+1.131371*cos(pi/4)), -0.5*r*(0+1.131371*cos(pi/4)),
    0.5*r*(0+1.131371*cos(pi/4)), 0.5*r*(1+1.131371*cos(pi/4))]

y = [0.5*r*(0+1.131371*sin(pi/4)), 0.5*r*(1+1.131371*sin(pi/4)),
    0.5*r*(1+1.131371*sin(pi/4)), 0.5*r*(0+1.131371*sin(pi/4)),
    -0.5*r*(0+1.131371*sin(pi/4)), -0.5*r*(1+1.131371*sin(pi/4)),
    -0.5*r*(1+1.131371*sin(pi/4)), -0.5*r*(0+1.131371*sin(pi/4))]

for i in range(8):
    pickedEdges = e.findAt(((x[i], y[i], h_sample*(1-box_zfrac)), ))
    p.seedEdgeByNumber(edges=pickedEdges, number=sectors_45, constraint=FIXED)

for i in range(8):
    pickedEdges = e.findAt(((x[i], y[i], 0.0), ))
    p.seedEdgeByNumber(edges=pickedEdges, number=sectors_45, constraint=FIXED)

for i in range(4):
    radius = D_sample*0.5*box_xfrac*r_center_frac/c_divi*0.5
    cells = c.findAt(((radius*cos(angle*(i+0.5)), radius*sin(angle*(i+0.5)), h_sample*(1-box_zfrac)*0.5, ), ))
pickedRegions =(cells, )
p.setElementType(regions=pickedRegions, elemTypes=(elemType1, elemType2, elemType3))
p = model_name.parts['Core_Sample_Bottom_Inner']
p.generateMesh()
#---------------------------------------------
# Meshing Core Sample Top Outer
p = model_name.parts['Core_Sample_Top_Outer']
c, v, e, d = p.cells, p.vertices, p.edges, p.datums

angle = pi/2

for i in range(4):
    r = D_sample*0.5*box_xfrac*r_center_frac/c_divi
    pickedEdges2 = e.findAt(((r*cos(angle*i), r*sin(angle*i), -0.5*h_sample*box_zfrac), ))
    p.seedEdgeByBias(biasMethod=SINGLE,
        end2Edges=pickedEdges2, ratio=box_bias_z, number=box_elm_nz, constraint=FIXED)

for i in range(4):
    r = D_sample*0.5*box_xfrac*r_center_frac/c_divi*1.131371
    pickedEdges2 = e.findAt(((r*cos(angle*(i+0.5)), r*sin(angle*(i+0.5)), -0.5*h_sample*box_zfrac), ))
    p.seedEdgeByBias(biasMethod=SINGLE,
        end2Edges=pickedEdges2, ratio=box_bias_z, number=box_elm_nz, constraint=FIXED)

for i in range(4*sectors_45):
    radius1 = 0.5*D_sample*box_xfrac*r_center_frac
    radius2 = radius1/c_divi
    radius = 0.5*(radius1+radius2)
    p = model_name.parts['Core_Sample_Top_Outer']
    c, v, e, d = p.cells, p.vertices, p.edges, p.datums
    pickedCells = c.findAt(((radius*cos(pi/(4*sectors_45)*i+pi/200),
        radius*sin(pi/(4*sectors_45)*i+pi/200), -0.5*box_zfrac*h_sample), ))
    r2 = 0.5*D_sample*box_xfrac*r_center_frac
    p.PartitionCellByPlaneThreePoints(
        point1=v.findAt(coordinates=(r2*cos(pi/(4*sectors_45)*i), r2*sin(pi/(4*sectors_45)*i), 0.0)),
        point2=v.findAt(coordinates=(r2*cos(pi/(4*sectors_45)*i), r2*sin(pi/(4*sectors_45)*i), -h_sample*box_zfrac)),
        point3=v.findAt(coordinates=(-r2*cos(pi/(4*sectors_45)*i), -r2*sin(pi/(4*sectors_45)*i), 0.0)),
        cells=pickedCells)

for i in range(4*sectors_45+1, 8*sectors_45):
    radius1 = 0.5*D_sample*box_xfrac*r_center_frac
    radius2 = radius1/c_divi
    radius = 0.5*(radius1+radius2)
    p = model_name.parts['Core_Sample_Top_Outer']
    c, v, e, d = p.cells, p.vertices, p.edges, p.datums
    pickedCells = c.findAt(((radius*cos(pi/(4*sectors_45)*i+pi/200),
        radius*sin(pi/(4*sectors_45)*i+pi/200), -0.5*box_zfrac*h_sample), ))
    r2 = 0.5*D_sample*box_xfrac*r_center_frac
    p.PartitionCellByPlaneThreePoints(
        point1=v.findAt(coordinates=(r2*cos(pi/(4*sectors_45)*i), r2*sin(pi/(4*sectors_45)*i), 0.0)),
        point2=v.findAt(coordinates=(r2*cos(pi/(4*sectors_45)*i), r2*sin(pi/(4*sectors_45)*i), -h_sample*box_zfrac)),
        point3=v.findAt(coordinates=(-r2*cos(pi/(4*sectors_45)*i), -r2*sin(pi/(4*sectors_45)*i), 0.0)),
        cells=pickedCells)

p = model_name.parts['Core_Sample_Top_Outer']
c, v, e, d = p.cells, p.vertices, p.edges, p.datums
if sectors_45 > 1:
    for i in range(8):
        angle_sector = pi/4*i
        r = D_sample*0.5*box_xfrac*r_center_frac/c_divi
        #print "radius", r
        coord_x_0 = r*cos(angle_sector)
        #print "coord_x_0", coord_x_0
        coord_y_0 = r*sin(angle_sector)
        #print "coord_y_0", coord_y_0
        coord_x_1 = 1.131371*r*cos(angle_sector + pi/4)
        #print "coord_x_1", coord_x_1
        coord_y_1 = 1.131371*r*sin(angle_sector + pi/4)
        #print "coord_y_1", coord_y_1
        for sub_sector in range(1, sectors_45):
            #print "sub_sector", sub_sector
            #print "sectors_45-1", (sectors_45-1)
            x_sector_1 = float((sectors_45-sub_sector))/sectors_45*coord_x_0
            x_sector_2 = float(sub_sector)/sectors_45*coord_x_1
            x_sector = x_sector_1+x_sector_2
            #print "x_sector_1", x_sector_1
            #print "x_sector_2", x_sector_2
            y_sector_1 = float((sectors_45-sub_sector))/sectors_45*coord_y_0
            y_sector_2 = float(sub_sector)/sectors_45*coord_y_1
            y_sector = y_sector_1+y_sector_2
            #print "y_sector_1", y_sector_1
            #print "y_sector_2", y_sector_2
            #print "x_sector", x_sector
            #print "y_sector", y_sector
            z_1 = -h_sample*box_zfrac-0.0005
            z_2 = +0.00005
            pickedEdges2 = e.getByBoundingCylinder((x_sector, y_sector, z_1), (x_sector, y_sector, z_2), 0.5 )
            p.seedEdgeByBias(biasMethod=SINGLE,
                end2Edges=pickedEdges2, ratio=box_bias_z, number=box_elm_nz, constraint=FIXED)

#r = 1.35*D_sample*0.5*box_xfrac*r_center_frac/c_divi
r = 1.35*D_sample*0.5*box_xfrac*r_center_frac
pickedEdges = e.getByBoundingCylinder((0, 0, -0.05), (0, 0, +0.05), r)
p.seedEdgeByNumber(edges=pickedEdges, number=1, constraint=FIXED)

r = 1.35*D_sample*0.5*box_xfrac*r_center_frac
z = -h_sample*box_zfrac
pickedEdges = e.getByBoundingCylinder((0, 0, z-0.05), (0, 0, z+0.05), r)
p.seedEdgeByNumber(edges=pickedEdges, number=1, constraint=FIXED)

for i in range(8*sectors_45):
    angle = pi/(sectors_45*8)
    r = D_sample*0.5*cos(angle)*box_xfrac*r_center_frac
    pickedEdges = e.findAt(((r*cos(angle*(2*i+1)), r*sin(angle*(2*i+1)), 0.0), ))
    p.seedEdgeByNumber(edges=pickedEdges, number=1, constraint=FIXED)

for i in range(8*sectors_45):
    angle = pi/(sectors_45*8)
    r = D_sample*0.5*cos(angle)*box_xfrac*r_center_frac
    pickedEdges = e.findAt(((r*cos(angle*(2*i+1)), r*sin(angle*(2*i+1)), -h_sample*box_zfrac), ))
    p.seedEdgeByNumber(edges=pickedEdges, number=1, constraint=FIXED)

for i in range(8*sectors_45):
    angle = pi/(4*sectors_45)
    r = D_sample*0.5*box_xfrac*r_center_frac*(1+1.131371/c_divi)*0.5
    pickedEdges = e.findAt(((r*cos(angle*i), r*sin(angle*i), 0.0), ))
    p.seedEdgeByNumber(edges=pickedEdges, number=sectors_45, constraint=FIXED)

for i in range(8*sectors_45):
    angle = pi/(4*sectors_45)
    r = D_sample*0.5*box_xfrac*r_center_frac*(1+1.131371/c_divi)*0.5
    pickedEdges = e.findAt(((r*cos(angle*i), r*sin(angle*i), -h_sample*box_zfrac), ))
    p.seedEdgeByNumber(edges=pickedEdges, number=sectors_45, constraint=FIXED)

for i in range(8*sectors_45):
    radius = D_sample*0.5*box_xfrac*r_center_frac*(1+1.131371/c_divi)*0.5
    angle = pi/(4*sectors_45)
    cells = c.findAt(((radius*cos((i+0.5)*angle), radius*sin((i+0.5)*angle), -h_sample*box_zfrac*0.5), ))
    pickedRegions =(cells, )
    p.setElementType(regions=pickedRegions, elemTypes=(elemType1, elemType2, elemType3))
    pickedRegions = c.findAt(((radius*cos((i+0.5)*angle), radius*sin((i+0.5)*angle), -h_sample*box_zfrac*0.5), ))
    p.generateMesh(regions=pickedRegions)
#---------------------------------------------
# Meshing Core Sample Bottom Outer
p = model_name.parts['Core_Sample_Bottom_Outer']
c, v, e, d = p.cells, p.vertices, p.edges, p.datums

angle = pi/2

for i in range(4):
    r = D_sample*0.5*box_xfrac*r_center_frac/c_divi
    pickedEdges2 = e.findAt(((r*cos(angle*i), r*sin(angle*i), -0.5*h_sample*(1-box_zfrac)), ))
    p.seedEdgeByBias(biasMethod=SINGLE,
        end2Edges=pickedEdges2, ratio=box_bias_conv_x, number=radial_divi, constraint=FIXED)

for i in range(4):
    r = D_sample*0.5*box_xfrac*r_center_frac/c_divi*1.131371
    pickedEdges2 = e.findAt(((r*cos(angle*(i+0.5)), r*sin(angle*(i+0.5)), -0.5*h_sample*(1-box_zfrac)), ))
    p.seedEdgeByBias(biasMethod=SINGLE,
        end2Edges=pickedEdges2, ratio=box_bias_conv_x, number=radial_divi, constraint=FIXED)

for i in range(4*sectors_45):
    radius1 = 0.5*D_sample*box_xfrac*r_center_frac
    radius2 = radius1/c_divi
    radius = 0.5*(radius1+radius2)
    p = model_name.parts['Core_Sample_Bottom_Outer']
    c, v, e, d = p.cells, p.vertices, p.edges, p.datums
    pickedCells = c.findAt(((radius*cos(pi/(4*sectors_45)*i+pi/200),
        radius*sin(pi/(4*sectors_45)*i+pi/200), -0.5*(1-box_zfrac)*h_sample), ))
    r1 = 0.5*D_sample*box_xfrac*r_center_frac/c_divi
    r2 = 0.5*D_sample*box_xfrac*r_center_frac
    p.PartitionCellByPlaneThreePoints(
        point1=v.findAt(coordinates=(r2*cos(pi/(4*sectors_45)*i), r2*sin(pi/(4*sectors_45)*i), -box_zfrac*h_sample)),
        point2=v.findAt(coordinates=(r2*cos(pi/(4*sectors_45)*i), r2*sin(pi/(4*sectors_45)*i), -h_sample)),
        point3=v.findAt(coordinates=(-r2*cos(pi/(4*sectors_45)*i), -r2*sin(pi/(4*sectors_45)*i), -h_sample)),
        cells=pickedCells)

for i in range(4*sectors_45+1, 8*sectors_45):
    radius1 = 0.5*D_sample*box_xfrac*r_center_frac
    radius2 = radius1/c_divi
    radius = 0.5*(radius1+radius2)
    p = model_name.parts['Core_Sample_Bottom_Outer']
    c, v, e, d = p.cells, p.vertices, p.edges, p.datums
    pickedCells = c.findAt(((radius*cos(pi/(4*sectors_45)*i+pi/200), radius*sin(pi/(4*sectors_45)*i+pi/200), -0.5*(1-box_zfrac)*h_sample), ))
    r1 = 0.5*D_sample*box_xfrac*r_center_frac/c_divi
    r2 = 0.5*D_sample*box_xfrac*r_center_frac
    p.PartitionCellByPlaneThreePoints(
        point1=v.findAt(coordinates=(r2*cos(pi/(4*sectors_45)*i), r2*sin(pi/(4*sectors_45)*i), -box_zfrac*h_sample)),
        point2=v.findAt(coordinates=(r2*cos(pi/(4*sectors_45)*i), r2*sin(pi/(4*sectors_45)*i), -h_sample)),
        point3=v.findAt(coordinates=(-r2*cos(pi/(4*sectors_45)*i), -r2*sin(pi/(4*sectors_45)*i), -h_sample)),
        cells=pickedCells)

p = model_name.parts['Core_Sample_Bottom_Outer']
c, v, e, d = p.cells, p.vertices, p.edges, p.datums

angle = pi/(sectors_45*8)
for i in range(8*sectors_45):
    r = D_sample*0.5*cos(angle)*box_xfrac*r_center_frac
    pickedEdges = e.findAt(((r*cos(angle*(2*i+1)), r*sin(angle*(2*i+1)), -h_sample*box_zfrac), ))
    p.seedEdgeByNumber(edges=pickedEdges, number=1, constraint=FIXED)

for i in range(8*sectors_45):
    r = D_sample*0.5*cos(angle)*box_xfrac*r_center_frac
    pickedEdges = e.findAt(((r*cos(angle*(2*i+1)), r*sin(angle*(2*i+1)), -h_sample), ))
    p.seedEdgeByNumber(edges=pickedEdges, number=1, constraint=FIXED)

if sectors_45 > 1:
    for i in range(8):
        angle_sector = pi/4*i
        r = D_sample*0.5*box_xfrac*r_center_frac/c_divi
        #print "radius", r
        coord_x_0 = r*cos(angle_sector)
        #print "coord_x_0", coord_x_0
        coord_y_0 = r*sin(angle_sector)
        #print "coord_y_0", coord_y_0
        coord_x_1 = 1.131371*r*cos(angle_sector + pi/4)
        #print "coord_x_1", coord_x_1
        coord_y_1 = 1.131371*r*sin(angle_sector + pi/4)
        #print "coord_y_1", coord_y_1
        for sub_sector in range(1, sectors_45):
            #print "sub_sector", sub_sector
            #print "sectors_45-1", (sectors_45-1)
            x_sector_1 = float((sectors_45-sub_sector))/sectors_45*coord_x_0
            x_sector_2 = float(sub_sector)/sectors_45*coord_x_1
            x_sector = x_sector_1+x_sector_2
            #print "x_sector_1", x_sector_1
            #print "x_sector_2", x_sector_2
            y_sector_1 = float((sectors_45-sub_sector))/sectors_45*coord_y_0
            y_sector_2 = float(sub_sector)/sectors_45*coord_y_1
            y_sector = y_sector_1+y_sector_2
            #print "y_sector_1", y_sector_1
            #print "y_sector_2", y_sector_2
            #print "x_sector", x_sector
            #print "y_sector", y_sector
            z_1 = -h_sample-0.0005
            z_2 = -h_sample*box_zfrac+0.00005
            pickedEdges2 = e.getByBoundingCylinder((x_sector, y_sector, z_1), (x_sector, y_sector, z_2), 0.5 )
            p.seedEdgeByBias(biasMethod=SINGLE,
                end2Edges=pickedEdges2, ratio=box_bias_conv_x, number=radial_divi, constraint=FIXED)

r = 1.30*D_sample*0.5*box_xfrac*r_center_frac
z = -h_sample*box_zfrac
pickedEdges = e.getByBoundingCylinder((0, 0, z-0.05), (0, 0, z+0.05), r)
p.seedEdgeByNumber(edges=pickedEdges, number=1, constraint=FIXED)

r = 1.30*D_sample*0.5*box_xfrac*r_center_frac
z = -h_sample
pickedEdges = e.getByBoundingCylinder((0, 0, z-0.05), (0, 0, z+0.05), r)
p.seedEdgeByNumber(edges=pickedEdges, number=1, constraint=FIXED)

angle = pi/(4*sectors_45)

for i in range(8*sectors_45):
    r = D_sample*0.5*box_xfrac*r_center_frac*(1+1.131371/c_divi)*0.5
    pickedEdges = e.findAt(((r*cos(angle*i), r*sin(angle*i), -h_sample*box_zfrac), ))
    p.seedEdgeByNumber(edges=pickedEdges, number=sectors_45, constraint=FIXED)

for i in range(8*sectors_45):
    r = D_sample*0.5*box_xfrac*r_center_frac*(1+1.131371/c_divi)*0.5
    pickedEdges = e.findAt(((r*cos(angle*i), r*sin(angle*i), -h_sample), ))
    p.seedEdgeByNumber(edges=pickedEdges, number=sectors_45, constraint=FIXED)

for i in range(8*sectors_45):
    radius = D_sample*0.5*box_xfrac*r_center_frac*(1+1.131371/c_divi)*0.5
    cells = c.findAt(((radius*cos((i+0.5)*angle), radius*sin((i+0.5)*angle), -h_sample*(1-box_zfrac)*0.5), ))
    pickedRegions =(cells, )
    p.setElementType(regions=pickedRegions, elemTypes=(elemType1, elemType2, elemType3))
    pickedRegions = c.findAt(((radius*cos((i+0.5)*angle), radius*sin((i+0.5)*angle), -h_sample*(1-box_zfrac)*0.5), ))
    p.generateMesh(regions=pickedRegions)
#---------------------------------------------
# Merging all the meshes in order to generate the final sample "Final Sample", which is an orphan mesh

a = model_name.rootAssembly
a.regenerate()
a.PartFromBooleanMerge(name='Core_Sample_Bottom_Final', instances=(
    a.instances['Core_Sample_Bottom_Inner-1'], a.instances['Core_Sample_Bottom_Outer-1'], ),
    mergeNodes=BOUNDARY_ONLY, nodeMergingTolerance=tolerance, domain=MESH)
a = model_name.rootAssembly
p = model_name.parts['Core_Sample_Bottom_Final']
a.Instance(name='Core_Sample_Bottom_Final-1', part=p, dependent=ON)
a = model_name.rootAssembly
a.suppressFeatures(('Core_Sample_Bottom_Inner-1',
    'Core_Sample_Bottom_Outer-1', ))
a = model_name.rootAssembly
a.PartFromBooleanMerge(name='Core_Sample_Top_Final', instances=(
    a.instances['Core_Sample_Top_Inner-1'], a.instances['Core_Sample_Top_Outer-1'], ),
    mergeNodes=BOUNDARY_ONLY, nodeMergingTolerance=tolerance, domain=MESH)
a = model_name.rootAssembly
p = model_name.parts['Core_Sample_Top_Final']
a.Instance(name='Core_Sample_Top_Final-1', part=p, dependent=ON)
a = model_name.rootAssembly
a.suppressFeatures(('Core_Sample_Top_Inner-1', 'Core_Sample_Top_Outer-1', ))
a = model_name.rootAssembly
a.PartFromBooleanMerge(name='Core_Sample_Final', instances=(
    a.instances['Core_Sample_Bottom_Final-1'], a.instances['Core_Sample_Top_Final-1'], ),
    mergeNodes=BOUNDARY_ONLY, nodeMergingTolerance=tolerance, domain=MESH)
a = model_name.rootAssembly
p = model_name.parts['Core_Sample_Final']
a.Instance(name='Core_Sample_Final-1', part=p, dependent=ON)
a = model_name.rootAssembly
a.suppressFeatures(('Core_Sample_Bottom_Final-1', 'Core_Sample_Top_Final-1', ))
a = model_name.rootAssembly
a.PartFromBooleanMerge(name='Sample_Intermediate_Final', instances=(
    a.instances['Sample_Large_Def-1'], a.instances['Sample_Small_Def-1'], ), 
    mergeNodes=BOUNDARY_ONLY, nodeMergingTolerance=0.01, domain=MESH)
a = model_name.rootAssembly
p = model_name.parts['Sample_Intermediate_Final']
a.Instance(name='Sample_Intermediate_Final-1', part=p, dependent=ON)
a = model_name.rootAssembly
a.suppressFeatures(('Sample_Large_Def-1', 'Sample_Small_Def-1', ))
a = model_name.rootAssembly
a.PartFromBooleanMerge(name='Final Sample', instances=(
    a.instances['Core_Sample_Final-1'], a.instances['Sample_Intermediate_Final-1'], ),
    mergeNodes=BOUNDARY_ONLY, nodeMergingTolerance=0.01, domain=MESH)
a = model_name.rootAssembly
p = model_name.parts['Final Sample']
a.Instance(name='Final Sample-1', part=p, dependent=ON)
a = model_name.rootAssembly
a.suppressFeatures(('Core_Sample_Final-1', 'Sample_Intermediate_Final-1', ))

# Setting correctly the element type for all the elements
final_sample = model_name.parts['Final Sample']
z1 = p.elements
num_elem = len(z1)
elems1 = z1[0:num_elem]
pickedRegions =(elems1, )
final_sample.setElementType(regions=pickedRegions, elemTypes=(elemType1, ))

# Top surface of the sample
final_sample = model_name.parts['Final Sample']
nodes_selected = final_sample.nodes.getByBoundingCylinder((0,0,-smv),(0,0,smv), D_sample*0.5+smv)
surf_sample = final_sample.Set(name='Surf Sample', nodes=nodes_selected)
''')

    def procBoundaryConditionsIndent(self):
        self.proc.append('''
#+++++++++++++++++++++++++++++++++++++++++++++
# BOUNDARIES CONDITIONS
#+++++++++++++++++++++++++++++++++++++++++++++
# Set of the nodes of the base
final_sample = model_name.parts['Final Sample']
nodes_base = final_sample.nodes.getByBoundingCylinder((0,0,-h_sample-smv),(0,0,-h_sample+smv), D_sample+smv)
final_sample.Set(nodes=nodes_base, name='Points_Base')

# Set of nodes of the external diameters
for i in range(8*sectors_45):
    final_sample = model_name.parts['Final Sample']
    r = D_sample*0.5
    angle = pi/(4*sectors_45)
    x_coor = r*cos(angle*i)
    y_coor = r*sin(angle*i)
    nodes_selected = final_sample.nodes.getByBoundingCylinder((x_coor,y_coor,-h_sample-smv),(x_coor,y_coor,smv), smv)
    string = 'Points_Diameter_'+'%1d'%(i+1)
    final_sample.Set(nodes=nodes_selected, name=string)

# Constraint of the nodes of the base
InstanceRoot = model_name.rootAssembly
region = InstanceRoot.instances['Final Sample-1'].sets['Points_Base']
model_name.EncastreBC(name='BC_points_base', createStepName='Initial', region=region)
    
# Constraint external diameters nodes
for i in range(8*sectors_45):
    name_set = 'Points_Diameter_'+'%1d'%(i+1)
    name_BC = 'BC_Diameter'+'%1d'%(i+1)
    region = InstanceRoot.instances['Final Sample-1'].sets[name_set]
    model_name.EncastreBC(name=name_BC, createStepName='Initial', region=region)
''')

    def procSectionsIndent(self):
        self.proc.append('''
#+++++++++++++++++++++++++++++++++++++++++++++
# SECTION DEFINITION
#+++++++++++++++++++++++++++++++++++++++++++++
# Defining preliminary sets
final_sample = model_name.parts['Final Sample']
elements_sample = final_sample.elements
elements_selected = elements_sample.getByBoundingCylinder((0,0,-h_sample-smv),(0,0,smv), D_sample*0.5+smv)
final_sample.Set(elements=elements_selected, name='All Elements')

model_name.HomogeneousSolidSection(
    name='Section ElastoPlastic', material='Material-1', thickness=None)

# Assigning material properties
final_sample = model_name.parts['Final Sample']
region = p.sets['All Elements']
final_sample.SectionAssignment(region=region, sectionName='Section ElastoPlastic',
    offset=0.0, offsetType=MIDDLE_SURFACE, offsetField='', thicknessAssignment=FROM_SECTION)
''')