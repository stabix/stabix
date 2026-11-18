EBSD map GUI
============

.. include:: includes.rst
 
This GUI supports quantitative analysis of slip transmission across grain boundaries in an EBSD map.

The |matlab| function used to run the EBSD map GUI is: `A_gui_plotmap.m <https://github.com/stabix/stabix/tree/master/gui_ebsd_map/A_gui_plotmap.m>`_.

This includes:

* :ref:`loading_GBs`
* :ref:`smoothing_GBs`
* :ref:`misorientation_angle`
* :ref:`mp_parameter`
* :ref:`residual_Burgers_vector`
* :ref:`ebsd_chi_crack_ranking`
* :ref:`Schmid_factor_slip_traces`

.. _loading_GBs:

Loading EBSD data
---------------------------

For more details about the format of the EBSD data, see also the page:
`Experimental data <https://stabix.readthedocs.io/en/latest/experimental_data.html>`_.

.. figure:: ./_pictures/gui/EBSD_map_setting.png
   :scale: 40 %
   :align: center
   
   *Steps for loading data into the EBSD map GUI.*
   
.. warning::
    When importing datasets with a large number of grains (e.g., more than
    300 grains), loading and plotting may take a few minutes.

.. _smoothing_GBs:

Smoothing GB segments
------------------------

The smoothing algorithm reduces the number of grain-boundary segments to
speed up calculations and plotting.
Move the slider to the right to reduce the number of segments.

.. figure:: ./_pictures/gui/EBSD_map_loading_smoothing.png
   :scale: 40 %
   :align: center
   
   *Screenshot of the EBSD map GUI with an EBSD map of near alpha phase
   Ti alloy a) before smoothing and b) after smoothing.*


The |matlab| function used to smooth GBs is:
`interface_map_GB_segments_opti.m <https://github.com/stabix/stabix/tree/master/gui_ebsd_map/interface_map_GB_segments_opti.m>`_

.. _misorientation_angle:

Misorientation angle
--------------------

.. figure:: ./_pictures/gui/EBSD_map_misor.png
   :scale: 40 %
   :align: center
   
   *Screenshot of the EBSD map GUI with an EBSD map of near alpha phase Ti alloy
   (GBs are color-coded according to the maximum misorientation angle).*

.. _mp_parameter:

m' parameter
------------

.. figure:: ./_pictures/gui/EBSD_map_max_mprime.png
   :scale: 40 %
   :align: center
   
   *Screenshot of the EBSD map GUI with an EBSD map of near alpha phase Ti alloy
   (GBs are color-coded according to the maximum m' value).*

.. figure:: ./_pictures/gui/EBSD_map_mprime_GSF.png
   :scale: 40 %
   :align: center
   
   *Screenshot of the EBSD map GUI with an EBSD map of near alpha phase Ti alloy
   (GBs are color-coded according to the maximum m' value for slip systems with the highest generalized Schmid factor).*

.. _residual_Burgers_vector:

Residual Burgers vector
-----------------------

.. figure:: ./_pictures/gui/EBSD_map_minRBV.png
   :scale: 40 %
   :align: center
   
   *Screenshot of the EBSD map GUI with an EBSD map of near alpha phase Ti alloy
   (GBs are color-coded according to the maximum residual Burgers vector magnitude).*

.. _ebsd_chi_crack_ranking:

Crack-path ranking with chi
---------------------------

Select **chi max (crack ranking; 90 deg GB)** at the end of the
**GB parameter to plot** menu. Each boundary is colored by the maximum
:math:`\chi` over all pairs of selected slip systems in its two grains,
on a fixed scale from 0 to 1. **Plot of Slip Traces** displays the first
maximizing pair when several pairs tie.

.. warning::
    A 2D EBSD map does not determine the grain-boundary plane inclination.
    This option uses the map's existing assumption that each boundary plane
    is perpendicular to the sample surface (90 degrees), with its normal
    derived from the boundary trace in the Euler-angle reference frame.
    Results are an approximation, not a reconstruction of the true 3D
    boundary geometry or a prediction of fracture.

Undefined intersections (a slip plane parallel to the boundary plane) and
padded slip-system entries are excluded. If no valid pair remains for a
boundary, the calculation raises ``STABiX:UndefinedChi``.

The maximum ranks geometric compatibility without specifying an observed
incoming crack/slip system. See :doc:`fatigue_crack` for the definition and
limitations of this crack-path ranking parameter. Fatigue indicator parameters
requiring cyclic plastic strain and stress are not computed from EBSD alone.

.. _Schmid_factor_slip_traces:

Schmid factor and slip trace analysis
-------------------------------------

.. figure:: ./_pictures/gui/EBSD_map_max_mprime_SF_slip_traces.png
   :scale: 40 %
   :align: center
   
   *Screenshot of the EBSD map GUI with an EBSD map of a near-alpha Ti alloy (slip plane plotted inside the grain and
   slip trace plotted around the unit cells; both are selected according to the maximum Schmid factor for a given stress tensor).*
   
Plot options
-------------------------------------

The |matlab| function used to plot the crystal lattice is `vis_lattice.m <https://github.com/stabix/stabix/tree/master/crystallo/vis_lattice.m>`_.

It is also possible to plot the structure of octahedral and tetrahedral interstitial defects.

.. figure:: ./_pictures/plot/lattice_interstitialSite.png
   :scale: 40 %
   :align: center
   
   *Octahedral (red) and tetrahedral (blue) interstitial symmetry polyhedra in face-centered cubic, body-centered cubic and hexagonal lattices.*
