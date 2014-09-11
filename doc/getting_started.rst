Getting started
===============
..  include:: <isonum.txt>
..  |matlab| replace:: Matlab\ :sup:`TM` \

First of all, download the source code of the |matlab| toolbox.

`Source code is hosted at Github. <https://github.com/czambaldi/stabix>`_

Then, run the |matlab| script `path_management.m <../../../path_management.m>`_, in order to set search paths for Matlab.

Finally, run one of these GUIs to play with the toolbox.

.. csv-table::
   :header: "Name of the GUI", "Features", "|matlab| function", "YAML config. file"
   :widths: 25, 25, 25, 25
  
   "Demo", "This main GUI is used to run other GUIs", `demo.m <../../../demo.m>`_
   "EBSD map GUI", "This GUI is used to analyze slip transmission across GBs for an EBSD map", `A_gui_plotmap.m <../../../gui_ebsd_map/A_gui_plotmap.m>`_, "config_gui_EBSDmap_default.yaml"
   "Bicrystal GUI", "This GUI is used to analyze slip transfer in a bicrystal", `A_gui_plotGB_Bicrystal.m <../../../gui_bicrystal/A_gui_plotGB_Bicrystal.m>`_
   "preCPFE_SX", "This GUI is used to preprocess the CPFE model for SX indentation", `A_femproc_windows_indentation_setting_SX.m <../../../gui_preCPFE/A_femproc_windows_indentation_setting_SX.m>`_, "config_CPFEM_default.yaml"
   "preCPFE_BX", "This GUI is used to preprocess the CPFE model for BX indentation", `A_femproc_windows_indentation_setting_BX.m <../../../gui_preCPFE/A_femproc_windows_indentation_setting_BX.m>`_, "config_CPFEM_default.yaml"
   
Default YAML configuration file (config.yaml) common to all GUIs is loaded automatically to set the GUIs.

If the OpenGL rendering is not satisfying, you can modify the corresponding option in the config.yaml file stored in the following folder : `YAML_config_files <../../../YAML_config_files>`_.

`Visit the YAML website for more informations. <http://www.yaml.org/>`_

`Visit the YAML code for Matlab. <http://code.google.com/p/yamlmatlab/>`_