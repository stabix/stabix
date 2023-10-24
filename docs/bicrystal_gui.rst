Bicrystal GUI
===============

.. include:: includes.rst

This GUI allows to analyze quantitatively slip transmission across grain boundaries for a single bicrystal.

The |matlab| function used to run the Bicrystal GUI is : `A_gui_plotGB_Bicrystal.m <https://github.com/stabix/stabix/tree/master/gui_bicrystal/A_gui_plotGB_Bicrystal.m>`_

This includes:

* :ref:`bicrystal_from_map`
* :ref:`all_mprime_values`

Loading Bicrystal data
--------------------------

It is possible to load bicrystal properties (material, phase, Euler angles of both grains, trace angle...) :
    - from the `EBSD map GUI <http://stabix.readthedocs.org/en/latest/ebsd_map_gui.html>`_ (by giving GB number and pressing the button 'PLOT BICRYSTAL') ;
    - from a `YAML config. bicrystal <https://github.com/stabix/stabix/tree/master/gui_bicrystal/gui_bicrystal_data/kacher_2012/Kacher2012_Fig.12.yaml>`_ (from the menu, by clicking on 'Bicrystal, and 'Load Bicrystal config. file').

.. figure:: ./_pictures/gui/ebsd2bicrystal.png
   :scale: 50 %
   :align: center
   
   *The different steps to set the Bicrystal GUI.*

.. _bicrystal_from_map:

Plotting and analyzing a bicrystal
------------------------------------

.. figure:: ./_pictures/gui/BX.png
   :scale: 40 %
   :align: center
   
   *Screenshot of the Bicrystal GUI.*

.. _all_mprime_values:

Distribution of all slip transmission parameters
--------------------------------------------------

It is possible to generate a new window, in which all values of the selected slip transmission parameter are plotted in function of selected slip families.

.. figure:: ./_pictures/gui/all_mprime_values.png
   :scale: 40 %
   :align: center
   
   *Screenshot of the distribution of all slip transmission parameters (e.g.: m' parameter for a single phase (HCP) bicrystal).*