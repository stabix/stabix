# Python script used to generate a material configuration file for DAMASK
# http://damask.mpie.de/

import re

class Material():
    '''
       Reads, manipulates and writes material.config files
       See end of file for example of usage
    '''
    __slots__ = ['data']

    def __init__(self):
        self.parts = [
            'homogenization',
            'microstructure',
            'crystallite',
            'phase',
            'texture',
        ]                                       # ordered (!) list of parts
        self.data = { \
            'homogenization': {'__order__': []},
            'microstructure': {'__order__': []},
            'crystallite': {'__order__': []},
            'phase': {'__order__': []},
            'texture': {'__order__': []},
        }

    def __repr__(self):
        me = []
        for part in self.parts:
            print 'doing', part
            me += ['', '#####################', '<%s>' % part, '#####################', ]
            for section in self.data[part]['__order__']:
                section_number = self.data[part]['__order__'].index(section)
                if section_number > 0 and section_number < len(self.data[part]['__order__']):
                    pass#me+=['\n##-----------------------------------------------------------------##\n']
                me += ['', '[%s]' % (section), '', ]
                #me += ['','[%s__No_%i] %s'%(section,section_number+1,'-'*max(0,21-len(section))),'',]
                for key in self.data[part][section]['__order__']:
                    if key.startswith('(') and key.endswith(')'):                       # multiple (key)
                        me += ['%s\t%s' % (key, ' '.join(values)) for values in self.data[part][section][key]]
                    else:                                                               # plain key
                        me += ['%s\t%s' % (key, ' '.join(map(str, self.data[part][section][key])))]

        return '\n'.join(me)

    def parse_data(self, part=None, sections=[], content=None):

        re_part = re.compile(r'^<(.+)>$')                     # pattern for part
        re_sec = re.compile(r'^\[(.+)\]$')                   # pattern for section

        name_section = ''
        idx_section = 0
        active = False

        for line in content:
            line = line.split('#')[0].strip()                   # kill comments and extra whitespace
            line = line.split('#')[0].strip()                   # kill comments and extra whitespace
            if line:                                            # content survives...
                match_part = re_part.match(line)
                if match_part:                                    # found <part> separator
                    active = (match_part.group(1) == part)          # only active in <part>
                    continue
                if active:
                    match_sec = re_sec.match(line)
                    if match_sec:                                   # found [section]
                        name_section = match_sec.group(1)             # remember name ...
                        if '__order__' not in self.data[part]: self.data[part]['__order__'] = []
                        self.data[part]['__order__'].append(name_section)  # ... and position
                        self.data[part][name_section] = {'__order__': []}
                        continue

                    if sections == [] or name_section in sections:  # respect subset
                        items = line.split()
                        if items[0] not in self.data[part][name_section]:         # first encounter of key?
                            self.data[part][name_section][items[0]] = []            # create item
                            self.data[part][name_section]['__order__'].append(items[0])
                        if items[0].startswith('(') and items[0].endswith(')'):   # multiple "(key)"
                            self.data[part][name_section][items[0]].append(items[1:])
                        else:                                                     # plain key
                            self.data[part][name_section][items[0]] = items[1:]

    def read(self, file=None):
        f = open(file, 'r')
        c = f.readlines()
        f.close()
        for p in self.parts:
            self.parse_data(part=p, content=c)

    def write(self, file='%s.MaterialConfig', overwrite=False):
        import os

        i = 0
        saveFile = file
        while not overwrite and os.path.exists(saveFile):
            i += 1
            saveFile = file + '_%i' % i

        print('Writing material data to file %s' % saveFile)
        f = open(saveFile, 'w')
        f.write(str(self) + '\n')                                          #newline at end
        f.close()
        return saveFile

    def add_section(self, part=None, section=None, object=None, merge=False):
        '''adding/updating'''

        if part not in self.parts: raise Exception('invalid part %s' % part)

        if type(object) is dict:
            data = object
        else:
            data = object.data()

        if section not in self.data[part]: self.data[part]['__order__'] += [section]
        if section in self.data[part] and merge:
            for existing in self.data[part][section]['__order__']:                        # replace existing
                if existing in data['__order__']:
                    if existing.startswith('(') and existing.endswith(')'):                   # multiple (key)
                        self.data[part][section][existing] += data[
                            existing]                    # add new multiple entries to existing ones
                    else:                                                                     # regular key
                        self.data[part][section][existing] = data[existing]                     # plain replice
            for new in data['__order__']:                                                 # merge new content
                if new not in self.data[part][section]['__order__']:
                    self.data[part][section][new] = data[new]
                    self.data[part][section]['__order__'] += [new]
        else:
            self.data[part][section] = data

class Section():
    def __init__(self, data={'__order__': []}, part=''):
        classes = {
            'homogenization': Homogenization,
            'microstructure': Microstructure,
            'crystallite': Crystallite,
            'phase': Phase,
            'texture': Texture,
        }
        self.parameters = {}
        #for key in data:
        #    if type(data[key]) is not list:
        #       self.parameters[key] = [data[key]]
        #   else:
        #       self.parameters[key] = data[key]

        if '__order__' not in self.parameters:
            self.parameters['__order__'] = self.parameters.keys()
        if part.lower() in classes:
            self.__class__ = classes[part.lower()]
            self.__init__(data)

    def add_multiKey(self, key, data):
        multiKey = '(%s)' % key
        if multiKey not in self.parameters: self.parameters[multiKey] = []
        if multiKey not in self.parameters['__order__']: self.parameters['__order__'] += [multiKey]
        if type(data) == list:
            self.parameters[multiKey] += [[item] for item in data]
        else:
            self.parameters[multiKey] += [[data]]

    def add_key(self, key, data):
        if type(data) == list:
            self.parameters[key] = [item for item in data]
        else:
            self.parameters[key] = [data]
        if key not in self.parameters['__order__']: self.parameters['__order__'] += [key]

    def data(self):
        return self.parameters

class Homogenization(Section):
    def __init__(self, data={'__order__': []}):
        Section.__init__(self, data)

class Crystallite(Section):
    def __init__(self, data={'__order__': []}):
        Section.__init__(self, data)

class Phase(Section):
    def __init__(self, data={'__order__': []}):
        Section.__init__(self, data)

class Microstructure(Section):
    def __init__(self, data={'__order__': []}):
        Section.__init__(self, data)

    def add_constituent(self, data, ):      # dict of phase, texture, and fraction

        theData = ''
        for property in ['phase', 'texture', 'fraction']:
            if property not in data.keys():   # suboptimal!!
                print 'Croak!'
            else:
                theData += '%s %s\t' % (property, data[property])
        self.add_multiKey('constituent', theData)

class Texture(Section):
    def __init__(self, data={'__order__': []}):
        Section.__init__(self, data)

    def add_component(self, theType, properties):

        if 'scatter' not in map(str.lower, properties.keys()):
            scatter = 0.0
        else:
            scatter = properties['scatter']
        if 'fraction' not in map(str.lower, properties.keys()):
            fraction = 1.0
        else:
            fraction = properties['fraction']

        multiKey = theType.lower()

        if multiKey == 'gauss':
            self.add_multiKey(multiKey, 'phi1 %g\tPhi %g\tphi2 %g\tscatter %g\tfraction %g' % (
                properties['eulers'][0],
                properties['eulers'][1],
                properties['eulers'][2],
                scatter,
                fraction,
            )
            )

        if multiKey == 'fiber':
            self.add_multiKey(multiKey, 'alpha1 %g\talpha2 %g\tbeta1 %g\tbeta2 %g\tscatter %g\tfraction %g' % (
                properties['eulers'][0],
                properties['eulers'][1],
                properties['eulers'][2],
                properties['eulers'][3],
                scatter,
                fraction,
            )
            )

def mat_config(gb_data, proc_path='./'):
    '''Usage example of the material.config writer'''
    mat = Material()

    #--- HOMOGENIZATION
    h = Homogenization()
    try:
        h.add_key('type', 'isostrain')
    except:
        print('No Homogenization type given')
        pass
    try:
        h.add_key('Ngrains', 1)
    except:
        print('No Homogenization parameter given')
        pass
    mat.add_section('homogenization', 'Taylor1', h)

    #--- MICROSTRUCTURE
    active_data = str(gb_data['active_data'][0])
    number_phase = gb_data['number_phase']
    if active_data in ('SX', 'BX'):
        mA = Microstructure()
        mA.add_key('crystallite', '1')
        mA.add_constituent({'phase': 1, 'texture': 1, 'fraction': 1})
        mat.add_section('microstructure', 'GrainA', mA)
    
    if active_data in ('BX'):
        mB = Microstructure()
        mB.add_key('crystallite', '1')
        if number_phase == 1:
            mB.add_constituent({'phase': 1, 'texture': 2, 'fraction': 1})
        else:
            mB.add_constituent({'phase': 2, 'texture': 2, 'fraction': 1})
        mat.add_section('microstructure', 'GrainB', mB)

    #--- CRYSTALLITE
    c = Crystallite()
    try:
        c.add_multiKey('output', ['phase',
                              'texture',
                              'volume',
                              'orientation', # quaternion
                              'eulerangles', # orientation as Bunge triple
                              'grainrotation',
                              'f', # deformation gradient tensor; synonyms: "defgrad"
                              'fe', # elastic deformation gradient tensor
                              'fp', # plastic deformation gradient tensor
                              'e', # total strain as Green-Lagrange tensor
                              'ee', # elastic strain as Green-Lagrange tensor
                              'p', # first Piola-Kichhoff stress tensor; synonyms: "firstpiola", "1stpiola"
                              's', # second Piola-Kichhoff stress tensor; synonyms: "tstar", "secondpiola", "2ndpiola"
                              'lp', # plastic velocity gradient tensor
                              'elasmatrix', # elastic stiffness matrix
    ])
    except:
        print('No Crystallite Output defined')
        pass
    mat.add_section('crystallite', 'essential_output', c)
    #mat.add_section('crystallite', 'all', c)

    #---PHASE
    pA = Phase()
    phase_labelA = str(gb_data['Phase_A'][0])
    mat.add_section('phase', phase_labelA, pA)
    try:
        pA.add_key('elasticity', str(gb_data['Phase1_elasticity'][0]))
    except:
        print('No Elasticity defined for phase A')
        pass
    try:
        pA.add_key('plasticity', str(gb_data['Phase1_plasticity'][0]))
    except:
        print('No Plasticity defined for phase A')
        pass
    try: 
        pA.add_multiKey('output', [str(gb_data['Phase1_output1'][0]),
                              str(gb_data['Phase1_output2'][0]),
                              str(gb_data['Phase1_output3'][0]),
                              str(gb_data['Phase1_output4'][0]),
                              str(gb_data['Phase1_output5'][0]),
                              str(gb_data['Phase1_output6'][0]),
                              str(gb_data['Phase1_output7'][0]),
                              str(gb_data['Phase1_output8'][0]),
                              str(gb_data['Phase1_output9'][0]),
                              str(gb_data['Phase1_output10'][0])])
    except:
        print('No Phase Output defined for phase A')
        pass
    try:
        pA.add_key('lattice_structure', str(gb_data['Phase1_lattice_structure'][0]))
    except:
        print('No Lattice Structure defined for phase A')
        pass
    try:
        pA.add_key('covera_ratio', (gb_data['ca_ratio_A'][0][0]))
    except:
        print('No Lattice Parameter (c/a ratio) defined for phase A')
        pass
    try:
        pA.add_key('c11', (gb_data['Phase1_c11'][0][0]))
    except:
        print('No c11 elastic constant defined for phase A')
        pass
    try:
        pA.add_key('c12', (gb_data['Phase1_c12'][0][0]))
    except:
        print('No c12 elastic constant defined for phase A')
        pass
    try:
        pA.add_key('c13', (gb_data['Phase1_c13'][0][0]))
    except:
        print('No c13 elastic constant defined for phase A')
        pass
    try:
        pA.add_key('c33', (gb_data['Phase1_c33'][0][0]))
    except:
        print('No c33 elastic constant defined for phase A')
        pass
    try:
        pA.add_key('c44', (gb_data['Phase1_c44'][0][0]))
    except:
        print('No c44 elastic constant defined for phase A')
        pass
    try:
        pA.add_key('c66', (gb_data['Phase1_c66'][0][0]))
    except:
        print('No c66 elastic constant defined for phase A')
        pass
    try:
        pA.add_key('nslip', [gb_data['Phase1_nslip'][0]])
    except:
        print('No nslip defined for phase A')
        pass
    try:
        pA.add_key('gdot0_slip', (gb_data['Phase1_gdot0_slip'][0][0]))
    except:
        print('No gdot0_slip defined for phase A')
        pass
    try:
        pA.add_key('n_slip', (gb_data['Phase1_n_slip'][0][0]))
    except:
        print('No n_slip defined for phase A')
        pass
    try:
        pA.add_key('tau0_slip', [gb_data['Phase1_tau0_slip'][0]])
    except:
        print('No tau0_slip defined for phase A')
        pass
    try:
        pA.add_key('tausat_slip', [gb_data['Phase1_tausat_slip'][0]])
    except:
        print('No tausat_slip defined for phase A')
        pass
    try:
        pA.add_key('a_slip', (gb_data['Phase1_a_slip'][0][0]))
    except:
        print('No a_slip defined for phase A')
        pass
    try:
        pA.add_key('ntwin', [gb_data['Phase1_ntwin'][0]])
    except:
        print('No ntwin defined for phase A')
        pass
    try:
        pA.add_key('gdot0_twin', (gb_data['Phase1_gdot0_twin'][0][0]))
    except:
        print('No gdot0_twin defined for phase A')
        pass
    try:
        pA.add_key('n_twin', (gb_data['Phase1_n_twin'][0][0]))
    except:
        print('No n_twin defined for phase A')
        pass
    try:
        pA.add_key('tau0_twin', (gb_data['Phase1_tau0_twin'][0][0]))
    except:
        print('No tau0_twin defined for phase A')
        pass
    try:
        pA.add_key('s_pr', (gb_data['Phase1_s_pr'][0][0]))
    except:
        print('No s_pr defined for phase A')
        pass
    try:
        pA.add_key('twin_b', (gb_data['Phase1_twin_b'][0][0]))
    except:
        print('No twin_b defined for phase A')
        pass
    try:
        pA.add_key('twin_c', (gb_data['Phase1_twin_c'][0][0]))
    except:
        print('No twin_c defined for phase A')
        pass
    try:
        pA.add_key('twin_d', (gb_data['Phase1_twin_d'][0][0]))
    except:
        print('No twin_d defined for phase A')
        pass
    try:
        pA.add_key('twin_e', (gb_data['Phase1_twin_e'][0][0]))
    except:
        print('No twin_e defined for phase A')
        pass
    try:
        pA.add_key('h0_slipslip', (gb_data['Phase1_h0_slipslip'][0][0]))
    except:
        print('No h0_slipslip defined for phase A')
        pass
    try:
        pA.add_key('h0_sliptwin', (gb_data['Phase1_h0_sliptwin'][0][0]))
    except:
        print('No h0_sliptwin defined for phase A')
        pass
    try:
        pA.add_key('h0_twinslip', (gb_data['Phase1_h0_twinslip'][0][0]))
    except:
        print('No h0_twinslip defined for phase A')
        pass
    try:
        pA.add_key('h0_twintwin', (gb_data['Phase1_h0_twintwin'][0][0]))
    except:
        print('No h0_twintwin defined for phase A')
        pass
    try:
        pA.add_key('atol_resistance', (gb_data['Phase1_atol_resistance'][0][0]))
    except:
        print('No atol_resistance defined for phase A')
        pass
    try:
        pA.add_key('atol_shear', (gb_data['Phase1_atol_shear'][0][0]))
    except:
        print('No atol_shear defined for phase A')
        pass
    try:
        pA.add_key('atol_twinfrac', (gb_data['Phase1_atol_shear'][0][0]))
    except:
        print('No atol_twinfrac defined for phase A')
        pass
    try:
        pA.add_key('interaction_slipslip', [gb_data['Phase1_interaction_slipslip'][0]])
    except:
        print('No interaction_slipslip defined for phase A')
        pass
    try:
        pA.add_key('interaction_sliptwin', [gb_data['Phase1_interaction_sliptwin'][0]])
    except:
        print('No interaction_sliptwin defined for phase A')
        pass
    try:
        pA.add_key('interaction_twinslip', [gb_data['Phase1_interaction_twinslip'][0]])
    except:
        print('No interaction_twinslip defined for phase A')
        pass
    try:
        pA.add_key('interaction_twintwin', [gb_data['Phase1_interaction_twintwin'][0]])
    except:
        print('No interaction_twintwin defined for phase A')
        pass

    number_phase = gb_data['number_phase']
    pB = Phase()
    if number_phase == 2:
        phase_labelB = str(gb_data['Phase_B'][0])
        mat.add_section('phase', phase_labelB, pB)
        try:
            pB.add_key('elasticity', str(gb_data['Phase2_elasticity'][0]))
        except:
            print('No Elasticity defined for phase B')
            pass
        try:
            pB.add_key('plasticity', str(gb_data['Phase2_plasticity'][0]))
        except:
            print('No Plasticity defined for phase B')
            pass
        try:
            pB.add_multiKey('output', [str(gb_data['Phase2_output1'][0]),
                                  str(gb_data['Phase2_output2'][0]),
                                  str(gb_data['Phase2_output3'][0]),
                                  str(gb_data['Phase2_output4'][0]),
                                  str(gb_data['Phase2_output5'][0]),
                                  str(gb_data['Phase2_output6'][0]),
                                  str(gb_data['Phase2_output7'][0]),
                                  str(gb_data['Phase2_output8'][0]),
                                  str(gb_data['Phase2_output9'][0]),
                                  str(gb_data['Phase2_output10'][0])
        ])
        except:
            print('No Phase Output defined for phase B')
            pass
        try:
            pB.add_key('lattice_structure', str(gb_data['Phase2_lattice_structure'][0]))
        except:
            print('No Lattice Structure defined for phase B')
            pass
        try:
            pB.add_key('covera_ratio', (gb_data['ca_ratio_B'][0][0]))
        except:
            print('No Lattice Parameter (c/a ratio) defined for phase B')
            pass
        try:
            pB.add_key('c11', (gb_data['Phase2_c11'][0][0]))
        except:
            print('No c11 elastic constant defined for phase B')
            pass
        try:
            pB.add_key('c12', (gb_data['Phase2_c12'][0][0]))
        except:
            print('No c12 elastic constant defined for phase B')
            pass
        try:
            pB.add_key('c13', (gb_data['Phase2_c13'][0][0]))
        except:
            print('No c13 elastic constant defined for phase B')
            pass
        try:
            pB.add_key('c33', (gb_data['Phase2_c33'][0][0]))
        except:
            print('No c33 elastic constant defined for phase B')
            pass
        try:
            pB.add_key('c44', (gb_data['Phase2_c44'][0][0]))
        except:
            print('No c44 elastic constant defined for phase B')
            pass
        try:
            pB.add_key('c66', (gb_data['Phase2_c66'][0][0]))
        except:
            print('No c66 elastic constant defined for phase B')
            pass
        try:
            pB.add_key('nslip', [gb_data['Phase2_nslip'][0]])
        except:
            print('No nslip defined for phase B')
            pass
        try:
            pB.add_key('gdot0_slip', (gb_data['Phase2_gdot0_slip'][0][0]))
        except:
            print('No gdot0_slip defined for phase B')
            pass
        try:
            pB.add_key('n_slip', (gb_data['Phase2_n_slip'][0][0]))
        except:
            print('No n_slip defined for phase B')
            pass
        try:
            pB.add_key('tau0_slip', [gb_data['Phase2_tau0_slip'][0]])
        except:
            print('No tau0_slip defined for phase B')
            pass
        try:
            pB.add_key('tausat_slip', [gb_data['Phase2_tausat_slip'][0]])
        except:
            print('No tausat_slip defined for phase B')
            pass
        try:
            pB.add_key('a_slip', (gb_data['Phase2_a_slip'][0][0]))
        except:
            print('No a_slip defined for phase B')
            pass
        try:
            pB.add_key('ntwin', [gb_data['Phase2_ntwin'][0]])
        except:
            print('No ntwin defined for phase B')
            pass
        try:
            pB.add_key('gdot0_twin', (gb_data['Phase2_gdot0_twin'][0][0]))
        except:
            print('No gdot0_twin defined for phase B')
            pass
        try:
            pB.add_key('n_twin', (gb_data['Phase2_n_twin'][0][0]))
        except:
            print('No n_twin defined for phase B')
            pass
        try:
            pB.add_key('tau0_twin', (gb_data['Phase2_tau0_twin'][0][0]))
        except:
            print('No tau0_twin defined for phase B')
            pass
        try:
            pB.add_key('s_pr', (gb_data['Phase2_s_pr'][0][0]))
        except:
            print('No s_pr defined for phase B')
            pass
        try:
            pB.add_key('twin_b', (gb_data['Phase2_twin_b'][0][0]))
        except:
            print('No twin_b defined for phase B')
            pass
        try:
            pB.add_key('twin_c', (gb_data['Phase2_twin_c'][0][0]))
        except:
            print('No twin_c defined for phase B')
            pass
        try:
            pB.add_key('twin_d', (gb_data['Phase2_twin_d'][0][0]))
        except:
            print('No twin_d defined for phase B')
            pass
        try:
            pB.add_key('twin_e', (gb_data['Phase2_twin_e'][0][0]))
        except:
            print('No twin_e defined for phase B')
            pass
        try:
            pB.add_key('h0_slipslip', (gb_data['Phase2_h0_slipslip'][0][0]))
        except:
            print('No h0_slipslip defined for phase B')
            pass
        try:
            pB.add_key('h0_sliptwin', (gb_data['Phase2_h0_sliptwin'][0][0]))
        except:
            print('No h0_sliptwin defined for phase B')
            pass
        try:
            pB.add_key('h0_twinslip', (gb_data['Phase2_h0_twinslip'][0][0]))
        except:
            print('No h0_twinslip defined for phase B')
            pass
        try:
            pB.add_key('h0_twintwin', (gb_data['Phase2_h0_twintwin'][0][0]))
        except:
            print('No h0_twintwin defined for phase B')
            pass
        try:
            pB.add_key('atol_resistance', (gb_data['Phase2_atol_resistance'][0][0]))
        except:
            print('No atol_resistance defined for phase B')
            pass
        try:
            pB.add_key('atol_shear', (gb_data['Phase2_atol_shear'][0][0]))
        except:
            print('No atol_shear defined for phase B')
            pass
        try:
            pB.add_key('atol_twinfrac', (gb_data['Phase2_atol_shear'][0][0]))
        except:
            print('No atol_twinfrac defined for phase B')
            pass
        try:
            pB.add_key('interaction_slipslip', [gb_data['Phase2_interaction_slipslip'][0]])
        except:
            print('No interaction_slipslip defined for phase B')
            pass
        try:
            pB.add_key('interaction_sliptwin', [gb_data['Phase2_interaction_sliptwin'][0]])
        except:
            print('No interaction_sliptwin defined for phase B')
            pass
        try:
            pB.add_key('interaction_twinslip', [gb_data['Phase2_interaction_twinslip'][0]])
        except:
            print('No interaction_twinslip defined for phase B')
            pass
        try:
            pB.add_key('interaction_twintwin', [gb_data['Phase2_interaction_twintwin'][0]])
        except:
            print('No interaction_twintwin defined for phase B')
            pass

    #--- TEXTURE
    active_data = str(gb_data['active_data'][0])
    
    if active_data in ('SX','BX'):
        eulerA = gb_data['eulerA']
        t1 = Texture()
        t1.add_component('gauss', {'eulers': [eulerA[0][0], eulerA[0][1], eulerA[0][2]], 'scatter': 0, 'fraction': 1})
        mat.add_section('texture', 'GrainA', t1)

    if active_data in ('BX'):
        eulerB = gb_data['eulerB']
        t2 = Texture()
        t2.add_component('gauss', {'eulers': [eulerB[0][0], eulerB[0][1], eulerB[0][2]], 'scatter': 0, 'fraction': 1})
        mat.add_section('texture', 'GrainB', t2)

    #print mat
    #gbtitle=str(gb_data['titlegbdata'][0])
    # mat.write(file='%s.MaterialConfig'%gbtitle)
    mat.write(file='material.config')

    #mat.write(file='material.config',overwrite=True)
    #return mat
    
    