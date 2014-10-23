Getting started
===============
..  include:: <isonum.txt>
..  |matlab| replace:: Matlab\ :sup:`TM` \

First of all, download the source code of the |matlab| toolbox.

.. figure:: ./_pictures/download.png
   :scale: 7 %
   :align: left
   :target: https://github.com/stabix/stabix

`Source code is hosted at Github. <https://github.com/stabix/stabix>`_

To have more details about the use of the toolbox, please have a look to :

.. code-block:: matlab

   README.txt

Then, run the followin |matlab| script and answer 'y' or 'yes' to add path to the |matlab| search paths :

.. code-block:: matlab

   path_management.m

Run one of these GUIs to play with the toolbox.

.. csv-table::
   :header: "Name of the GUI", "Features", "|matlab| function", "YAML config. file"
   :widths: 25, 25, 25, 25
  
   "Demo", "This main GUI is used to run other GUIs", `demo.m <https://github.com/czambaldi/stabix/blob/master/demo.m>`_
   "EBSD map GUI", "This GUI is used to analyze slip transmission across GBs for an EBSD map", `A_gui_plotmap.m <https://github.com/czambaldi/stabix/blob/master/gui_ebsd_map/A_gui_plotmap.m>`_, "config_gui_EBSDmap_default.yaml"
   "Bicrystal GUI", "This GUI is used to analyze slip transfer in a bicrystal", `A_gui_plotGB_Bicrystal.m <https://github.com/czambaldi/stabix/blob/master/gui_bicrystal/A_gui_plotGB_Bicrystal.m>`_
   "preCPFE_SX", "This GUI is used to preprocess the CPFE model for SX indentation", `A_femproc_windows_indentation_setting_SX.m <https://github.com/czambaldi/stabix/blob/master/gui_preCPFE/A_femproc_windows_indentation_setting_SX.m>`_, "config_CPFEM_default.yaml"
   "preCPFE_BX", "This GUI is used to preprocess the CPFE model for BX indentation", `A_femproc_windows_indentation_setting_BX.m <https://github.com/czambaldi/stabix/blob/master/gui_preCPFE/A_femproc_windows_indentation_setting_BX.m>`_, "config_CPFEM_default.yaml"
   
Default YAML configuration files, stored in the folder "YAML_config_files", are loaded automatically to set the GUIs:

.. code-block:: yaml

   config.yaml
   config_CPFEM_defaults.yaml
   config_CPFEM_material_defaults.yaml
   config_CPFEM_materialA_defaults.yaml
   config_CPFEM_materialB_defaults.yaml
   config_gui_EBSDmap_defaults.yaml
   config_gui_BX_defaults.yaml
   config_gui_SX_defaults.yaml
   config_mesh_BX_defaults.yaml
   config_mesh_SX_defaults.yaml

If the OpenGL rendering is not satisfying, you can modify the corresponding option in the `config.yaml` file.

`Visit the YAML website for more informations. <http://www.yaml.org/>`_

`Visit the YAML code for Matlab. <http://code.google.com/p/yamlmatlab/>`_