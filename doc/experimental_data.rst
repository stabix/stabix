Experimental data
=================
..    include:: <isonum.txt>

To use the toolbox, some experimental data are required :

- average grain orientations (Euler angles (:math:`\phi_{1}`, :math:`\Phi`, :math:`\phi_{2}`) in degrees) or intragranular misorientation (misorientation axis :math:`[uvw]` / angle :math:`\omega`);

- grains boundaries positions (optional)

- grains positions (optional)

- geometry of grain boundaries (trace angle and grain boundary inclination) (optional)

TEM experiments can provide intragranular misorientation and EBSD measurements can provide average grain orientations, grains boundaries and grains positions, and grain boundary trace angle.

EBSD measurement |rarr| TSL-OIM data preparation
------------------------------------------------

Open you .osc file in the TSL-OIM Analysis Software and before everything, set the TSL coordinates system.

Change the grain size or the minimum confident index (All data |rarr| Properties |rarr| Size).

.. code-block:: rest

   GSZ[&;5.000,//here goes the grain size as int//,0.000,0,0,8.0,1;]>0.000

Clean up your dataset (Filename |rarr| Cleanup). 

In order to decrease the number of grain boundaries segments, decrease the value of the "Grain Tolerance Angle" and increase the value of the "Minimum Grain Size".

Reference : OIM ANALYSIS 6.0 (user manual)

Reconstructed Boundary File
---------------------------

**Export "Reconstructed Boundary File" of the cleaned dataset** (All data |rarr| Export |rarr| Reconstructed Boundaries), with the following options :

- Right hand average orientation (:math:`\phi_{1}`, :math:`\Phi`, :math:`\phi_{2}`) in degrees

- Left hand average orientation (:math:`\phi_{1}`, :math:`\Phi`, :math:`\phi_{2}`) in degrees

- Trace angle (in degrees)

- (:math:`x,y`) coordinates of endpoints (in microns)

- IDs of right hand and left hand grains

N.B : Reconstructed boundary methodology is only applied to data collected on a hexagonal grid.

Example of "Reconstructed Boundary File": `MPIE_cpTi_reconstructed_boundaries_2013.txt <../../../gui_ebsd_map/EBSD_data_Examples/MPIE_cpTi_reconstructed_boundaries_2013.txt>`_

The Matlab function used to read "Reconstructed Boundary File" is: `read_oim_reconstructed_boundaries_file.m <../../../tsl_oim/read_oim_reconstructed_boundaries_file.m>`_

Grain File Type 2
-----------------

**Export "Grain File Type 2" of the cleaned dataset** (All data |rarr| Export |rarr| Grain File), with the following options :

- Integer identifying grain

- Average orientation (:math:`\phi_{1}`, :math:`\Phi`, :math:`\phi_{2}`) in degrees

- Average position (:math:`x,y`) in microns 

- An integer identifying the phase

N.B. : Export the "Grain File Type 2" in the same location as the corresponding "Reconstructed Boundary File".

Example of "Grain Gile Type 2": `MPIE_cpTi_grain_file_type2_2013.txt <../../../gui_ebsd_map/EBSD_data_Examples/MPIE_cpTi_grain_file_type2_2013.txt>`_

The Matlab function used to read "Grain Gile Type 2" is: `read_oim_grain_file_type2.m <../../../tsl_oim/read_oim_grain_file_type2.m>`_

Scan Data (.ang file)
---------------------

**Export "Scan Data (.ang file)" of the cleaned dataset** (Filename |rarr| Export |rarr| Scan Data) (optional).

This .ang file is useful for the `MTEX Toolbox <https://code.google.com/p/mtex/>`_

Errors can be introduced during files exportation from TSL
----------------------------------------------------------

- "Grain File Type 2" ==> Missing integer identifying grain
   |rarr| Solved when file is imported via the GUI.

- "Reconstructed Boundary File" |rarr| Inversion of left and right grains for a given grain boundary 
   |rarr| Cross product performed between GB vector and center of grains to check (if cross product < 0 : no inversion, and if cross product > 0 : inversion).

- "Reconstructed Boundary File" |rarr| x-axis and y-axis not corrects…
   |rarr| y coordinates is multiplied by -1 when file is imported via the GUI.

All of these issues are taken into account and corrected wautomatically hen user is loading his data via the EBSD map GUI.