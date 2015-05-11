# coding: utf-8
import os
#execfile('d:\zambaldi\python\_startup.py')

from msc.proc.bicrystal import BicrystalIndent
import msc.tools

def doit(gb_data, proc_path='./'):
    #BicrystalIndent.CODE='DAMASK' # use current CPFEM code 
    #BicrystalIndent.CODE='GENMAT' # use 'historical' CPFEM code
    BicrystalIndent.CODE = str(gb_data['simulation_code'][0])
    #BicrystalIndent.MENTATVERSION = 2013.1 # Version as float
    BicrystalIndent.MENTATVERSION = float(gb_data['fem_interface'][0]) # Version as float
    

    indent = BicrystalIndent(#
                             modelname = str(gb_data['Titlegbdata'][0]), #name of model with GB identification....usw...
                             #label = gb_data['GB_Number'], # informative label
                             #gbn = None, # grain boundary normal in xyz - Useless if trace angle + inclination given
                             trace_ang = float(gb_data['GB_Trace_Angle'][0]), # in degrees 
                             inclination = float(gb_data['GB_Inclination'][0]), # in degrees (from 0 to 180)
                             d = float(gb_data['ind_dist'][0]), # distance of indent from GB in microns
                             ind_size = 1.,
                             h_indent = float(gb_data['h_indent'][0]), # depth of the indent in microns
                             tipRadius = float(gb_data['tipRadius'][0]), # radius of the spherical indenter in microns
                             coneAngle = float(gb_data['coneAngle'][0]), # angle of the conical indenter in degrees
                             wid = float(gb_data['w_sample'][0]), # width of the sample
                             hei = float(gb_data['h_sample'][0]), # height of the sample
                             len = float(gb_data['len_sample'][0]), # length of the sample
                             len_trace = 1.  # length of the GB trace in um
                             box_elm_nx = float(gb_data['box_elm_nx'][0]), # number of elements in x direction
                             box_elm_nz = float(gb_data['box_elm_nz'][0]), # number of elements in z direction
                             box_elm_ny1 = float(gb_data['box_elm_ny1'][0]), # number of elements in y direction in the grain B
                             box_elm_ny2_fac = float(gb_data['box_elm_ny2_fac'][0]), # number of elements in y direction in the middle part
                             box_elm_ny3 = float(gb_data['box_elm_ny3'][0]), # number of elements in y direction in the grain A
                             box_bias_x = float(gb_data['box_bias_x'][0]), # bias in the x direction
                             box_bias_z = float(gb_data['box_bias_z'][0]), # bias in the z direction
                             box_bias_y1 = float(gb_data['box_bias_y1'][0]), # bias in y direction in the grain B
                             box_bias_y2 = float(gb_data['box_bias_y2'][0]), # bias in y direction in the middle part
                             box_bias_y3 = float(gb_data['box_bias_y3'][0]), # bias in y direction in the grain A
                             smv = float(gb_data['smv'][0]), # small values
                             #lvl = float(gb_data['mesh_quality_lvl'][0]), # mesh quality level
                             scratchTest =  float(gb_data['scratchTest'][0]), # boolean variable (0 in not a scratch test and 1 if scratch test)
                             scratchLength =  float(gb_data['scratchLength'][0]), # scratch length in microns
                             scratchDirection =  float(gb_data['scratchDirection'][0]), # scratch direction in degrees (0 along x-axis and 90 along y axis, from 0 to 360)
    )
    msc.tools.mkdir_p(proc_path)
    indent.to_file(dst_path=proc_path, dst_name=gb_data['Titlegbdata'][0] + '.proc')
