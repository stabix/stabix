# -*- coding: utf-8 -*-
"""
@author: c.zambaldi
"""
try:
    import numpy as np
except:
    np = None


class Sketch():
    '''Illustrate some experimental features
    '''

    def procMicronbar(self, posXYZ=[0., 0., 0.],
                      length=1., width=1., height=1.):
        pts = np.array([])
        #width=length*1.
        #height=length*1.
        wVec = np.array([0., width, 0.])
        lVec = np.array([length, 0., 0.])
        hVec = np.array([0., 0., height])
        posXYZ = posXYZ - 0.5 * wVec - 0.5 * lVec#-0.5*hVec # CENTERING Y/N
        posXYZ = np.array(posXYZ)
        pts = [posXYZ, posXYZ + lVec,
               posXYZ + wVec,
               posXYZ + wVec + lVec]
        pts.extend([pts[0] + hVec, pts[1] + hVec, pts[2] + hVec, pts[3] + hVec])
        self.cmd = ['']
        for p in pts:
            self.cmd.append('''
*add_points
%f %f %f\n''' % (p[0], p[1], p[2]))
        self.proc.extend(self.cmd[:])

    def procExpIndent(self, D=None, Z=0.1):
        # draws a circle a circle of given diameter
        if D == None:
            D = 1.
        self.proc.append('''
*set_curve_type circle_cr
*add_curves
0,0,%f''' % Z + '''
%f\n''' % (D / 2))
