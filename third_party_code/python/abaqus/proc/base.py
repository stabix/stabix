# -*- coding: utf-8 -*-
"""
@authors: R. Sanchez-Martin / C.Zambaldi / D. Mercier
"""
import os, sys
import math

try:
    import numpy as np
except:
    np = None

import time

#from sketch import Sketch
#from abaqus.tools import abaqus_TOOLS
from tools import Tools

#class Proc(Sketch, abaqus_TOOLS):
class Proc(Tools):
    """ This class defines the common bits needed for writing
        Abaqus Python files.
    """
    import getpass

    author = 'python_package (C. Zambaldi) used by ' + getpass.getuser()
    title = 'model'
    affiliation = 'MPI fuer Eisenforschung, www.mpie.de'
    initConds = []
    CODE = 'GENMAT'
    #CODE = 'DAMASK'
    FEMSOFTWAREVERSION = 2012 # default
    FEMSOFTWARE = 'Abaqus' # default
    modelname = 'Indentation' # default
    description = 'Modelling of indentation test' # default

    header_line_mark = '#+++++++++++++++++++++++++++++++++++++++++++++'

    def __init__(self):
        proc = []  # empty list to hold the procedure file content

    def get_proc(self):
        return self.proc

    def header(self, label):
        """Visually separate the sections in the Abaqus procedure file
        """
        assert(label is not None)
        return '\n' + self.header_line_mark + \
               '# %s\n' % label + \
               self.header_line_mark

    def start(self,
              title=None,
              author=None,
              affiliation=None,
              FEMSOFTWARE=None):
        if title is None: title = self.title
        if author is None: author = self.author
        if affiliation is None: affiliation = self.affiliation
        if FEMSOFTWARE is None: FEMSOFTWARE = self.FEMSOFTWARE
        self.proc.append("""
#|+++++++++++++++++++++++++++++++++++++++++++++
#|  PROCEDURE FILE
#|  FOR USE WITH %s""" % FEMSOFTWARE + """
#|=============================================
#|        TITLE: %s""" % title + """
#|=============================================
#|         AUTHOR: %s""" % author + """
#|           DATE: %s""" % str(time.ctime()) + """
#| GENERATED WITH: ABAQUS package by STABiX (https://github.com/stabix)
#|                 %s""" % affiliation + """
#|+++++++++++++++++++++++++++++++++++++++++++++
#| USAGE IN ABAQUS:
#|   /!\ Save current model /!\, then
#|   FILE > RUN SCRIPT
#|+++++++++++++++++++++++++++++++++++++++++++++
""")

    def procNewModel(self,
                     modelname=None,
                     description=None):
        if modelname is None: modelname = self.modelname
        if description is None: description = self.description
        self.proc.append('''
#+++++++++++++++++++++++++++++++++++++++++++++
# NEW MODEL
#+++++++++++++++++++++++++++++++++++++++++++++
from abaqus import *
from abaqusConstants import *
from caeModules import *
from driverUtils import executeOnCaeStartup
#executeOnCaeStartup()

backwardCompatibility.setValues(includeDeprecated=True, reportDeprecated=False)

import regionToolset
import displayGroupMdbToolset as dgm
import part
import material
import assembly
import step
import interaction
import load
import mesh
#import optimization
import job
import sketch
import visualization
import xyPlot
import displayGroupOdbToolset as dgo
import connectorBehavior
import math

# Remove mask format from the script
cliCommand("""session.journalOptions.setValues(replayGeometry=
    COORDINATE, recoverGeometry=COORDINATE)""")

sample_name = 'sample'
model_name = mdb.Model(name='%s')''' % modelname + '''
model_name.setValues(description='%s')''' % description + '''
''')

    def procIndentDocCall(self):
        self.proc.append('''
''')
        #P=self.IndentParameters
        P = self.callerDict
        callString = 'preIndentation('
        for k in iter(P):
            callString += '%s=%s, ' % (k, str(P[k]))
        self.proc.append('# %s)' % callString)

    def procParametersUniax(self, smv=0.01,
                            eps_max=0.25, def_time=100.,
                            nr_incr=100):
    #az=12 für tessel666d2
        self.proc.append('''
''')

    def procSample(self):
        self.header('SAMPLE-MODELING AND MESHING')

    def proc_points(self, p_list):
        p_str = '*add_points\n'
        for n, p in enumerate(p_list):
            p_str += '%e %e %e # %i \n' % (p[0], p[1], p[2], n)
        return p_str

    def proc_nodes(self, n_list):
        n_str = '*add_nodes\n'
        for i, n in enumerate(n_list):
            n_str += '%e %e %e # %i \n' % (n[0], n[1], n[2], i)
        return n_str

    def procNodeSets(self):
        self.proc.append('''
''')

    def procNodeFixXYZ(self, name='node1_fix_all',
                       nodes=[1]):
        nodestr = ''
        for i in range(0, len(nodes)):
            nodestr = nodestr + ' %i' % nodes[i]
        self.proc.append('''
''')

    def procLoadCase(self):
        self.header('LOADCASES DEFINITION')


    def procTable(self, tablename='displacement',
                  tabletype='time',
                  tablepoints=[(0., 0.), ('def_time', 'eps_max*az')]):
        self.proc.append('''
''')
        for pts in tablepoints:
            self.proc.append('%s\n%s' % (pts[0], pts[1]))
        self.proc.append('''\n*show_table\n*table_fit\n*table_filled\n''')

    def deg2rad(self, deg):
        return (deg / 180. * math.pi)

    def rad2deg(self, rad):
        return (rad * 180. / math.pi)

    def e1(self):
        return np.array([1., 0., 0.])

    def e2(self):
        return np.array([0., 1., 0.])

    def e3(self):
        return np.array([0., 0., 1.])

    def procInitCond(self, iconds=['icond_mpie'], ic_els=['all_existing']):
        self.proc.append(self.header('INITIAL CONDITIONS'))
        self.initConds.extend(iconds)
        for ic in range(0, len(iconds)):
            self.proc.append('''
''' % (iconds[ic], ic + 1, ic_els[ic]))

    def procInitCondSV(self, label=['icond_mpie'],
                       StateVariableNumber=None,
                       StateVariableValue=None,
                       elements='all_existing',
                       new=True):
        self.initConds.append(label)
        icond = self.init_cond_state_var(label=label,
                                         StateVariableNumber=StateVariableNumber,
                                         StateVariableValue=StateVariableValue,
                                         elements=elements,
                                         new=new)
        self.proc.append(icond)

    def init_cond_state_var(self,
                            label=['icond_mpie'],
                            StateVariableNumber=None,
                            StateVariableValue=None,
                            elements='all_existing',
                            new=True):
        icond = ''
        if new:
            icond += '*new_icond\n'
        icond += '''
''' % (label, StateVariableNumber, StateVariableValue, elements)
        return icond

    def procInitCondDamask(self, T=300, # temperature (K)
                           H=[1], # homogenization
                           M=[1]  # microstructure
    ):
        self.procInitCondSV(label='icond_temperature',
                            StateVariableNumber=1,
                            StateVariableValue=T)
        for h in H:
            self.procInitCondSV(label='icond_homogenization_%i' % h,
                                StateVariableNumber=2,
                                StateVariableValue=h)
        for m in M:
            self.procInitCondSV(label='icond_microstructure_%i' % m,
                                StateVariableNumber=3,
                                StateVariableValue=m)

    def procMaterial(self, name='hypela2', els='all_existing'):
        self.proc.append('''
#+++++++++++++++++++++++++++++++++++++++++++++
# MATERIAL-DEFINITION
#+++++++++++++++++++++++++++++++++++++++++++++
model_name.Material(name='ElastoPlastic_Material-1')
model_name.materials['ElastoPlastic_Material-1'].Density(table=((1.0, ), ))
model_name.materials['ElastoPlastic_Material-1'].Elastic(table=((45000.0, 0.3), ))
model_name.materials['ElastoPlastic_Material-1'].Plastic(table=((10.0, 0.0), (15.0, 0.15), (17.5, 0.3), (18.0, 0.4)))

model_name.Material(name='ElastoPlastic_Material-2')
model_name.materials['ElastoPlastic_Material-2'].Density(table=((1.0, ), ))
model_name.materials['ElastoPlastic_Material-2'].Elastic(table=((90000.0, 0.3), ))
model_name.materials['ElastoPlastic_Material-2'].Plastic(table=((20.0, 0.0), (30.0, 0.15), (35, 0.3), (36, 0.4)))''')

    def procMaterialElast(self, name='hypela2', els='all_existing'):
        self.header('MATERIAL DATA')
        self.proc.append('''
''' % (els))

        for ic in self.initConds:
            self.proc.append('''
''' % ic)
        self.proc.append('''
''')

    def proc_copy_job(self,
                      jobname=None, # e.g. ori
                      number=None):  # e.g. nr of ori
        p = '*copy_job\n'
        if number is not None:
            jobname += '%03i' % number
        if jobname is not None:
            #jobname = 'copied_job'
            p += '*job_name %s\n' % jobname
        self.proc.append(p)

    def copy_jobs_for_oris(self):
        pass

    def write_dat(self):
        self.proc.append('''''')
        #self.proc.append('*job_write_input yes\n')
        #self.proc.append('*copy_job\n')
        #self.proc.append('*job_name postdef\n')

    def procContactIndent(self):
        self.proc.append('''
#+++++++++++++++++++++++++++++++++++++++++++++
# CONTACT DEFINITION
#+++++++++++++++++++++++++++++++++++++++++++++
# Surface interaction properties
model_name.ContactProperty('Contact Properties')
model_name.interactionProperties['Contact Properties'].TangentialBehavior(
    formulation=PENALTY, directionality=ISOTROPIC, slipRateDependency=OFF,
    pressureDependency=OFF, temperatureDependency=OFF, dependencies=0,
    table=((friction, ), ), shearStressLimit=None, maximumElasticSlip=FRACTION,
    fraction=0.005, elasticSlipStiffness=None)

# Other type of contact...
# model_name.interactionProperties['Contact Properties'].TangentialBehavior(formulation=FRICTIONLESS)
# model_name.interactionProperties['Contact Properties'].NormalBehavior(pressureOverclosure=HARD, allowSeparation=ON,
#     constraintEnforcementMethod=DEFAULT)

# Contact Definition
InstanceRoot = model_name.rootAssembly
region1 = InstanceRoot.surfaces['Surf Indenter']
region2 = InstanceRoot.instances[final_sample_name].sets['Surf Sample']
model_name.SurfaceToSurfaceContactStd(name='Interaction Indenter-Sample',
    createStepName='Initial',
    master=region1,
    slave=region2,
    sliding=FINITE,
    thickness=ON,
    interactionProperty='Contact Properties',
    adjustMethod=NONE,
    initialClearance=OMIT,
    datumAxis=None,
    clearanceRegion=None)
''')

    def procLoadCaseIndent(self):
        self.proc.append('''
#+++++++++++++++++++++++++++++++++++++++++++++
# LOADING STEP DEFINITION
#+++++++++++++++++++++++++++++++++++++++++++++
# Preliminary definitions (sets, surfaces, references points...)
indenter = model_name.parts['indenter']
v = indenter.vertices
indenter.ReferencePoint(point=v.findAt(coordinates=(0.0, 0.0, 0.0)))

# Definition of the indent step
model_name.StaticStep(name='Indent', previous='Initial',
    timePeriod=(ind_time+dwell_time+unload_time),
    maxNumInc=max_inc_indent, initialInc=ini_inc_indent, minInc=min_inc_indent_time,
    maxInc=max_inc_indent_time, nlgeom=ON)

# Generating velocity amplitude tables
model_name.TabularAmplitude(data=(
    (0.0, 0.0),
    (ind_time, -(h_indent+sep_ind_samp)),
    (ind_time+dwell_time, -(h_indent+sep_ind_samp)),
    (ind_time+dwell_time+unload_time, 0)), \
    name='Indent_Amplitude', smooth=SOLVER_DEFAULT, timeSpan=STEP)

# Defining velocities in the different steps
InstanceRoot = model_name.rootAssembly
r1 = InstanceRoot.instances['indenter-1'].referencePoints
refPoints1=(r1[2], )
region = regionToolset.Region(referencePoints=refPoints1)
model_name.DisplacementBC(name='Indent', createStepName='Indent',
    region=region, u1=0.0, u2=0.0, u3=h_indent, ur1=0.0, ur2=0.0, ur3=0.0,
    amplitude='Indent_Amplitude', fixed=OFF, distributionType=UNIFORM,
    fieldName='', localCsys=None)
''')

    def procJobParameters(self):
        self.proc.append('''
#+++++++++++++++++++++++++++++++++++++++++++++
# JOB DEFINITION
#+++++++++++++++++++++++++++++++++++++++++++++
# Defining sets

InstanceRoot = model_name.rootAssembly
r1 = InstanceRoot.instances['indenter-1'].referencePoints
refPoints1=(r1[2], )
Ref_Indenter = indenter.Set(name='Ref_Indenter', referencePoints=refPoints1)

#Defining output request
del model_name.fieldOutputRequests['F-Output-1']
del model_name.historyOutputRequests['H-Output-1']

model_name.FieldOutputRequest(name='Field output', 
    createStepName='Indent', variables=('S', 'PEEQ', 'U', 'SDV'), frequency=freq_field_output)
regionDef=model_name.rootAssembly.instances['indenter-1'].sets['Ref_Indenter']
model_name.HistoryOutputRequest(name='History output', 
    createStepName='Indent', variables=('U3', 'RF3'), frequency=2, 
    region=regionDef, sectionPoints=DEFAULT, rebar=EXCLUDE)
    
# Creating job
mdb.Job(name='Indentation_Job', model=model_name, description='', 
    type=ANALYSIS, atTime=None, waitMinutes=0, waitHours=0, queue=None, 
    memory=90, memoryUnits=PERCENTAGE, getMemoryFromAnalysis=True, 
    explicitPrecision=SINGLE, nodalOutputPrecision=SINGLE, echoPrint=OFF, 
    modelPrint=OFF, contactPrint=OFF, historyPrint=OFF, userSubroutine='', 
    scratch='', multiprocessingMode=DEFAULT, numCpus=1)

# Writing .inp
  
mdb.jobs['Indentation_Job'].writeInput(consistencyChecking=OFF)''')

    def procFriction(self):
        self.proc.append('''
''')

    def procCleanUp(self, sweepTol=0.001):
        self.proc.append('''
''')

    def procSaveModel(self, modelname='model.cae'):
        self.proc.append('''
''')

    def norm(self, vec):
        if len(vec) == 3:
            n = math.sqrt(vec[0] ** 2. + vec[1] ** 2. + vec[2] ** 2.)
        else:
            raise (ValueError)
        return n

    #  def procSetMoveTranslations(self,f,t):
    #

    def getNodeSets(self):
        '''Not used by now'''
        #self.setPostname=self.post_dummy
        #print postname
        # Read element sets
        print 'getNodeSets: Trying to open dummy', os.getcwd(), '/', postname, ' ...'
        self.p = opent16(self.post_dummy)
        if self.p == None:
            self.p = post_open(postname[0:-1] + '9') # is it *.t19 file?
            if self.p == None:
                print 'Could not open %s. run make_post' % postname;
                sys.exit(1)
        self.p.moveto(0)
        nnds = self.p.nodes();
        print  nnds

        nSets = self.p.sets()
        print nSets
        self.nodeSets = {}
        for i in range(0, nSets - 1):
            s = self.p.set(i)
            print 'Set: ', s.name, ', Type: ', s.type, '\n', s.items
            exec ('self.nodeSets[''%s'']=s.items' % s.name)
            #print 'xmin: ',xmin_nds,'\nxmax: ',xmax_nds

    def ParticleLinks(self):
        self.getNodeSets()
        #f=open('servo.proc','w')# store servo definitions in proc-file
        #self.write2servo(f=f,tie,dof=1,ret,coeff=(1, 1, 1))

    def to_file(self, dst_path=None, dst_name=None):
        '''Write  self.proc list to file'''
        if dst_name is None:
            dst_name = 'abaqus_procedure_file.py'
            #try:
        #    self.procfilename
        #except:
        #    self.procfilename=dst_name
        self.procfilename = dst_name
        if dst_path is not None:
            self.procpath = dst_path
        else:
            self.procpath = './'
        filename = os.path.join(self.procpath, self.procfilename)
        print(filename)
        self.print_commands(self.proc, filename=filename)