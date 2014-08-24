# -*- coding: utf-8 -*-
"""
@author: c.zambaldi
"""

#import numpy as N # old
import numpy as np
import math

#from .base import Proc
#from .indenter import Indenter
from .indentation import Indentation


class BicrystalIndent(Indentation):
    #def preBicrystal(self,
    def __init__(self,
                 modelname='ind_bicrystal',
                 label='', # informative label
                 ori1=None, # orientation grain 1
                 ori2=None, # orientation grain 2
                 gbn=None, # grain boundary normal in xyz
                 trace_ang=None, # 0° // X, 90° // Y
                 inclination=None, # vertical = 90°, 0.. 90 cuts through grain 1, 90 ..180  through grain 2
                 d=None, # distance of indent from GB
                 len_trace=None,
                 h_indent=0.3, # depth of the indent in µm
                 tipRadius=1.4, # radius of the spherical indenter in µm
                 geo='conical', # angle of the conical indenter in degree
                 coneAngle=90.,
                 ind_size=None,
                 #lengthScale = 1.
                 wid=4, # width of the sample
                 hei=4, # height of the sample
                 len=4, # length of the sample
                 box_elm_nx=4, # number of elements in x direction
                 box_elm_nz=4, # number of elements in z direction
                 box_elm_ny1=6, # number of elements in y direction in the grain B
                 box_elm_ny2_fac=7, # parameter which factorized the number of elements in y direction in the middle part
                 box_elm_ny3=6, # number of elements in y direction in the grain A
                 box_bias_x=-0.2, # bias in the x direction
                 box_bias_z=0.25, # bias in the z direction
                 box_bias_y1=0.3, # bias in y direction in the grain B
                 box_bias_y2=0, # bias in y direction in the middle part
                 box_bias_y3=-0.3, # bias in y direction in the grain A
                 smv=0.01, # small values
                 lvl=1 # mesh quality value
    ):
        import math

        if ori1 == None:
            ori1 == [0., 0., 0.]
        if ori2 == None:
            ori2 == [0., 0., 0.]
        if 0:#gbn == None and (trace_ang == None and inclination == None):
            #gbn = -np.array([2., 1., 3.])
            gbn = np.random.rand(3)
            gbn = gbn / np.linalg.norm(gbn)
            gbn[2] *= 0.3
        elif 1:#gbn == None:
            print 'gbn not given, using trace_ang and inclination.'
            if inclination == None:
                inclination = 90.
                inclination = np.random.rand() * 180.
            if trace_ang == None:
                trace_ang = 90.
                trace_ang = np.random.rand() * 360.
            print('RND inclination: ', inclination)
            print('RND trace_ang:', trace_ang)
            gbn = np.array([math.cos((trace_ang - 90.) / 180. * math.pi), \
                            math.sin((trace_ang - 90.) / 180. * math.pi),
                            math.tan((inclination - 90.) / 180. * math.pi)])
            gbn /= np.linalg.norm(gbn)
            gbtn_xy = np.linalg.norm(gbn[0:2])
            print('ang_gbn-z:', math.acos(np.dot(gbn, self.e3())) / math.pi * 180.)
            #gbn[2] = math.atan(inclination/180.*math.pi)

        else:
            raise ('Only gbn OR trace_ang and inclination can be given')

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
            wid = len_trace # 2nd setting line 242 ???

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
        self.start()
        self.procNewModel()
        self.procSample()
        self.procBicrystal(label=label,
                           ori1=ori1, #not used yet
                           ori2=ori2, # not used yet
                           gbn=gbn,
                           d=d,
                           hei=hei,
                           wid=wid,
                           len=len,
                           inclination=inclination,
                           ind_size=ind_size,
                           box_elm_nx=box_elm_nx,
                           box_elm_nz=box_elm_nz,
                           box_elm_ny1=box_elm_ny1,
                           box_elm_ny2_fac=box_elm_ny2_fac,
                           box_elm_ny3=box_elm_ny3,
                           box_bias_x=box_bias_x,
                           box_bias_z=box_bias_z,
                           box_bias_y1=box_bias_y1,
                           box_bias_y2=box_bias_y2,
                           box_bias_y3=box_bias_y3,
                           smv=smv,
                           lvl=lvl,
                           len_trace = len_trace)
        #lengthScale = lengthScale)
        print 'width: ', wid
        print 'length: ', len
        print 'heigth: ', hei
        print 'd: ', d
        self.IndentParameters = {}
        self.IndentParameters['2D'] = False
        self.IndentParameters['coneHalfAngle'] = coneAngle / 2
        self.IndentParameters['coneAngle'] = coneAngle
        self.IndentParameters['h_indent'] = h_indent
        self.IndentParameters['tipRadius'] = tipRadius
        self.IndentParameters['indAxis'] = 'z'
        self.IndentParameters['smv'] = 1e-3
        self.IndentParameters['friction'] = 0.3
        self.IndentParameters['nSteps'] = 800
        self.IndentParameters['outStep'] = 5
        self.IndentParameters['ind_time'] = 10.
        self.IndentParameters['h_sample'] = hei
        self.IndentParameters['w_sample'] = wid
        self.IndentParameters['len_sample'] = len/2
        twoDimensional = False
        Dexp = None
        #self.procParametersIndent()
        self.procParametersIndentBicrystal()
        self.procIndenter()
        #self.proc.append('\n*stop\n*clear_geometry\n') #indenter modeling relies on fixed numbers
        self.proc.append('\n*clear_geometry\n') #indenter modeling relies on fixed numbers
        self.procIndenterConical(coneHalfAngle=self.IndentParameters['coneHalfAngle'])
        #self.procIndenterModel() # separate model
        if geo == 'conical': self.procIndenterConical(coneHalfAngle=self.IndentParameters['coneHalfAngle'])
        if geo == 'flatPunch': self.procIndenterFlatPunch(tipRadius=self.IndentParameters['tipRadius'])
        #self.procSample()
        #self.procSampleIndent(smv=self.IndentParameters['smv'])
        self.procBoundaryConditions()
        self.procBoundaryConditionsBicrystal()
        if twoDimensional: self.procSampleIndent2D()
        if self.CODE == 'DAMASK':
            self.procInitCondSV(label='icond_temperature',
                                StateVariableNumber=1,
                                StateVariableValue=300)
            self.procInitCondSV(label='icond_homogenization_%i' % 1,
                                StateVariableNumber=2,
                                StateVariableValue=1)
            for ms, el in enumerate(['grain1', 'grain2']):
                self.procInitCondSV(label='icond_microstructure_%i' % (ms + 1),
                                    StateVariableNumber=3,
                                    StateVariableValue=ms + 1,
                                    elements=el)
        else:
            self.procInitCond(
                iconds=['icond_grain1', 'icond_grain2'],
                ic_els=['grain1', 'grain2'])
        self.procMaterial()
        self.procGeometricProperties()
        self.procContact()
        self.procContactIndent()
        self.procLoadCaseIndent(nSteps=self.IndentParameters['nSteps'])
        self.procJobDef()
        self.procJobDefIndent()
        self.procFriction()
        self.procAnalysisOptions()
        self.procJobResults(step=self.IndentParameters['outStep'])
        self.procJobParameters()
        if 0:
            self.procViewSetsIndent()
        savename = modelname + ['_', ''][label == ''] + label
        savename += '_fric%.1f' % self.IndentParameters['friction']
        if geo == 'conical':
            savename += '_R%.2f' % self.IndentParameters['tipRadius']
            savename += '_cA%.1f' % self.IndentParameters['coneAngle']
        savename += '_h%.3f' % self.IndentParameters['h_indent']

        self.procSaveModel(modelname=savename + '.mfd')
        self.procMicronbar(posXYZ=[0., 0., 0.], height=h_indent)
        if Dexp is not None:
            self.procExpIndent(D=Dexp, Z=h_indent)
        self.proc.append('*save_as_model %s yes' % (savename + '.mfd'))
        self.procfilename = savename + '.proc'
        #self.printCommands(self.proc,filename=)
        #self.define_post_vars()
        #self.printCommands(self.proc,filename='bicrystal_ind.proc')
        #self.define_post_vars(nslip=18) #Ti

    def procBicrystal(self,
                      label='',
                      ori1=None,
                      ori2=None,
                      trace_ang=None, # 0...360 from X-axis
                      inclination=None, # ? ... ? spans 180°:
                      # suggestion: 90 is vertical, >90 makes grain 1 larger
                      gbn=None, # given or calculated from tr_ang & inclination
                      d=None,
                      # d>0 := ind in grain #1 or grainA (left of the GB), d<0 ind in grain #2 or grainB (right of the GB)
                      ind_size=1., # approximate indent diameter
                      lvl=None, # mesh refining level, higher is finer
                      #lengthScale = 1.  # switch between µm and SI (meter)
                      wid=None, # width of the sample
                      hei=None, # height of the sample
                      len=None, # length of the sample (dimension perpendicular to gb trace)
                      box_elm_nx=None, # number of elements in x direction
                      box_elm_nz=None, # number of elements in z direction
                      box_elm_ny1=None, # number of elements in y direction in the grain B
                      box_elm_ny2_fac=None, # number of elements in y direction in the middle part
                      box_elm_ny3=None, # number of elements in y direction in the grain A
                      box_bias_x=None, # bias in the x direction
                      box_bias_z=None, # bias in the z direction
                      box_bias_y1=None, # bias in y direction in the grain B
                      box_bias_y2=None, # bias in y direction in the middle part
                      box_bias_y3=None, # bias in y direction in the grain A
                      smv=None, # small values    
                      len_trace = None                      
    ):
    #if lengthScale != 1.:
        #    vals=d,hei,wd,len,ind_size
        #    for val in d,hei,wd,len,ind_size = [x==None or x * lengthScale for ]
        #os.chdir('M:/zambaldi') # /egr/research/BielerFEM/zambaldi
        smv = wid / 1000.
        origin = np.array([0., 0., 0.])
        #if trace_ang is not None:
        # Implement gbn calculation here #TODO
        gbn = np.array(gbn)
        #if gbn[2]<0: gbn = -gbn
        gbn = gbn / np.linalg.norm(gbn)
        gbtn_xy = [gbn[0], gbn[1], 0.] # normal on gb-trace in X-Y plane
        norm_gbtn_xy = np.linalg.norm(gbtn_xy)
        gbtn_xy /= norm_gbtn_xy
        gbtn_xy = np.array(gbtn_xy)
        #trace_ang = np.math.atan(gbn[1]/gbn[0])/np.math.pi*180.
        # atan2(y,x)

        trace_ang = (np.math.atan2(gbn[1], gbn[0]) / np.math.pi * 180. + 90.) % 360.
        print('trace_ang: ', trace_ang)
        min_margin = len/2
        #min_margin = 3. * ind_size # outer margin in both grains normal to gb
        #d_vec = -gbtn_xy * d   # vector from the gb to the indent center
        d_vec = np.array([np.math.cos(self.deg2rad(trace_ang + np.sign(d) * 90.)),
                          np.math.sin(self.deg2rad(trace_ang + np.sign(d) * 90.)), 0.]) * abs(
            d)   # vector from the gb to the indent center
        if np.dot(d_vec, gbtn_xy) > 0.:
            gbn = -gbn
            gbtn_xy = -gbtn_xy
        d_vec_norm = np.linalg.norm(d_vec)
        if d_vec_norm < 1e-3: # indent on gb
            d_dir = gbtn_xy # correct?
        else:
            d_dir = d_vec / d_vec_norm
            #wid = 5. * ind_size
        gb_trace_center = - d_vec
        gb_trace = np.array([-gbtn_xy[1], gbtn_xy[0], 0.0])
        gb_trace /= np.linalg.norm(gb_trace)
        print('gb_trace: ', gb_trace)
        gb_trace_0 = gb_trace_center
        gb_trace_1 = gb_trace_center + gb_trace * wid / 2.
        gb_dir = np.cross(gb_trace, gbn) # direction along gb
        gb_dir /= np.linalg.norm(gb_dir)
        if gb_dir[2] > 0.:
            gb_dir = -gb_dir
        print('gb_dir:', gb_dir)
        self.gb_dir = gb_dir
        print('gb_dir-z:', math.acos(np.dot(gb_dir, self.e3())) / np.pi * 180.)
        g1_dir = np.array([np.cos(self.deg2rad(trace_ang + 90.)),
                           np.sin(self.deg2rad(trace_ang + 90.)), 0.])
        g1_dir /= np.linalg.norm(g1_dir)
        print('g1_dir: ', g1_dir)
        print('d_vec_u: ', d_vec / d_vec_norm)
        h_vec = np.array([0., 0., -hei])
        inclination = np.math.acos(np.dot(g1_dir, gb_dir)) / np.pi * 180.
        #print('inclination: ', inclination)
        #gb_shift = gbtn_xy * gbn[2]/norm_gbtn_xy * hei
        #gb_shift = g1_dir * np.math.sin(self.deg2rad(90.-inclination)) * hei
        shift_val = 1. / np.math.tan(inclination / 180. * np.pi)
        if abs(shift_val) > 1e-3 * ind_size:
            gb_shift = g1_dir * shift_val * hei
        else:
            gb_shift = g1_dir * 0.
            #gb_shift = np.dot(g1_dir,gb_dir) * np.sign(d) * hei

        if d >= 0.:
            beg_g1 = g1_dir * (min_margin)
            end_g2 = -g1_dir * (min_margin + d)
        else:
            beg_g1 = g1_dir * (min_margin - d)
            end_g2 = -g1_dir * (min_margin)

        #print norm_gbtn_xy
        #print norm_gbtn_xy/gbn[2]
        #print 'gb_shift: ', gb_shift
        #print '|gb_shift|: ', np.linalg.norm(gb_shift)
        #print 'wid: ', wid, '(along x axis, in um)'
        #print 'len: ', len, '(along y axis, in um)'
        #print 'hei: ', hei, '(along z axis, in um)'
        print 'inclination: ', inclination, '(in degree)'
        print 'd: ', d, '(Distance between indent and GB in um)'
        print 'box_bias_x : ', box_bias_x
        #print 'gbn: ', gbn
        #print 'gbtn_xy:', gbtn_xy
        #print 'd_vec_norm:', d_vec_norm, '(Dist from gb)'
        norm_beg_g1 = np.linalg.norm(beg_g1)
        norm_end_g2 = np.linalg.norm(end_g2)
        print 'norm_beg_g1: ', norm_beg_g1
        print 'norm_end_g2: ', norm_end_g2
        p_list = [[0, 0, 0], # 1
                  beg_g1,
                  end_g2,
                  end_g2 + gb_trace * wid / 2.,
                  beg_g1 + gb_trace * wid / 2., # 5
                  beg_g1 + h_vec,
                  end_g2 + h_vec,
                  end_g2 + h_vec + gb_trace * wid / 2.,
                  beg_g1 + h_vec + gb_trace * wid / 2.,
                  -d_vec, #gb_trace_0,                        #10
                  gb_trace_1,
                  gb_trace_0 + h_vec + gb_shift,
                  gb_trace_1 + h_vec + gb_shift,
                  gb_trace_center,
                  gb_trace_center + gbn * ind_size * 4., # gbn 'vector'
                  # three more for third element
                  #d_vec ,         #16
                  #d_vec + gb_trace * wid/2.,         #17
                  #d_vec + h_vec + gb_shift/2.,
                  #d_vec + gb_trace * wid/2. + h_vec + gb_shift/2., #19
                  #---
                  gb_trace * wid / 2., #16
                  h_vec + gb_shift,
                  h_vec + gb_shift + gb_trace * wid / 2., #18

        ]
        self.proc.append('''
*define hei %e''' % (hei) + '''
*define wid %e''' % (wid) + '''
*define len %e
''' % (len/2) +
                         self.proc_points(p_list) +
                         self.proc_nodes(p_list) + '''
|*set_point_labels off
*set_point_labels on
|*set_node_labels on
*regenerate
*set_curve_type line
*add_curves
2 3
3 4
4 5
5 2
10 11
14 15
*set_curve_type circle_cr
*add_curves
0 0 0
%e''' % (ind_size / 2.) + '''
*set_curve_type line
*add_surfaces
10 12 13 11
*set_element_class hex8
|*stop
*add_elements
|6 12 1min_margin 10 11 5  | worked.
|---
| 6 18 19  9  2 16 17  5  
|18 12 13 19 16 10 11 17
''')
        if d >= 0.:
            self.proc.append('''
*add_elements      
 6 17 18  9  2 1 16  5  
17 12 13 18 1 10 11 16 
 
*store_elements grain1
1 2 
#
*add_elements
12 7 8 13 10 3 4 11
*store_elements grain2
3
#
''')
        else: # d<0
            self.proc.append('''
*add_elements      
| 6 17 18  9  2 1 16  5
  6 12 13  9  2 10 11  5  
|17 12 13 18 1 10 11 16 
*store_elements grain1
1  
#
*add_elements
|17 12 13 18 1 10 11 16
 12 17 18 13 10 1 16 11
|12 7 8 13 10 3 4 11
 17 7 8 18 1 3 4 16
*store_elements grain2
2 3
#
''')
        self.proc.append('''
*store_elements block2 | elements between indenter and gb    
2
#
''')
        if d == 0.:
            self.proc.append('''
*remove_elements | elements between indenter and gb not needed    
2
#
''')
        self.proc.append('''
*set_surface_type quad
*add_surfaces
8 13 11 4
4 11 10 3
7 8 4 3
12 7 3 10
7 8 13 12
*subdivide_reset
| Element block that does not contain the indent
*sub_divisions
%i %i %i''' % (np.math.ceil(box_elm_ny1 * lvl), np.math.ceil(box_elm_nx * lvl), np.math.ceil(box_elm_nz * lvl)) + '''
*sub_bias_factors
%f %f %f''' % (box_bias_y1, box_bias_x, box_bias_z) +'''
*subdivide_elements
1 #
| Central block of elements
*sub_divisions
%i %i %i''' % (np.math.ceil(abs(d) * box_elm_ny2_fac * lvl), np.math.ceil(box_elm_nx * lvl), np.math.ceil(box_elm_nz * lvl)) + '''
*sub_bias_factors
%f %f %f''' % (box_bias_y2, box_bias_x,  box_bias_z) +'''
*subdivide_elements
2 #
| Element block with indent
*sub_divisions
%i %i %i''' % (np.math.ceil(box_elm_ny3 * lvl), np.math.ceil(box_elm_nx * lvl), np.math.ceil(box_elm_nz * lvl)) + '''
*sub_bias_factors
%f %f %f''' % (box_bias_y3, box_bias_x, box_bias_z) +'''
*subdivide_elements
3 #
''')
        self.proc.append('''
*elements_solid
|*set_elements off
*regen
*set_symmetry_normal
%e %e %e ''' % (float(gb_trace[0]), float(gb_trace[1]), float(gb_trace[2])) + '''
*symmetry_elements
all_existing

|---- backrotate model for half box select
*move_reset
*set_move_rotations
0 0 %e''' % (-(trace_ang - 90)) + '''
*move_elements
all_existing

*select_method_box
*select_elements
%f %f ''' % (-min_margin - abs(d) - smv, min_margin + abs(d) + smv) + '''
%f %f ''' % (-wid - smv, 0. + smv) + '''
%f %f ''' % (-hei - smv, 0. + smv) + '''
*store_elements half
all_selected
*select_clear

*select_nodes
%f %f ''' % (-min_margin - abs(d) - smv, min_margin + abs(d) + smv) + '''
%f %f ''' % (-wid / 2. - smv, -wid / 2. + smv) + '''
%f %f ''' % (-hei - smv, 0. + smv) + '''
*store_nodes side_neg
all_selected
*select_clear
*select_nodes
%f %f ''' % (-min_margin - abs(d) - smv, min_margin + abs(d) + smv) + '''
%f %f ''' % (wid / 2. - smv, wid / 2. + smv) + '''
%f %f ''' % (-hei - smv, 0. + smv) + '''
*store_nodes side_pos
all_selected
*select_clear
*select_nodes
%f %f ''' % (-min_margin - abs(d) - smv, min_margin + abs(d) + smv) + '''
%f %f ''' % (-wid / 2. - smv, +wid / 2. + smv) + '''
%f %f ''' % (-0. - smv, 0. + smv) + '''
*store_nodes top_surface
all_selected
*select_clear
*select_nodes
%f %f ''' % (-min_margin - abs(d) - smv, min_margin + abs(d) + smv) + '''
%f %f ''' % (-wid / 2. - smv, +wid / 2. + smv) + '''
%f %f ''' % (-hei - smv, -hei + smv) + '''
*store_nodes bottom_surface
all_selected
*select_clear
*select_nodes
|%f %f ''' % (-min_margin - abs(d) * float(d > 0) - smv,
              -min_margin - abs(d) * float(d > 0) + smv) + '''
%f %f ''' % (-norm_beg_g1 - smv,
             -norm_beg_g1 + smv) + '''
%f %f ''' % (-wid / 2. - smv, +wid / 2. + smv) + '''
%f %f ''' % (-hei - smv, 0. + smv) + '''
*store_nodes end_grain1
all_selected
*select_clear
*select_nodes
|%f %f ''' % (+min_margin + abs(d) * float(d > 0) - smv,
              +min_margin + abs(d) * float(d > 0) + smv) + '''
%f %f ''' % (+norm_end_g2 - smv,
             +norm_end_g2 + smv) + '''
%f %f ''' % (-wid / 2. - smv, +wid / 2. + smv) + '''
%f %f ''' % (-hei - smv, 0. + smv) + '''
*store_nodes end_grain2
all_selected
*select_clear

*select_reset
*select_filter_surface
*select_nodes
all_existing
*select_mode_except
*select_nodes
top_surface
*store_nodes surf_but_top
all_selected
*select_clear

*set_move_rotations
0 0 %e''' % (trace_ang - 90) + '''
*move_elements
all_existing
*move_reset

*select_reset
|----
*select_clear
*check_inside_out
*flip_elements
all_selected
|----
*sweep_all
*renumber_all
|----
*select_clear
*select_set
half
|*invisible_selected
*set_points off
|*surfaces_solid
*identify_sets *regen
''')

    def procBoundaryConditionsBicrystal(self):
        self.proc.append('''
*fill_view
*new_apply
*apply_name
all_fixed
*apply_dof x *apply_dof_value x
0
*apply_dof y *apply_dof_value y
0
*apply_dof z *apply_dof_value z
0
|*select_method_box
|*dynamic_model_off
|*select_nodes
|-d_sample d_sample
|-d_sample d_sample
|-h_sample-0.01 -h_sample+0.01
|#
*add_apply_nodes
|surf_but_top
side_pos side_neg end_grain1 end_grain2 bottom_surface
|*all_selected *select_reset
''')


    def procParametersIndentBicrystal(self):
        self.proc.append('''
| GEOMETRY
*define h_sample %f  ''' % self.IndentParameters['h_sample'] + '''    | large tip radii

| MESH

| INDENTER VELOCITY, "STRAIN RATE"
| Time used for LoadCase "indentation"
*define ind_time %f  | in [10e-3*seconds] for model in micrometer, gamma0?!!?''' % (self.IndentParameters['ind_time']) + '''
    ''') 
                     

