# -*- coding: utf-8 -*-
"""
@author: c.zambaldi
"""

#import numpy as N # old
import numpy as np
import math

from .base import Proc

class BicrystalIndent(Proc):
    def __init__(self,
                 modelname = 'ind_bicrystal',
                 label = '',  # informative label
                 ori1 = None,  # orientation grain 1
                 ori2 = None,  # orientation grain 2
                 gbn = None,  # grain boundary normal in xyz
                 trace_ang = None,  # 0° // X, 90° // Y
                 inclination = None,  # vertical = 90°, 0.. 90 cuts through grain 1, 90 ..180  through grain 2
                 d = None,  # distance of indent from GB
                 len_trace = None,
                 h_indent = 0.3,  # depth of the indent in µm
                 tipRadius = 1.4,  # radius of the spherical indenter in µm
                 geo = 'conical',  # angle of the conical indenter in degree
                 coneAngle = 90.,
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
                 smv = 0.01,  # small values
                 lvl = 1,  # mesh quality value
                 sheetSize = 200,
				 free_mesh_inp = '' #name of the .inp file for AFM topo for indenter
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

        if sheetSize == None:
            if len >= hei:
                sheetSize = 2. * len
            else:
                sheetSize = 2. * hei

        self.proc = []
        self.procNewModel()
        self.procBicrystal(label=label,
                           ori1 = ori1, #not used yet
                           ori2 = ori2, # not used yet
                           gbn = gbn,
                           d = d,
                           hei = hei,
                           wid = wid,
                           len = len,
                           inclination = inclination,
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
                           smv = smv,
                           lvl = lvl,
                           len_trace = len_trace,
                           modelname = modelname,
                           sheetSize = sheetSize)
                           
    def procBicrystal(self,
                      label = '',
                      ori1 = None,
                      ori2 = None,
                      trace_ang = None, # 0...360 from X-axis
                      inclination = None, # ? ... ? spans 180°:
                      # suggestion: 90 is vertical, >90 makes grain 1 larger
                      gbn = None, # given or calculated from tr_ang & inclination
                      d = None,
                      # d>0 := ind in grain #1 or grainA (left of the GB), d<0 ind in grain #2 or grainB (right of the GB)
                      ind_size = 1., # approximate indent diameter
                      lvl = None, # mesh refining level, higher is finer
                      #lengthScale = 1.  # switch between µm and SI (meter)
                      wid = None, # width of the sample
                      hei = None, # height of the sample
                      len = None, # length of the sample (dimension perpendicular to gb trace)
                      box_elm_nx = None, # number of elements in x direction
                      box_elm_nz = None, # number of elements in z direction
                      box_elm_ny1 = None, # number of elements in y direction in the grain B
                      box_elm_ny2_fac = None, # number of elements in y direction in the middle part
                      box_elm_ny3 = None, # number of elements in y direction in the grain A
                      box_bias_x = None, # bias in the x direction
                      box_bias_z = None, # bias in the z direction
                      box_bias_y1 = None, # bias in y direction in the grain B
                      box_bias_y2 = None, # bias in y direction in the middle part
                      box_bias_y3 = None, # bias in y direction in the grain A
                      smv = None, # small values    
                      len_trace = None,
                      modelname = None,
                      sheetSize = None
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
        self.proc.append('''
#width = %e # width of the sample in um''' % (wid) + '''
#height = %e # height of the sample in um''' % (hei) + '''
#length = %e # length of the sample in um''' % (len) +'''

import sketch
import part

mySketch = modelname.ConstrainedSketch(name='Sketch A', sheetSize=%e)''' % (sheetSize) + '''

xyCoords = ((%e , %e),''' % (beg_g1[0], beg_g1[2]) + '''
    (%e , %e),''' % (end_g2[0], end_g2[2]) + '''
    (%e , %e),''' % (beg_g1[0], beg_g1[2] + h_vec[2]) + '''
    (%e , %e),''' % (end_g2[0], end_g2[2] + h_vec[2]) + '''
    (%e , %e))''' % (0, 0) + '''

for i in range(len(xyCoords)-1):
    mySketch.Line(point1=xyCoordsInner[i],
        point2=xyCoordsInner[i+1])

myPart = modelname.Part(name='Sample', dimensionality=THREE_D, type=DEFORMABLE_BODY)
myPart.BaseSolidExtrude(sketch=mySketch, depth=%e)''' % (wid) + '''
''')