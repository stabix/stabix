Experimental data
=================
..  include:: <isonum.txt>
..  |matlab| replace:: Matlab\ :sup:`TM` \

To use the toolbox, some experimental data are required :

- average grain orientations (Euler angles (:math:`\phi_{1}`, :math:`\Phi`, :math:`\phi_{2}`) in degrees) or intragranular misorientation (misorientation axis :math:`[uvw]` / angle :math:`\omega`);

- grains boundaries positions (optional for the bicrystal analysis);

- grains positions (optional for the bicrystal analysis);

- geometry of grain boundaries (trace angle and grain boundary inclination) (optional).

TEM experiments can provide intragranular misorientation and EBSD measurements can provide average grain orientations, grains boundaries and grains positions, and grain boundary trace angle.

Inclination of the grain boundary can be evaluated by serial polishing or focused ion beam (FIB) sectioning, either parallel or perpendicular to the surface of the sample.

EBSD map GUI |rarr| TSL-OIM data preparation
********************************************

Open you .osc (or your .ctf) file in the TSL-OIM Analysis Software.

**Set the TSL coordinates system !**

Change data properties for the detection of grain boundaries (All data |rarr| Properties).

Clean up your dataset (Filename |rarr| Cleanup).

Reference : OIM ANALYSIS 6.0 (user manual) / `EDAX website <http://www.edax.com/Products/EBSD/OIM-Data-Analysis-Microstructure-Analysis.aspx>`_

Reconstructed Boundaries File
-----------------------------

**Export "Reconstructed Boundaries File" of the cleaned dataset** (All data |rarr| Export |rarr| Reconstructed Boundaries), with the following options defined by default :

- Right hand average orientation (:math:`\phi_{1}`, :math:`\Phi`, :math:`\phi_{2}`) in degrees

- Left hand average orientation (:math:`\phi_{1}`, :math:`\Phi`, :math:`\phi_{2}`) in degrees

- Trace angle (in degrees)

- (:math:`x,y`) coordinates of endpoints (in microns)

- IDs of right hand and left hand grains

N.B : Reconstructed boundary methodology is only applied to data collected on a hexagonal grid. It is possible to convert a square grid into an hexagonal grid in TSL-OIM software.

Example of "Reconstructed Boundary File": `MPIE_cpTi_reconstructed_boundaries_2013.txt <https://github.com/stabix/stabix/tree/master/gui_ebsd_map/EBSD_data_Examples/MPIE_cpTi_reconstructed_boundaries_2013.txt>`_

The |matlab| function used to read "Reconstructed Boundary File" is: `read_oim_reconstructed_boundaries_file.m <https://github.com/stabix/stabix/tree/master/tsl_oim/read_oim_reconstructed_boundaries_file.m>`_

If some GBs segments are missing or some wrong segments are exported, play with partition properties in the TSL-OIM software in order to export a more realistic Reconstructed Boundaries file:
    - decrease/increase "Grain Tolerance Angle"
    - decrease/increase "Minimum Grain Size"
    - decrease/increase the maximum deviation between reconstructed boundary and corresponding boundary segments.

Grain File Type 2
-----------------

**Export "Grain File Type 2" of the cleaned dataset** (All data |rarr| Export |rarr| Grain File), with the following options :

- Integer identifying grain

- Average orientation (:math:`\phi_{1}`, :math:`\Phi`, :math:`\phi_{2}`) in degrees

- Average position (:math:`x,y`) in microns 

- An integer identifying the phase

- Edge or interior grain (optional)

- Diameter of the grain in microns (optional)

N.B. : Export the "Grain File Type 2" in the same location as the corresponding "Reconstructed Boundary File".

Example of "Grain Gile Type 2": `MPIE_cpTi_grain_file_type2_2013.txt <https://github.com/stabix/stabix/tree/master/gui_ebsd_map/EBSD_data_Examples/MPIE_cpTi_grain_file_type2_2013.txt>`_

The |matlab| function used to read "Grain File Type 2" is: `read_oim_grain_file_type2.m <https://github.com/stabix/stabix/tree/master/tsl_oim/read_oim_grain_file_type2.m>`_

Scan Data (.ang file)
---------------------

**Export "Scan Data (.ang file)" of the cleaned dataset** (Filename |rarr| Export |rarr| Scan Data) (optional).

This .ang file is useful for the `MTEX Toolbox <http://mtex-toolbox.github.io/>`_

Errors introduced during files exportation from TSL
---------------------------------------------------

- "Grain File Type 2" |rarr| Missing integer identifying grain
   |rarr| Solved when file is imported via the GUI.

- "Reconstructed Boundary File" |rarr| Inversion of left and right grains for a given grain boundary 
   |rarr| Cross product performed between GB vector and center of grains to check (if cross product < 0 : no inversion, and if cross product > 0 : inversion).

- "Reconstructed Boundary File" |rarr| x-axis and y-axis not corrects…
   |rarr| y coordinates is multiplied by -1 when file is imported via the GUI.

All of these issues are taken into account and corrected automatically when user is loading his data via the EBSD map GUI.

Bicrystal GUI |rarr| YAML configuration file
********************************************

**The YAML configuration file provides a simple way to define a bicrystal.**

An example of bicrystal configuration file is given here :  `config_gui_BX_defaults.yaml <https://github.com/stabix/stabix/tree/master/YAML_config_files/config_gui_BX_defaults.yaml>`_

Copy this example file and modify it with your data. Be careful to put a space after the comma in a list (e.g. [x, y, z]).

Don't change fieldnames and don't round Euler angles. Euler angles are given in degrees.

Load your YAML bicrystal configuration file via the menu in the bicrystal GUI.

`Visit the YAML website for more informations. <http://www.yaml.org/>`_

`Visit the YAML code for Matlab. <http://code.google.com/p/yamlmatlab/>`_

Convention for bicrystal EBSD/indentation experiments
*****************************************************

.. figure:: ./_pictures/Schemes_SlipTransmission/Bicrystal_conventions.png
   :scale: 50 %
   :align: center
   
   *Figure 1 : Geometrical convention of a bicrystal.*