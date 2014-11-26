Getting started
===============

.. include:: includes.rst

First of all, download the source code of the |matlab| toolbox.

.. figure:: ./_pictures/download.png
   :scale: 20 %
   :align: left
   :target: https://github.com/stabix/stabix

`Source code is hosted at Github. <https://github.com/stabix/stabix>`_

.. figure:: ./_pictures/normal_folder.ico
   :scale: 15 %
   :align: left
   :target: https://github.com/stabix/stabix/archive/master.zip
   
`Download source code as a .zip file <https://github.com/stabix/stabix/archive/master.zip>`_.

To have more details about the use of the toolbox, please have a look to :

.. code-block:: matlab

   README.txt

Then, run the following |matlab| script and answer 'y' or 'yes' to add path to the |matlab| search paths :

.. code-block:: matlab

   path_management.m

Run one of these GUIs to play with the toolbox.

.. csv-table::
   :header: "Name of the GUI", "Features", "|matlab| function", "YAML config. file"
   :widths: 25, 25, 25, 25
  
   "`Demo <MainMenu.png>`_", "Start and run other GUIs.", `demo.m <https://github.com/stabix/stabix/blob/master/demo.m>`_
   "`EBSD map GUI <EBSDmap.png>`_", "Analysis of slip transmission across GBs for an EBSD map.", `A_gui_plotmap.m <https://github.com/stabix/stabix/blob/master/gui_ebsd_map/A_gui_plotmap.m>`_, "config_gui_EBSDmap_default.yaml"
   "`Bicrystal GUI <BX.png>`_", "Analysis of slip transfer in a bicrystal.", `A_gui_plotGB_Bicrystal.m <https://github.com/stabix/stabix/blob/master/gui_bicrystal/A_gui_plotGB_Bicrystal.m>`_
   "`preCPFE_SX <preCPFE_GUI_SX.png>`_", "Preprocess of CPFE model for SX indentation.", `A_preCPFE_windows_indentation_setting_SX.m <https://github.com/stabix/stabix/blob/master/gui_preCPFE/A_preCPFE_windows_indentation_setting_SX.m>`_, "config_CPFEM_default.yaml"
   "`preCPFE_BX <preCPFE_GUI_BX.png>`_", "Preprocess of CPFE model for BX indentation.", `A_preCPFE_windows_indentation_setting_BX.m <https://github.com/stabix/stabix/blob/master/gui_preCPFE/A_preCPFE_windows_indentation_setting_BX.m>`_, "config_CPFEM_default.yaml"
   "`GBinc <gui_gb_inc.png>`_", "Calculation of grain boundaries inclination.", `A_gui_gbinc.m <https://github.com/stabix/stabix/blob/master/gui_gbinc/A_gui_gbinc.m>`_
   
Default YAML configuration files, stored in the folder `YAML_config_files <https://github.com/stabix/stabix/tree/master/YAML_config_files>`_, are loaded automatically to set the GUIs:

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
   
You have to set your own YAML configuration files, by following instructions given in this `README <https://github.com/stabix/stabix/blob/master/YAML_config_files/README.txt>`_.

If the OpenGL rendering is not satisfying, you can modify the corresponding option in the `config.yaml <https://github.com/stabix/stabix/blob/master/YAML_config_files/config.yaml>`_ file.

`Visit the YAML website for more informations <http://www.yaml.org/>`_.

`Visit the YAML code for Matlab <http://code.google.com/p/yamlmatlab/>`_.

`Visit the Matlab page about OpenGL rendering <http://fr.mathworks.com/help/matlab/ref/opengl.html?refresh=true>`_.