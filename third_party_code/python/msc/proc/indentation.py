# -*- coding: utf-8 -*-
"""
@author: c.zambaldi
"""

import math

from tools import Tools
from indenter import Indenter

import logging

logger = logging.getLogger('root')
logger.info('logger says : proc.indent')


class Indentation(Indenter, Tools):
    """ Generates a MSC.Marc/Mentat procedure file for indentation simulation.
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
                 modelname='indent',
                 h_indent=0.20,  # maximum simulated indentation depth
                 D_sample=2.,  # diameter of sample
                 h_sample=None,  # sample height, only for overriding default estimate
                 geo='conical',  # indenter geometry
                 coneAngle=90,  # full cone angle (deg)
                 tipRadius=1,  # indenter tip radius
                 friction=0.3,  # Coulomb friction coefficient
                 sample_rep=24,  # 16, 24, 32, 48 # number of segments,
                                 # must be dividable by 8 if used with r_center_frac != 0
                 r_center_frac=0.25,  # if >0 ==>insert a cylindrical column of brick
                                      # elements in the center to avoid collapsed elements
                                      # under the indenter
                 box_xfrac=0.3,  # size of the finer mesh box in horizontal direction
                 box_zfrac=0.2,  # ... in vertical dimension
                 box_elm_nx=5,  # number of horizontal elements in box
                 box_elm_nz=5,  # number of vertical elements in box
                 box_bias_x=0.25,  # bias in x direction
                 box_bias_z=0.25,  # bias in z direction
                 box_bias_conv_x=0.25,  # bias in x direction for the outer cylinder
                 radial_divi=5,  # radial subdivisions of the outer part of the model
                 ind_time=10.,  # time of loading segment
                 dwell_time=1,  # not used yet, needs Loadcase "dwell"
                 Dexp=None,  # experimental indent diameter, for visualization purposes only
                 twoDimensional=False,  # 2D indentation model, experimental
                 divideMesh=False,  # subdivide each el. additionally into 8 els.
                 outStep=5,  # write step for results
                 nSteps=800,  # LC 'indent', No of increments
                 n_steps_release=None,  # default is 10% of loading
                 release_split=None,  # time ratio betw release1 and release2 load case
                 smv=0.01,  # small value
                 label='',
                 free_mesh_inp=None,  #name of the .inp file for AFM topo for indenter
                 scratchTest=0, #boolean variable (0 if not a scratch test and 1 if scratch test)
                 scratchLength=3, # scratch length in microns
                 scratchDirection=0, # scratch direction in degrees (0 along x-axis and 90 along y axis, from 0 to 360)
                 ori_list=None):
        self.callerDict = locals()
        if scratchTest >=1:
            xLength_scratchTest = scratchLength * math.cos(scratchDirection/ 180. * math.pi)
            yLength_scratchTest = scratchLength * math.sin(scratchDirection/ 180. * math.pi)
        else:
            xLength_scratchTest = 0
            yLength_scratchTest = 0
        if r_center_frac is not 0 and sample_rep not in [8, 16, 24, 32, 40, 48, 56]:
            print('For r_center_frac not 0, sample_rep needs to be dividable by 8')
            sample_rep = 24
            print('sample_rep=', sample_rep)
            # create dictionary of parameters
        self.IndentParameters = {
            'coneAngle': coneAngle,
            'coneHalfAngle': coneAngle / 2.,
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
            'tipRadius': tipRadius,
            'D_sample': D_sample, # not yet implemented, governed by h_indent
            'h_sample': h_sample,
            'ind_time': ind_time, # in seconds, since dotgamma_0 is in perSecond
            'dwell_time': dwell_time, # time at maximum load
            'Dexp': Dexp, # experimental remaining indent diameter
            'indAxis': 'z', # however, indDirection is -z
            '2D': twoDimensional, #2D model flag
            'divideMesh': divideMesh, # refine by additional subdivisions
            'outStep': outStep,  # post increment write step
            'nSteps': nSteps,  # number of increments for indentation to hmax
            'smv': smv,  # small length for node selection
            'label': label,
            'free_mesh_inp': free_mesh_inp, # name of the .inp file for AFM topo for indenter
            'scratchTest': scratchTest, # boolean variable (0 if not a scratch test and 1 if scratch test)
            'scratchLength': scratchLength, # scratch length in microns
            'scratchDirection': scratchDirection, # scratch direction in degrees (0 along x-axis and 90 along y axis, from 0 to 360)
            'xLength_scratchTest': xLength_scratchTest, 
            'yLength_scratchTest': yLength_scratchTest}
        if twoDimensional:
            self.IndentParameters['indAxis'] = 'y'
        print(repr(self.IndentParameters))
        self.proc = []
        self.start(title='INDENTATION-MODEL (%s) %s' % (modelname, label))
        self.procIndentDocCall()
        self.procNewModel()
        self.proc_draw_update_manual() 
        self.procParameters()
        self.procParametersIndent()
        self.procIndenter()
        if geo == 'conical':
            self.procIndenterConical(coneHalfAngle=self.IndentParameters['coneHalfAngle'])
        if geo == 'Berkovich':
            self.procIndenterBerkovich()
        if geo == 'flatPunch':
            self.procIndenterFlatPunch(tipRadius=self.IndentParameters['tipRadius'])
        if geo == 'customized':
            self.procIndenterCustomizedTopo(free_mesh_inp=self.IndentParameters['free_mesh_inp'])
        self.procNewModel()
        self.procParametersIndent()
        self.procSample()
        self.procSampleIndent(smv=self.IndentParameters['smv'])
        self.procBoundaryConditions()
        self.procBoundaryConditionsIndent()
        if twoDimensional:
            self.procSampleIndent2D()
        if self.CODE == 'DAMASK':
            self.procInitCondDamask()
        else:
            self.procInitCond()
        self.procMaterial()
        self.procGeometricProperties()
        self.procContact()
        self.procContactIndent()
        self.procLoadCaseIndent(nSteps=self.IndentParameters['nSteps'],
                                n_steps_release=n_steps_release,
                                release_split=release_split)
        self.procJobDef()
        self.procJobDefIndent()
        self.procFriction()
        self.procAnalysisOptions()
        self.procJobResults(step=self.IndentParameters['outStep'])
        self.procJobParameters()
        self.procViewSetsIndent()
        savename = modelname + '_' + label
        savename += '_fric%.1f' % self.IndentParameters['friction']
        if geo == 'conical':
            savename += '_R%.2f' % self.IndentParameters['tipRadius']
            savename += '_cA%.1f' % self.IndentParameters['coneAngle']
        savename += '_h%.3f' % self.IndentParameters['h_indent']
        savename += ['_' + label, ''][label == '']
        self.procSaveModel(modelname=savename + '.mfd') # <<< needed to update modelname (for write_dat)
        self.proc_draw_update_automatic() 
        self.procMicronbar(posXYZ=[0., 0., 0.], height=h_indent)
        self.plot()
        if Dexp is not None:
            self.procExpIndent(D=Dexp, Z=h_indent)
        self.write_dat()
        if ori_list is not None:
            for ori in ori_list:
                self.proc_copy_job(jobname='ori', number=ori)
                #TODO needs update in initial conditions

        self.procSaveModel(modelname=savename + '.mfd')
        self.procfilename = savename + '.proc'
        self.proc_draw_update_automatic()
        #self.printCommands(self.proc,filename=self.procfilename)
        #self.define_post_vars()
        #self.define_post_vars(nslip=18) #Ti
        #return self.procfilename

    def procParametersIndent(self):
        if self.IndentParameters['h_sample'] is None:
            self.IndentParameters['h_sample'] = h_indent * 12.
        if self.IndentParameters['D_sample'] is not None:
            dSamp = self.IndentParameters['D_sample']
        elif self.IndentParameters['Dexp'] is not None:
            dSamp = self.IndentParameters['Dexp'] * 4.6
        else:
            dSamp = 20 * self.IndentParameters['h_indent'] # 90deg~20*
        self.proc.append('''| GEOMETRY
*define h_indent %f''' % (self.IndentParameters['h_indent']) + '''| maximum indentation depth
*define d_sample %f''' % dSamp + '''
|*define d_sample 20*h_indent  | Berkovich''' + # d_samp>!7*d_indentation
                         '''|*define d_sample 16*h_indent  | CubeCorner

                         *define r_sample d_sample/2

                         |*define h_sample 12*h_indent      | Berkovich
                         |*define h_sample 14*h_indent      | large tip radii
                         |*define h_sample 10*h_indent     | CubeCorner
                         *define h_sample %f  ''' % self.IndentParameters['h_sample'] + '''    | large tip radii


| MESH
*define sample_rep %i | 24 No of Sample Sectors...''' % (self.IndentParameters['sample_rep']) + '''
|Sector Angle is 360/sample_rep...
|12=>30 deg, 16=>22.5 deg, 18=>20 deg, 24=>15 deg, 36=>10 deg, 72=>5 deg

| INDENTER VELOCITY, "STRAIN RATE"
| Time used for LoadCase "indentation"
|*define ind_time 1  | in [seconds] for model in mm
*define ind_time %f  | in [10e-3*seconds] for model in micrometer, gamma0?!!?''' % (self.IndentParameters['ind_time']) + '''
    ''')


    def procSampleIndent(self, smv=0.01):
        try:
            self.IndentParameters['box_elm_nx']
        except:
            self.IndentParameters['box_elm_nx'] = 5
        try:
            self.IndentParameters['box_elm_nz']
        except:
            self.IndentParameters['box_elm_nz'] = 5
        try:
            self.IndentParameters['radial_divi']
        except:
            self.IndentParameters['radial_divi'] = 5

        self.proc.append('''|
|    
|     |<---------- r_sample --------------->|
|
|          __--
|     __---
|     *N1-----------*N4---------------------*
|     |             |                       |
|     |             |                       |
|     *N2-----------*N3                     |
|     |                 \ _
|     |                     \ _
|     |                         \ _
|     |                             \ 
|     *-------------------------------------*
|
|
*define n2z  -h_sample*%f  |Size of box in z''' % self.IndentParameters['box_zfrac'] + '''
|*define n2z  -2*h_indent |Size of box in z
|Size of Box in x
|*define n4x  d_ball*.5+h_indent  | spherical indentation
|*define n4x  h_indent*5   | flat cone, or r_centerfrac>0
*define n4x  %f*d_sample/2''' % self.IndentParameters['box_xfrac'] + '''
|*define n4x  h_indent*3   | sharp cone
*define n3x 1.0*n4x
*define n3z 1.0*n2z
*define r_center n4x*%f''' % self.IndentParameters['r_center_frac'] + '''
|*define box_elm_nx  10   | 18  12  10   8
|*define box_elm_nz   5   |  9   6   5   4
|*define box_elm_nx  14   | 18  12  10   8
|*define box_elm_nz   9   |  9   6   5   4
|*define box_elm_nx  6   | 18  12  10   8
|*define box_elm_nz   5   |  9   6   5   4
*define box_elm_nx  %i |5   | 18  12  10   8''' % self.IndentParameters['box_elm_nx'] + '''
*define box_elm_nz  %i |5   |  9   6   5   4''' % self.IndentParameters['box_elm_nz'] + '''


|*define box_biasx 0.1   | 0.3 for nocenter; the higher, the more biased
|*define box_biasx 0.1   | r_centerfrac 0.4 
|*define box_biasz 0.2   |
|*define conv_bias 0.4    |
*define box_biasx  %f ''' % self.IndentParameters['box_bias_x'] + '''
*define box_biasz  %f ''' % self.IndentParameters['box_bias_z'] + '''
*define conv_bias  %f ''' % self.IndentParameters['box_bias_conv_x'] + '''
*define divi_no %i|5      |  7  (10,5)=>4''' % self.IndentParameters['radial_divi'] + '''
|*define divi_no 4      |  7  (10,5)=>4
| NUMBER OF ELEMENTS (for r_center_frac=0)
| 5952 Elements from nx=16,nz=8,divi_no=5, sample rep 24
| 4800 Elements from nx=14,nz=8,divi_no=4, sample rep 24
| 2640 Elements from nx=10,nz=5,divi_no=4, sample rep 24
*add_nodes
r_center   0   0      |node1 in origin
r_center   0   n2z    |node2
n3x 0   n3z    |node3
n4x 0   0      |node4
*add_elements
1 2 3 4
*sub_divisions
box_elm_nz box_elm_nx 1
*sub_bias_factors
-box_biasz -box_biasx 0
*subdivide_elements
1
#
*set_points on
*set_curve_type line
*add_curves
point(n3x,0,n3z)
point(n4x,0,0)
point(r_sample,0,-h_sample)
point(r_sample,0,0)
point(r_center,0,n2z)
point(n3x,0,n3z)
point(r_center,0,-h_sample)
point(r_sample,0,-h_sample)
#
*set_surface_type ruled
*add_surfaces
1 2 3 4
*set_convert_divisions
box_elm_nz divi_no
*set_convert_bias_factors
box_biasz -conv_bias
*convert_surfaces
max_surface_id()-1
#
*set_convert_divisions
box_elm_nx divi_no

*set_convert_bias_factors
-box_biasx -conv_bias
*convert_surfaces
max_surface_id()
#
*detach_elements
all_existing
|+++++++++++++++++
*select_surfaces
all_existing
*select_mode_invert *select_surfaces
indenter_surfaces
*store_surfaces sample_trans
all_selected
''')
        if self.IndentParameters['2D'] == False:
            self.proc.append('''
*expand_reset
*set_expand_rotation z 360/sample_rep
*set_expand_repetitions sample_rep
*expand_elements
all_existing
''')
        self.proc.append('''
*renumber_all
*clear_geometry | added 0904
*save_as_model ind_sample_outer.mfd yes  
''')
        # Optionally create the inner cylinder
        if self.IndentParameters['r_center_frac'] != 0. and not \
                    self.IndentParameters['2D'] == True:
            self.proc.append('''
|++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
| Insert the CENTER COLUMN ELEMENTS because R_CENTER_FRAC is not 0.      
*remove_elements
all_existing
*remove_nodes
all_existing
*clear_geometry
*select_reset
*plot_reset 
*expand_reset
*move_reset
*sweep_all
*renumber_all
|+++++++++++++++++++++++++++++++++++++++++++++
| PARAMETERS-DEFINITION
|+++++++++++++++++++++++++++++++++++++++++++++
|
| GEOMETRY
|
*define d r_center*2       | Sample diameter = d 
*define r d/2    | Sample radius   = r
*define div 2      | Interface square-circ is at r/div
*define c_divi %i     | Subdivisions (rules Number of Elements: 4*divi=elements along d)
''' % (self.IndentParameters['sample_rep'] / 8) + '''
*define h n2z*1             | Sample height (l_0)
*define z_rep 12   | Number of elements in height direction, ...
      | ... can be slightly smaller than (h/d)*4*divi
*define el_h h/z_rep   | Height of elements
*define smv %f''' % smv + ''' | Small Value for Node selection


|+++++++++++++++++++++++++++++++++++++++++++++
| SAMPLE-MODELING AND MESHING
|+++++++++++++++++++++++++++++++++++++++++++++
*set_point_labels on
*set_curve_labels on
*set_element_labels on
*add_points
0 0 0
r/div 0 0
r/div*.8 r/div*.8 0
0 r/div 0
*set_surface_type quad
*add_surface
1 2 3 4
*set_convert_divisions 1 1
*set_convert_bias_factors 0 0
*convert_surfaces   
1
#
*set_curve_type line
*add_curves
2 3
4 3

*set_curve_type arc_cpa
*add_curves
0 0 0 
0 r 0
-45
0 0 0 
r 0 0
45
*set_curve_type line
*add_curves
4 5
3 7
2 8
*set_surface_type ruled
*add_surfaces
2 3
|1 4
4 1
*remove_elements  |added CZ 090513 
1
#
*subdivide_reset
*set_element_class quad4
*set_convert_divisions
c_divi c_divi
*set_convert_bias_factors
0 0
*convert_surfaces
1
2
3
#
|*stop
*sweep_all
*renumber_all

|*relax_nodes
|all_existing

*symmetry_reset
*symmetry_elements 
all_existing
*set_symmetry_normal
0 1 0
*symmetry_elements
all_existing

*store_elements center_flat
all_existing
#

*duplicate_reset
*set_duplicate_translation z h
*duplicate_elements
center_flat
#

*select_method_box
*select_elements
-d d
-d d
-smv +smv
#

*store_elements center_top
all_selected
#
''')
        if self.FEMSOFTWAREVERSION > 2013:
            self.proc.append('''
*merge_sets center_top
center_flat
''')
        self.proc.append('''
*select_clear

*select_method_box
*select_elements
-d d
-d d
h-smv h+smv
#
*store_elements center_bottom
all_selected
#
''')
        if self.FEMSOFTWAREVERSION > 2013:
            self.proc.append('''
*merge_sets center_bottom
center_top
''')
        self.proc.append('''
*expand_reset
*set_expand_rotation z 0
|*set_expand_translation z el_h
*set_expand_translation z h
|*set_expand_repetitions z_rep
*set_expand_repetitions 1
*expand_elements
center_top
*sweep_all
*renumber_all
|*set_node_labels on
*fill_view
*set_nodes off
*elements_solid
*regenerate
*check_distorted
*clear_geometry | Deletes all points,curves and surfaces

*select_elements
center_top
#

*set_expand_translation z -h_sample-h
*expand_elements
center_bottom

*sub_divisions
1 1 box_elm_nz
*sub_bias_factors
0 0 box_biasz
*subdivide_elements
center_top
#

*sub_divisions
1 1 divi_no
*sub_bias_factors
0 0 conv_bias
*subdivide_elements
center_bottom
#

*store_elements core_elements
all_existing
#
''')
        self.proc.append('''
*merge_models ind_sample_outer.mfd
*select_reset
*set_sweep_tolerance smv | might have to bee adjusted manually
*sweep_all
*renumber_all
''')
        self.proc.append('''
*remove_surface_sets
*merge_models %s''' % (self.IndentParameters['Indenter']) + '''
''')
        if self.IndentParameters['divideMesh']:
            self.proc.append('''
*subdivide_reset
*sub_divisions
2 2 2
*subdivide_elements
all_existing
*sweep_all
*renumber_all
*subdivide_reset
''')

    def procSampleIndent2D(self):
        self.proc.append('''
*move_reset
*set_move_rotation x -90
*move_elements
all_existing
| Now make mesh finer because we are in 2D
*subdivide_reset
*sub_divisions
2 2 2
*subdivide_elements
all_existing
''')

    def procBoundaryConditionsIndent(self):
        self.proc.append('''
*fill_view
*new_apply
*apply_name
ground_support
|*apply_dof x *apply_dof_value x
|0
|*apply_dof y *apply_dof_value y
|0
*apply_dof z *apply_dof_value z
0
*select_method_box
|*dynamic_model_off
*select_nodes
-d_sample d_sample
-d_sample d_sample
-h_sample-0.01 -h_sample+0.01
#
*add_apply_nodes
*all_selected *select_reset

*new_apply
*apply_name
shell_support
*apply_dof x *apply_dof_value x
0
*apply_dof y *apply_dof_value y
0

*sweep_all
*select_filter_surface
*select_nodes
all_existing
*select_mode_invert
*add_curves
point(0,0,0.1)
point(0,0,-h_sample-0.1)

*select_method_curve_dist
*set_select_distance
d_sample/2-%f''' % (self.IndentParameters['D_sample'] * .98) + '''
*select_nodes
max_curve_id()
*add_apply_nodes
all_selected
*select_reset
''')

    def procContactIndent(self):
        self.proc.append(self.header('CONTACT DEFINITION'))
        if self.FEMSOFTWARE >= 2013:
            self.proc.append('''
*new_cbody mesh  | mentat2013
*contact_option state:solid | mentat2013
*contact_option skip_structural:off | mentat2013
            ''')
        self.proc.append('''
*contact_body_name
sample
*contact_deformable
''')
        if self.FEMSOFTWAREVERSION < 2013:
            self.proc_friction_value() # only needed for 2010
        self.proc.append('''
*add_contact_body_elements
all_existing
''')
        if self.FEMSOFTWAREVERSION >= 2013:
            self.proc.append('''
*new_cbody geometry |mentat >= 2013
*contact_option geometry_nodes:off | mentat >= 2013
''')
        else:
            self.proc.append('''
*new_contact_body  | mentat < 2013
''')
        self.proc.append('''
*contact_body_name
indenter
*add_contact_body_surfaces
indenter_surfaces
''')
        #self.proc_friction_value()  # 2010 + 2013 account for changes in mentat2013
        #*contact_value friction %f''' % self.IndentParameters['friction'] + '''
        self.proc.append('''
*elements_solid
*identify_contact *regen
*identify_backfaces *regen | Flip if necessary
*identify_none *regen
''')
        if self.IndentParameters['scratchTest'] >= 1:
            self.proc.append('''
*new_table |TABLE definition
*table_name
indenter_motion
*set_table_type
time
*table_add
0        -h_indent/ind_time
ind_time -h_indent/ind_time
ind_time 0
2*ind_time  0
2*ind_time  h_indent/ind_time
3*ind_time h_indent/ind_time
*table_fit
*table_filled
*colormap 1
*apply_option ref_position:undeformed | Important for consistent load-displacement curves.

*new_table |TABLE definition
*table_name
indenter_scratch
*set_table_type
time
*table_add
0        0
ind_time        0
ind_time        1
2*ind_time      1
2*ind_time      0
3*ind_time      0
*table_fit
*table_filled
*colormap 1
''')
        else:
            self.proc.append('''
*new_table |TABLE definition
*table_name
indenter_motion
*set_table_type
time
*table_add
|0 0
|0.1*ind_time -h_indent/(0.9*ind_time)
|0.9*ind_time -h_indent/(0.9*ind_time)
|ind_time 0
0        -h_indent/ind_time
ind_time -h_indent/ind_time
ind_time  h_indent/ind_time
2*ind_time h_indent/ind_time
*table_fit
*table_filled
|*colormap 5
|*image_save_gif 1 indent3d_doc_motion.ps yes
*colormap 1
*apply_option ref_position:undeformed | Important for consistent load-displacement curves.
''')
        self.proc.append('''
*contact_rigid
*contact_option control:velocity
*contact_value v%s''' % (self.IndentParameters['indAxis']) + '''
1
*cbody_table v%s''' % (self.IndentParameters['indAxis']) + '''0
indenter_motion
''')
        if self.IndentParameters['scratchTest'] >= 1:
            self.proc.append('''
*contact_value vx
%f''' % self.IndentParameters['xLength_scratchTest'] + '''
*cbody_table vx0
indenter_scratch
*contact_value vy
%f''' % self.IndentParameters['yLength_scratchTest'] + '''
*cbody_table vy0
indenter_scratch
''')
        self.proc.append('''
*apply_option ref_position:undeformed | Important for consistent load-displacement curves.

| CONTACT TABLE
*new_contact_table
*contact_table_entry 1 2
*contact_table_option $ctbody1 $ctbody2 contact_type:touching
*contact_table_option $ctbody1 $ctbody2 project_stress_free:on
|*contact_table_option_all detection:default
''')
#        if self.FEMSOFTWAREVERSION >= 2013:
#            self.proc.append('''
#|*ctable_set_default_touch
#''')
        # proc_friction_value call was moved here because in 2013.1
        # the contact table defines a contact_interaction
        # automatically and if it stays before the contact table def
        # there will be two interactions.
        # Hopefully compatible with 2010?   Checked --- works
        # Check working of friction by looking at contact friction force X/Y/Z
        self.proc_friction_value()  # 2010 + 2013 account for changes in mentat2013

    def proc_friction_value(self):
        if self.FEMSOFTWAREVERSION >= 2013:
            self.proc.append('''| mentat version > 2013
|*stop
|*new_interact mesh:geometry *interact_option state_1:solid  |2013.1
*interact_param friction  %f ''' % (self.IndentParameters['friction']) + '''
''')
        else:
            self.proc.append('''
*contact_value friction %f
''' % self.IndentParameters['friction'])

    def load_case_indent(self,
                         new=True,
                         name='LOADCASE',
                         contact_table='ctable1',
                         #lc_type='static',
                         time_str='ind_time',
                         nsteps=100, # increments
                         maxrec=20,
                         ntime_cuts=30):  # Number of timestep cutbacks
        proc = '| LOADCASE: %s\n' % name.upper()
        if new:
            proc += '*new_loadcase\n'
        proc += '*loadcase_name\n%s\n' % name
        proc += '*loadcase_ctable\n%s\n' % contact_table
        proc += '*loadcase_type static\n'
        proc += '*loadcase_value time\n%s\n' % time_str
        proc += '*loadcase_value nsteps\n%s\n' % str(nsteps)
        proc += '*loadcase_value maxrec\n%i\n' % maxrec
        proc += '*loadcase_value ntime_cuts\n%i\n' % ntime_cuts
        return proc

    def procLoadCaseIndent(self,
                           nameLC='Indentation',
                           nSteps=800,
                           stepsRelease=None,
                           release_split=None,  # time ratio between rel1 and rel2
                           n_steps_release=None):
        lc_ind = self.load_case_indent(
            name=nameLC,
            contact_table='ctable1',
            time_str='ind_time',
            nsteps=nSteps)
        self.proc.append(lc_ind)
        if stepsRelease is None:
            stepsRelease=1
        if stepsRelease==1:
            if n_steps_release is None:
                n_steps_release = int(math.ceil(nSteps / 6.))
            # split number of increments evenly between release LCs but use less time for release1
            n_steps_rel1 = int(math.ceil(0.5 * n_steps_release))
            n_steps_rel2 = n_steps_release - n_steps_rel1
            if release_split is None:
                release_split = 0.2
            lc_rel_1 = self.load_case_indent(
                name='release1',
                contact_table='ctable1',
                time_str='%f*ind_time' % release_split,
                nsteps='%i'%n_steps_rel1)
            self.proc.append(lc_rel_1)
            self.proc_release_cbody(cbody='indenter')  # Mentat < 2013
            lc_rel_2 = self.load_case_indent(
                name='release2',
                contact_table='ctable1',
                time_str='%f*ind_time' % (1.-release_split),
                nsteps='%i' % n_steps_rel2)
            self.proc.append(lc_rel_2)
            self.proc_release_cbody(cbody='indenter')  # Mentat < 2013

    def procViewSetsIndent(self):
        self.proc.append('''|++++++++++++
| SHOW 90-SECTOR
*plot_reset
*select_clear
*dynamic_model_on
*select_method_box
*select_elements
-6 6
-6 0.001
-6 0.001
-6 0.001
-6 6
-6 0.001
*store_elements 270_degree_elms
all_selected
*select_clear
*select_method_box
*select_elements
-r_sample-.1 r_sample+.1
-r_sample-.1 0.00001
-h_sample-.1 0.00001
*store_elements 180_degree_elms
all_selected
*invisible_selected
*select_reset
*select_clear

|*relax_surface_fixed
|*relax_nodes
|all_existing
''')

    def proc_release_cbody(self, cbody=None):
        if self.FEMSOFTWAREVERSION < 2013 and (cbody is not None):
            self.proc.append('''| MENTAT < 2013, release contact bodies
*add_loadcase_cbodies %s''' % cbody + '''
''')

    def procJobDefIndent(self):
        self.proc.append('''
*add_job_loadcases Indentation
''')
        if self.IndentParameters['scratchTest'] >= 1:
            self.proc.append('''
*add_job_loadcases Scratch
''')

        self.proc.append('''
*add_job_loadcases release1
*add_job_loadcases release2
*job_option frictype:coulomb_bilinear
*job_contact_table
ctable1
''')
        if self.CODE == 'DAMASK':
            self.proc.append('''
*job_param fric_force_tol
1e10  | ping-pong based DAMASK confuses the contact control
''')
        else:
            self.proc.append('''*job_param fric_force_tol
0.05
''')
        self.proc.append('''
|*job_option contact_method:segment_segment | new in 2010
|*job_option contact_sliding:small

''')

    def plot(self):
        self.proc.append('''
*set_plot_surface_div_high
*set_points off
*set_nodes off
*set_faces off

''')