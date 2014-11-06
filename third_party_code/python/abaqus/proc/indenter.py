# -*- coding: utf-8 -*-
"""
@authors: R. Sanchez-Martin / C.Zambaldi / D. Mercier
"""

from base import Proc

class Indenter(Proc):
    '''Abaqus file writer for Indenter geometries.
    '''
    #def __init__(self):
    #    pass

    def procIndenterModel(self,
                          modelname='indenter',
                          h_indent=0.20,
                          D_sample=None, geo='conical',
                          sample_rep=24, # 24, 48
                          Dexp=None,
                          twoDimensional=False):
        coneAngle = 120.
        h_indent = 0.25
        tipRadius = 1.6

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
            '2D': twoDimensional} #2D model flag
        if twoDimensional: self.IndentParameters['indAxis'] = 'y'
        print(repr(self.IndentParameters))
        self.proc = []
        self.start(title='INDENTER-MODEL (%s)' % modelname)
        self.procNewModel()
        self.procIndenter()
        self.proc.append('''
''')
        if geo == 'conical':
            self.procIndenterConical(coneHalfAngle=self.IndentParameters['coneHalfAngle'])
        savename = modelname
        #savename=modelname+'_fric%.1f'%self.IndentParameters['friction']
        if geo == 'conical':
            savename += '_R%.2f' % self.IndentParameters['tipRadius']
            savename += '_cA%.1f' % self.IndentParameters['coneAngle']
        savename += '_h%.3f' % self.IndentParameters['h_indent']
        self.procSaveModel(modelname=savename + '.mfd')
        #self.procMicronbar(posXYZ=N.array([0., 0., 0.]),height=h_indent)
        if Dexp is not None:
            self.procExpIndent(D=Dexp, Z=h_indent)
            #self.proc.append('*save_as_model %s yes'%(savename+'.mfd'))
        self.procfilename = savename + '.proc'
        #self.print_commands(self.proc,filename=)
        #self.define_post_vars()

    def procIndenter(self):# geo={berko # cc # conical}):
        self.proc.append('''
#+++++++++++++++++++++++++++++++++++++++++++++
# INDENTER-MODELING
#+++++++++++++++++++++++++++++++++++++++++++++
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
#+++++++++++++++++++++++++++++++++++++++++++++
# PARAMETERS FOR THE CONICAL INDENTER
#+++++++++++++++++++++++++++++++++++++++++++++
coneAngle = %f''' % (coneHalfAngle) + ''' # full angle of the conical tip at the apex in degrees
h_indent = %f''' % (self.IndentParameters['h_indent']) + ''' # indentation depth
tipRadius = %f''' % (self.IndentParameters['tipRadius']) +  ''' # radius of spherical tip'''
# 3000 mikroN for Berkovich geometry in TiAl
#*define indenter_ang 90-70.3  # 19.7, Standard Berkovich A=24.5*h**2
#*define indenter_ang 90-70.3   # 19.7, equ. to Modified Berkovich A=24.5033*h**2
#*define indenter_ang 90-42.28  # 47.72, equ. to Cube Corner A=2.598*h**2
'''
#+++++++++++++++++++++++++++++++++++++++++++++
# CONICAL INDENTER-MODELING
#+++++++++++++++++++++++++++++++++++++++++++++
# 3D analytical rigid indenter

Sketch_indenter = model_name.ConstrainedSketch(name='__profile__', 
    sheetSize=sheet_Size)
g, v, d, c = Sketch_indenter.geometry, Sketch_indenter.vertices, Sketch_indenter.dimensions, Sketch_indenter.constraints

s = Sketch_indenter

Sketch_indenter.setPrimaryObject(option=STANDALONE)
Sketch_indenter.ConstructionLine(point1=(0.0, -100.0), point2=(0.0, 100.0))
Sketch_indenter.FixedConstraint(entity=g[2])

coneAngle = coneAngle*math.pi/180

# Spherical part
r = tipRadius
y_trans = r*(1-sin(coneAngle))
x_trans = r*cos(coneAngle)
Sketch_indenter.ArcByCenterEnds(center=(0.0, r), point1=(x_trans , y_trans), point2=(0.0, 0.0), 
    direction=CLOCKWISE)
    
# Conical part
h_con_part = 1.3*h_indent
x_2 = x_trans + (h_con_part*sin(coneAngle)/cos(coneAngle))
y_2 = y_trans + h_con_part
Sketch_indenter.Line(point1=(x_trans , y_trans), point2=(x_2, y_2))

# Definition of the three-dimensional part
Indenter = model_name.Part(name='indenter', dimensionality=THREE_D, 
    type=ANALYTIC_RIGID_SURFACE)
Indenter = model_name.parts['indenter']

# Symmetry of revolution

Indenter.AnalyticRigidSurfRevolve(sketch=Sketch_indenter)
Sketch_indenter.unsetPrimaryObject()
Indenter = model_name.parts['indenter']
session.viewports['Viewport: 1'].setValues(displayedObject=Indenter)
del model_name.sketches['__profile__']

# Creating instance and positioning the indenter

Indenter = model_name.parts['indenter']
session.viewports['Viewport: 1'].setValues(displayedObject=Indenter)
InstanceRoot = model_name.rootAssembly
session.viewports['Viewport: 1'].setValues(displayedObject=InstanceRoot)
InstanceRoot = model_name.rootAssembly
p = model_name.parts['indenter']
InstanceRoot.Instance(name='indenter-1', part=Indenter, dependent=ON)
InstanceRoot = model_name.rootAssembly
InstanceRoot.rotate(instanceList=('indenter-1', ), axisPoint=(10.0, 0.0, 0.0), 
    axisDirection=(-20.0, 0.0, 0.0), angle=-90.0)
    
InstanceRoot.translate(instanceList=('indenter-1', ), vector=(0.0, 0.0, sep_ind_samp))
'''
)
    def procIndenterFlatPunch(self, tipRadius=0.1):
        self.proc.append('''
#+++++++++++++++++++++++++++++++++++++++++++++
# PARAMETERS FOR FLAT PUNCH INDENTER
#+++++++++++++++++++++++++++++++++++++++++++++

#+++++++++++++++++++++++++++++++++++++++++++++
# MODELING OF FLAT PUNCH INDENTER 
#+++++++++++++++++++++++++++++++++++++++++++++
''')
        self.IndentParameters['Indenter'] = 'flat_punch_R%.2f.mfd' % (self.IndentParameters['tipRadius'])
        self.proc.append('''
''')

    def procIndenterBerkovich(self, edgeRadius=0.0, tipRadius=0.0):
        self.proc.append('''
#+++++++++++++++++++++++++++++++++++++++++++++
# PARAMETER-DEFINITION
#+++++++++++++++++++++++++++++++++++++++++++++
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
        self.procfilename = 'indenterDeformable.proc'
