# -*- coding: utf-8 -*-
"""
@author: c.zambaldi
"""

from base import Proc


class Indenter(Proc):
    '''MSC.Marc/Mentat procedure file writer for Indenter geometries.
    '''
    #def __init__(self):
    #    pass

    def procIndenterModel(self,
                          modelname='indenter',
                          h_indent=0.20,
                          D_sample=None,
                          geo=None,
                          sample_rep=24, # 24, 48
                          Dexp=None,
                          twoDimensional=False,
                          free_mesh_inp=None):
        coneAngle = 120.
        h_indent = 0.25
        tipRadius = 1.6
        geo = ''
        free_mesh_inp

        # create dictionary of parameters
        self.IndentParameters = {
            'coneAngle': coneAngle,
            'coneHalfAngle': coneAngle / 2.,
            #'friction':friction,
            'h_indent': h_indent, # indentation depth
            #'sample_rep':sample_rep,
            'tipRadius': tipRadius,
            #'D_sample':D_sample, # not yet implemented, governed by h_indent
            #'ind_time':ind_time, # in seconds, since dotgamma_0 is in perSecond
            #'dwell_time':dwell_time, # time at maximum load
            'Dexp': Dexp, # experimental remaining indent diameter
            'indAxis': 'z', # however, indDirection is -z
            '2D': twoDimensional, #2D model flag
            'geo': geo,
            'free_mesh_inp': free_mesh_inp} 
        if twoDimensional: self.IndentParameters['indAxis'] = 'y'
        print(repr(self.IndentParameters))
        self.proc = []
        self.start(title='INDENTER-MODEL (%s)' % modelname)
        self.procNewModel()
        self.procIndenter()
        self.proc.append('''
*set_duplicate translation z 
-%f''' % (h_indent) + '''
*duplicate_surfaces
indenter_surfaces
#
''')
        if geo == 'conical':
            self.procIndenterConical(coneHalfAngle=self.IndentParameters['coneHalfAngle'])
        savename = modelname
        #savename=modelname+'_fric%.1f'%self.IndentParameters['friction']
        if geo == 'conical':
            savename += '_R%.2f' % self.IndentParameters['tipRadius']
            savename += '_cA%.1f' % self.IndentParameters['coneAngle']
        if geo == 'AFM':
            self.procIndenterAFMtopo(free_mesh_inp=self.IndentParameters['free_mesh_inp'])
        savename += '_h%.3f' % self.IndentParameters['h_indent']
        self.procSaveModel(modelname=savename + '.mfd')
        #self.procMicronbar(posXYZ=N.array([0., 0., 0.]),height=h_indent)
        if Dexp is not None:
            self.procExpIndent(D=Dexp, Z=h_indent)
            #self.proc.append('*save_as_model %s yes'%(savename+'.mfd'))
        self.procfilename = savename + '.proc'
        #self.print_commands(self.proc,filename=)
        #self.define_post_vars()

    def procIndenter(self):# geo={berko | cc | conical}):
        self.proc.append('''
|+++++++++++++++++++++++++++++++++++++++++++++
| INDENTER-MODELING
|+++++++++++++++++++++++++++++++++++++++++++++
''')

    def procIndenterConical(self,
                            coneHalfAngle=45,
                            tipRadius=0.1,
                            geo=None):
        if geo != None:
            if geo == 'berkovich':
                coneHalfAngle = 90 - 19.7
            if geo == 'cubecorner':
                coneHalfAngle = 90 - 47.72
        self.proc.append('''
|+++++++++++++++++++++++++++++++++++++++++++++
| PARAMETERS FOR THE CONICAL INDENTER
|+++++++++++++++++++++++++++++++++++++++++++++
| GEOMETRY
|*define indenter_ang 90-70.3  || 19.7, Standard Berkovich A=24.5*h**2
|*define indenter_ang 90-70.3   || 19.7, equ. to Modified Berkovich A=24.5033*h**2
|*define indenter_ang 90-42.28  || 47.72, equ. to Cube Corner A=2.598*h**2
*define indenter_ang %f''' % (coneHalfAngle) + '''

*define h_indent %f''' % (self.IndentParameters['h_indent']) + '''|0.20          || 3000 mikroN for Berkovich geometry in TiAl
*define tipRadius %f''' % (self.IndentParameters['tipRadius']) +
                         ''' || radius of spherical tip

|+++++++++++++++++++++++++++++++++++++++++++++
| CONICAL INDENTER-MODELING
|+++++++++++++++++++++++++++++++++++++++++++++
*expand_reset
*set_curve_type arc_cpa
*add_curves
0 tipRadius 0   | was tipradius/2 
0 0 0
90-indenter_ang

*add_points
0 0 tipRadius

*set_curve_type tangent
*define l_tangent h_indent/sin((90-indenter_ang)/180*pi)*1.6
*add_curves
3
l_tangent spherical
|tipRadius*.4 spherical
*set_move_rotation x 90
*set_move_rotation y 0
*set_move_rotation z 0
''')
        if self.IndentParameters['2D'] == False:
            self.proc.append('''
*move_curves
1 2
#
''')
        if self.IndentParameters['2D'] == True and False:
            self.proc.append('''
      |*stop  
*set_plot_curve_div_high *regen
*store_curves indenter_curves
all_existing
*remove_curves
1 2
#
*store_surfaces cono_spherical_curves
all_existing
''')
        else:
            self.proc.append('''
*set_move_rotation x 0
*define exp_rot_ind 3   | 3 degree steps
|*define exp_rot_ind 10   | 10 degree steps
*set_expand_rotation %s ''' % (self.IndentParameters['indAxis']) +
                             '''exp_rot_ind
*set_expand_repetitions (360/exp_rot_ind)+4 | +X is just for avoiding pop through at the seam
*expand_curves
1 2
#
*set_plot_surface_div_high *regen
*remove_curves
1 2
#
*store_surfaces indenter_surfaces
all_existing

*store_surfaces cono_spherical_surfaces
all_existing
''')
        self.IndentParameters['Indenter'] = 'cono_spherical_ang%.0f_R%.2f.mfd' % (
            coneHalfAngle * 2., self.IndentParameters['tipRadius'])
        self.proc.append('''
*save_as_model ''' + self.IndentParameters['Indenter']
                         + ''' yes
''')

    def procIndenterFlatPunch(self, tipRadius=0.1):
        self.proc.append('''
|+++++++++++++++++++++++++++++++++++++++++++++
| PARAMETERS FOR FLAT PUNCH INDENTER
|+++++++++++++++++++++++++++++++++++++++++++++
| GEOMETRY
*define h_indent %f''' % (self.IndentParameters['h_indent']) + '''|0.20          || 3000 mikroN for Berkovich geometry in TiAl
*define tipRadius %f''' % (self.IndentParameters['tipRadius']) +
                         ''' || radius of flat punch

|+++++++++++++++++++++++++++++++++++++++++++++
| MODELING OF FLAT PUNCH INDENTER 
|+++++++++++++++++++++++++++++++++++++++++++++
*expand_reset
*set_curve_type line |arc_cpa
*add_points
0 0 0
tipRadius 0 0 
tipRadius 0 h_indent*4

*add_curves
1 
2
2
3


|tipRadius*.4 spherical
*set_move_rotation x 90
*set_move_rotation y 0
*set_move_rotation z 0
''')
        self.proc.append('''
*set_move_rotation x 0
*define exp_rot_ind 3   | 3 deg steps
*set_expand_rotation %s ''' % (self.IndentParameters['indAxis']) +
                         '''exp_rot_ind
*set_expand_repetitions (360/exp_rot_ind)+4 | +X is just for avoiding pop through at the seam
*expand_curves
1 2
#
*set_plot_surface_div_high *regen
*remove_curves
1 2
#
*store_surfaces indenter_surfaces
all_existing

*store_surfaces flat_punch_surfaces
all_existing
''')
        self.IndentParameters['Indenter'] = 'flat_punch_R%.2f.mfd' % (self.IndentParameters['tipRadius'])
        self.proc.append('''
*save_as_model ''' + self.IndentParameters['Indenter']
                         + ''' yes
''')

    def procIndenterBerkovich(self, edgeRadius=0.0, tipRadius=0.0):
        self.proc.append('''
|+++++++++++++++++++++++++++++++++++++++++++++
| PARAMETER-DEFINITION
|+++++++++++++++++++++++++++++++++++++++++++++
| GEOMETRY
*define h_indenter 1
|*define alpha 65.03/180*pi
*define alpha (90-65.03)/180*pi
*define a h_indenter*tan(pi/2-alpha)*sqrt(12) | sidelength of cross-sectional triangle
*define r_i a/sqrt(12) | innkreisradius
*define r_u a/sqrt(3)  | umkreisradius

|*define d_ball 1.0
*define indenter_ang 90
*define d_sample 5
*define r_sample d_sample/2
*define h_indent 0.1
*define h_sample 1.6         | 10*h_indent
| MESH
*define sample_rep 24 |No of Sample Sectors...
|Sector Angle is 360/sample_rep...
|12=>30, 16=>22.5, 18=>20, 36=>10, 72=>5
*define indenter_rep 41 |should not be equal to sample_rep (?)

| INDENTER VELOCITY
*define ind_time 10  |time used for LoadCase "indentation"

|+++++++++++++++++++++++++++++++++++++++++++++
| INDENTER-MODELING
|+++++++++++++++++++++++++++++++++++++++++++++
*expand_reset
*add_points
0 0 0
a/2 -r_i h_indenter
0 r_u h_indenter
-a/2 -r_i h_indenter
0 0 h_indenter
0 -r_i h_indenter

*set_point_labels on
*set_curve_labels on

*set_curve_type line

*add_curves
1 2
1 3
1 4
2 3
3 4
4 2

*set_surface_type quad
*add_surfaces
2 3 1 2
3 4 1 3
4 2 1 2
|indenter_ang
|*set_curve_type tangent
|*add_curves
|3
|d_ball*.2 | Length of tangent
|*set_move_rotation x 90
|*set_move_rotation y 0
|*set_move_rotation z 0
|*move_curves
|1 2
|#
|*set_move_rotation x 0
|*set_expand_rotation z 360/indenter_rep  | Sektor-Winkel Indenter
|*set_expand_repetitions indenter_rep
|*expand_curves
|1 2
|#
*set_plot_surface_div_high *regen
*remove_curves
all_existing
#

*store_surfaces indenter_surfaces
all_existing
*store_surfaces indenter_surfaces_berko
all_existing
''')

    def procIndenterAFMtopo(self, free_mesh_inp):
        self.proc.append('''
|+++++++++++++++++++++++++++++++++++++++++++++
| MODELING OF AFM INDENTER TOPOGRAPHY
|+++++++++++++++++++++++++++++++++++++++++++++
*import abaqus %s ''' % (self.IndentParameters['free_mesh_inp']) +
'''
''')

    def procIndenterDeformable(self,
                               host=None,
                               lCube=100, dParticle=10,
                               divi=6,
                               divRad=10,
                               matrix_bias=-0.45, # radial mesh refinement of matrix: -0.5 ... 0
                               label=None,
                               procName='Fe3Al',
                               nr_incr=None,
                               eps_max=0.6,
                               radialSplit=True,
                               tipRadius=0.25
    ): # radial split of matrix in fine and coarse mesh
        dParticle = 2#tipRadius
        procName = procName + '_dP%i_div%i' % (dParticle, divi) # also used as modelname
        if label not in [None, '']: procName = procName + '_%s' % label
        self.proc = ['']
        self.start(title='Deformable Indenter',
                   author=self.author)
        self.procNewModel()
        self.procParameters()
        self.modelDim = [lCube]
        refnd1 = 1
        self.periodicRefPairs = [(refnd1, 2), (refnd1, 4), (refnd1, 5)] #
        self.divi[0] = 2 * divi
        self.projdir = './'
        #self.procParametersTessel()
        self.smv = lCube / 1000.
        #if nr_incr is None: nr_incr=int(round(eps_max/0.1*200))
        if nr_incr is None: nr_incr = int(round(eps_max / 0.1 * 100))
        self.procParametersUniax(smv=self.smv,
                                 nr_incr=nr_incr,
                                 eps_max=eps_max)
        self.proc.append('''
*define lCube %f''' % lCube + '''
*define lC lCube
*define dParticle %f''' % (dParticle) + '''
*define rParticle dParticle/2
*define rP rParticle
*define iCsz rParticle/2.2 | size of cube inside Particle
| Subdivisions
*define div_sides %i''' % (divi) + '''
*define div_to_center %i''' % divRad + ''' | radial divisions of matrix
*define tipRadius %f''' % (tipRadius) + '''
''') #shortcut
        #*set_curve_type arc_cpp
        #*add_curves
        #0 0 0
        self.proc.append('''
| Low number corner nodes of model 
|   for easy boundary condition assignment    
*add_nodes | matrix
rP 0 0
|lC/2 0 0
|lC/2 lC/2 0
cos(45/180*pi)*rP sin(45/180*pi)*rP 0
cos(45/180*pi)*rP 0 sin(45/180*pi)*rP
|lC/2 0 lC/2
|lC/2 lC/2 lC/2
|cos(45/180*pi)^2*rP sin(45/180*pi)^2*rP sin(45/180*pi)*rP
rP/sqrt(3) rP/sqrt(3) rP/sqrt(3)
*add_points  | Control point 1 for selection of surf_nodes
0 0 0
''')
        self.proc.append('''
*set_element_class hex8
*add_elements
|1 2 3 4 5 6 7 8
|6 7 8 9 10 11 12 13
*store_elements matrix_elements
all_existing
*add_nodes | Particle
iCsz 0 0
iCsz iCsz 0
iCsz 0 iCsz
iCsz iCsz iCsz
*add_elements
|14 6 9 15 16 10 13 17
1 5 7 3 2 6 8 4
*store_elements particle_elements_outer
1 #\n\n
*add_nodes | Particle interior cube
0 0 0
|iCsz 0 0
|iCsz iCsz 0
0 iCsz 0
0 0 iCsz
|iCsz 0 iCsz
|<-already there
0 iCsz iCsz
*set_node_labels on
*regenerate
*add_elements
|18 19 20 21 22 23 17 24
9 5 6 10 11 7 8 12
*store_elements particle_elements
1 2 #\n\n
*store_elements particle_cube
2 #\n\n
''')
        self.proc.append('''
*subdivide_reset
|*sub_bias_factors  | This probably messes up symmetry?!
|0 -.2 -.2
*sub_divisions
1 div_sides div_sides
|1 3 3
|0 div_sides div_sides
*subdivide_elements
|all_existing
particle_elements_outer 
''')
        self.proc.append('''
*symmetry_reset
*symmetry_elements
all_existing
*set_symmetry_normal
0 1 0
*symmetry_elements
all_existing
*set_symmetry_normal
0 0 1
*symmetry_elements
all_existing
*store_elements drittel_el
all_existing
*select_elements
all_existing
*set_duplicate_rotations
0 0 90
*duplicate_elements
all_selected
*store_elements drittel_elX
all_selected
*set_duplicate_rotations
0 90 0
*duplicate_elements
drittel_el
*set_sweep_tolerance 0.005
*sweep_all
*fill_view
''')
        self.proc.append('''
*subdivide_reset
*sub_divisions
div_sides div_sides div_sides
*subdivide_elements
particle_cube \n\n 
*subdivide_reset
*sweep_all\n*renumber_all
*select_clear
*select_reset
''')
        self.proc.append('''
| Make particle rounder :: use *move_nodes_to_surface
*set_surface_type sphere
*add_surfaces
0 0 0  |center
rP     |radius
*store_surfaces rP_sphere
1 #
*select_reset
*select_clear
*sweep_all
*renumber_all
*select_filter_surface
*select_nodes_elements
particle_elements
|*select_mode_intersect
|*select_nodes_elements
|matrix_elements
|*select_method_point_dist
*store_nodes particle_surf_nodes
all_selected
*select_reset
*select_clear

*move_nodes_to_surface
1
particle_surf_nodes
|*stop

|*set_node_labels on
|*edges_full *regenerate
|*stop
''')
        self.proc.append('''
*subdivide_reset
*sub_bias_factors
-.2 0 0
*sub_divisions
3 1 1
|0 div_sides div_sides
*subdivide_elements
particle_elements_outer
*subdivide_reset
*sweep_all\n*renumber_all
*select_clear
*select_reset
''')
        self.procCleanUp()
        self.proc.append('''
*select_clear
*select_reset
*select_method_box
*select_nodes
lC/2-smv lC/2+smv
0-smv lC/2+smv
0-smv lC/2+smv
*select_reset
*select_elements_nodes
all_selected
*store_elements matrix_elements_outer
all_selected
*select_elements matrix_elements
*select_mode_except
*select_elements matrix_elements_outer
*select_reset
*store_elements matrix_elements_inner
all_selected
*select_clear
*select_reset
''')
        self.procCleanUp()
        self.proc.append('''
*select_clear
*select_reset
*select_method_box
*select_elements
-lC-smv lC+smv
-lC-smv lC+smv
0-0.0001 lC+smv
*store_elements half_elements
*remove_elements
all_selected
*remove_unused_nodes
*remove_unused_points
all_selected
*select_clear
*select_nodes
-lC-smv lC+smv
-lC-smv lC+smv
-smv +smv
*store_nodes indenter_top_nodes
all_selected
*store_elements indenter_elements
particle_elements
| RELAX MESH ++++
|*select_clear
|*select_reset
|*select_nodes_elements
|particle_elements
|*set_relax_tolerance
|smv
|*relax_surface_fixed
|*relax_nodes
|all_selected

*select_clear
*select_reset
|| The following lines would change the particle shape /!\ 
|*select_nodes_elements
|particle_elements
|*set_relax_tolerance
|smv
|*relax_surface_fixed
|*relax_nodes
|all_selected
|*select_clear
''')
        self.proc.append('''
*move_reset
*set_move_scale_factors
tipRadius tipRadius tipRadius
*set_move_translations
0 0 %f''' % (tipRadius) + '''
*move_elements
all_existing
#
*move_reset
*fill_view
''')
        self.procfilename = 'indenterDeformable.proc'
