Bicrystal GUI
=============

.. include:: includes.rst

This GUI allows to analyze quantitatively slip transmission across grain boundaries for a single bicrystal selected from the EBSD map plotted previously in the map GUI
or set by the user (directly inside the bicrystal GUI or by loading a
`YAML config. bicrystal <https://github.com/stabix/stabix/tree/master/gui_bicrystal/gui_bicrystal_data/Kacher2012/Kacher2012_Fig.12.yaml>`_ file from the menu).

The |matlab| function used to run the bicrystal GUI is: `A_gui_plotGB_Bicrystal.m <https://github.com/stabix/stabix/tree/master/gui_bicrystal/A_gui_plotGB_Bicrystal.m>`_

This includes:

* :ref:`bicrystal_from_map`
* :ref:`all_mprime_values`

Loading Bicrystal data
--------------------------

It is possible to load bicrystal properties (material, phase, Euler angles of both grains, trace angle...) :
    - from the `EBSD map GUI <http://stabix.readthedocs.org/en/latest/ebsd_map_gui.html>`_ (by giving GB's number and pressing the button 'PLOT BICRYSTAL');
    - from a YAML configuration file (from the menu, by clicking on 'Bicrystal, and 'Load Bicrystal config. file').

.. figure:: ./_pictures/GUIs/ebsd2bicrystal.png
   :scale: 50 %
   :align: center
   
   *Figure 1 : The different steps to set the bicrystal GUI.*

.. _bicrystal_from_map:

Plotting and analyzing a bicrystal
-----------------------------------

.. figure:: ./_pictures/GUIs/BX.png
   :scale: 40 %
   :align: center
   
   *Figure 2 : Screenshot of the Bicrystal GUI.*
   
.. _all_mprime_values:

Distribution of all slip transmission parameters
-------------------------------------------------

It is possible to generate a new window, in which all values of the selected slip transmission parameter are plotted in function of selected slip families.

.. figure:: ./_pictures/GUIs/all_mprime_values.png
   :scale: 40 %
   :align: center
   
   *Figure 3 : Screenshot of the distribution of all slip transmission parameters (e.g.: m' parameter for a single phase (HCP) bicrystal).*
