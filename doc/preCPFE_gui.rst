CPFE SX and BX Indentation models
=================================

..  |matlab| replace:: Matlab\ :sup:`TM` \

The preCPFE GUI has been created to enable rapid transfer of experimental data into simulation input files,
so that a statistically significant number of indents can be assessed.

A parametrized visualization of the bicrystal indentation model through the GUI allows tuning the geometry and finite element discretization and the size of the sample and the indenter.

The |matlab| function used to run the preCPFE GUI for SX indentation is: `A_preCPFE_windows_indentation_setting_SX.m <https://github.com/stabix/stabix/tree/master/gui_preCPFE/A_preCPFE_windows_indentation_setting_SX.m>`_

The |matlab| function used to run the preCPFE GUI for BX indentation is: `A_preCPFE_windows_indentation_setting_BX.m <https://github.com/stabix/stabix/tree/master/gui_preCPFE/A_preCPFE_windows_indentation_setting_BX.m>`_

This includes:

* :ref:`single_crystal_indentation`
* :ref:`bicrystal_indentation`

.. _single_crystal_indentation:

Single crystal indentation
--------------------------

..    include:: <isonum.txt>
.. figure:: ./_pictures/GUIs/SX_preproc_GUI.png
   :scale: 40 %
   :align: center
   
   *Figure 1 : Screenshot of the preCPFE GUI for the single crystal indentation*
   
Convention for the single crystal mesh
**************************************

.. figure:: ./_pictures/Schemes_SlipTransmission/SX_indentation_mesh_example.png
   :scale: 25 %
   :align: center
   
   *Figure 2 : Convention used to define the single crystal mesh.*
   
.. _bicrystal_indentation:

Bicrystal indentation
---------------------

..    include:: <isonum.txt>
.. figure:: ./_pictures/GUIs/BX_preproc_GUI.png
   :scale: 40 %
   :align: center
   
   *Figure 3 : Screenshot of the preCPFE GUI for the bicrystal indentation*

Convention for the bicrystal mesh
*********************************

.. figure:: ./_pictures/Schemes_SlipTransmission/BX_indentation_mesh_example.png
   :scale: 25 %
   :align: center
   
   *Figure 4 : Convention used to define the bicrystal mesh.*
   
Loading of real three-dimensional topography of the indenter
------------------------------------------------------------

It is possible to load real three-dimensional topography of the indenter.

The topography has to be saved into a .txt file with a Gwyddion format.

The |matlab| function used to load and read Gwyddion file is: `read_gwyddion_ascii.m <https://github.com/stabix/stabix/blob/master/gwyddion/read_gwyddion_ascii.m>`_

`Visit the Gwyddion website for more information. <http://gwyddion.net/>`_

..    include:: <isonum.txt>
.. figure:: ./_pictures/GUIs/BX_preproc_GUI_AFM_topo_indenter.png
   :scale: 40 %
   :align: center
   
   *Figure 5 : Screenshot of the preCPFE GUI for the bicrystal indentation with loaded AFM topography of the indenter*

Adjusting the configuration settings and writing the finite element input files
---------------------------------------------------------------------------------

To write out the necessary files for finite element simulations it is likely that 
the user wants to adjust some settings such as the used python installation or the 
path where the files are written to.

This can be achieved in the custom menu of the preCPFE GUIs: ``Edit CPFEM config file``.

This will create a copy of the default configuration YAML file and open this copy
in the Matlab editor.

To benefit from later changes in the default settings, the user should delete all
configuration parameters that he does not intend to change.