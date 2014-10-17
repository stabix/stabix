# coding: utf-8
import os
from msc.proc.indentation import Indentation
import msc.tools 
#from msc.proc.jobs import Jobs
#from msc.proc.base import Proc

def doit(gb_data, proc_path = './'):
    #Indentation.CODE='DAMASK' # use current CPFEM code 
    #Indentation.CODE='GENMAT' # use 'historical' CPFEM code
    Indentation.CODE = str(gb_data['simulation_code'][0])
    Indentation.MENTATVERSION = float(gb_data['fem_interface'][0]) # Version as float

    indent = Indentation(      # 
               modelname = str(gb_data['Titlegbdata'][0]), #name of model with GB identification....usw...
               #label=gb_data['GB_Number'], # informative label
               #ind_size = 1.,
               h_indent = float(gb_data['h_indent'][0]), # depth of the indent in um
               tipRadius = float(gb_data['tipRadius'][0]), # radius of the spherical indenter in um
               coneAngle = float(gb_data['coneAngle'][0]), # angle of the conical indenter in degrees
               D_sample = float(gb_data['D_sample'][0]), # diameter of the sample in um
               h_sample = float(gb_data['h_sample'][0]), # height of the sample in um
               sample_rep = float(gb_data['sample_rep'][0]), # 16, 24, 32, 48 # number of segments, dividable by 8 if used with r_center_frac!=0
               r_center_frac = float(gb_data['r_center_frac'][0]), # if >0 ==> insert a cylindrical column of brick elements in the centre to avoid collapsed elements under the indenter
               box_xfrac = float(gb_data['box_xfrac'][0]),  # size of the finer mesh box in horizontal direction
               box_zfrac = float(gb_data['box_zfrac'][0]),  # ... in vertical dimension
               box_bias_x = float(gb_data['box_bias_x'][0]),  # bias in x direction
               box_bias_z = float(gb_data['box_bias_z'][0]),  # bias in z direction
               box_bias_conv_x = float(gb_data['box_bias_conv_x'][0]),  # bias in x direction for the outer cylinder
               box_elm_nx = float(gb_data['box_elm_nx'][0]), # number of horizontal elements in box
               box_elm_nz = float(gb_data['box_elm_nz'][0]), # number of vertical elements in box
               radial_divi = float(gb_data['radial_divi'][0]),
               smv = float(gb_data['smv'][0]) # small values
               )
    msc.tools.mkdir_p(proc_path)               
    indent.to_file(dst_path = proc_path, dst_name = gb_data['Titlegbdata'][0] + '.proc')
