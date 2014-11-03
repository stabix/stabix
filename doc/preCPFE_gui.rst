CPFE simulation preprocessing GUIs
===================================

.. include:: includes.rst


The *preCPFE* GUIs can rapidly transfer the experimental data into 
crystal plasticity finite element (CPFE) simulation input files. 
The types of input files are 

    * scripts to generate the finite element models in *MSC.Mentat* (*procedure* file format) 
      or *Abaqus* (Python script) based on the experimental data and test geometry
    * the crystallographic orientations from the experimental data sets
    * material parameter files for the subroutines that implement the constitutive model.

A parametrized visualization of the bicrystal indentation model through the GUI 
allows tuning the geometry and finite element discretization and the size of the 
sample and the indenter.

Currently the following models can be written:

    * :ref:`single_crystal_indentation` (Mentat)
    * :ref:`bicrystal_indentation` (Mentat)

.. _single_crystal_indentation:

Single crystal (SX) indentation
--------------------------------

The function used to run the preCPFE GUI for SX indentation is: `A_preCPFE_windows_indentation_setting_SX.m <https://github.com/stabix/stabix/tree/master/gui_preCPFE/A_preCPFE_windows_indentation_setting_SX.m>`_


.. figure:: ./_pictures/GUIs/SX_preproc_GUI.png
   :scale: 40 %
   :align: center
   
   *Figure 1 : Screenshot of the preCPFE GUI for the single crystal indentation*
   
Convention for the single crystal mesh
***************************************

.. figure:: ./_pictures/Schemes_SlipTransmission/SX_indentation_mesh_example.png
   :scale: 25 %
   :align: center
   
   *Figure 2 : Convention used to define the single crystal mesh.*
   
.. _bicrystal_indentation:

Bicrystal (BX) indentation
---------------------------


.. figure:: ./_pictures/GUIs/BX_preproc_GUI.png
   :scale: 40 %
   :align: center
   
   *Figure 3 : Screenshot of the preCPFE GUI for the bicrystal indentation*

Convention for the bicrystal mesh
**********************************

The function used to run the preCPFE GUI for BX indentation is: `A_preCPFE_windows_indentation_setting_BX.m <https://github.com/stabix/stabix/tree/master/gui_preCPFE/A_preCPFE_windows_indentation_setting_BX.m>`_


.. figure:: ./_pictures/Schemes_SlipTransmission/BX_indentation_mesh_example.png
   :scale: 25 %
   :align: center
   
   *Figure 4 : Convention used to define the bicrystal mesh.*
   
Loading of real three-dimensional topography of the indenter
-------------------------------------------------------------

It is possible to load a measured geometry of the indenter.

The topography has to be saved into a .txt file in the *Gwyddion ASCII* format.

The |matlab| function used to load and read Gwyddion file is: `read_gwyddion_ascii.m <https://github.com/stabix/stabix/blob/master/gwyddion/read_gwyddion_ascii.m>`_

`Visit the Gwyddion website for more information. <http://gwyddion.net/>`_

.. figure:: ./_pictures/GUIs/BX_preproc_GUI_AFM_topo_indenter.png
   :scale: 40 %
   :align: center
   
   *Figure 5 : Screenshot of the preCPFE GUI for the bicrystal indentation with loaded AFM topography of the indenter*


Python setup
-------------

For the generation of the CPFE preprocessing scripts an installation of Python 
is required together with the `numpy <http://www.scipy.org/install.html>`_ package.
To make sure that |stabix| can find the installed Python you will have to either 
put it on the system's `PATH <http://en.wikipedia.org/wiki/PATH_%28variable%29>`_ or put it's exact location in the user configuration as detailed below.


Adjusting the configuration settings and writing the finite element input files
--------------------------------------------------------------------------------

To write out the necessary files for finite element simulations it is likely that 
the user wants to adjust some settings such as the used python installation or the 
path where the files are written to. 
This can be achieved in the custom menu of the preCPFE GUIs: ``Edit CPFEM config file``.
A user specific copy of the default configuration YAML file is created and 
opened in the |matlab| editor. 
To benefit from later changes in the default settings, all
configuration parameters that are not specific to the user's setup should be deleted 
from the user's CPFE configuration file.

