# -*- coding: utf-8 -*-

#from . import base
from .base import Proc # generic procedure constructor
from .bicrystal import BicrystalIndent
from .indentation import Indentation
#from .one_element import OneElement
#from .particle import Particle
#from .uniax import Uniax

theProcFile = None

def test_run_all():
    BicrystalIndent()
    Indentation()
    #OneElement()
    #Particle()
    #Uniax()