Fatigue and Crack Path Ranking
===============================

.. include:: includes.rst

This section is dedicated to the use of grain-boundary and slip parameters to **rank potential crack paths**,
in particular for microstructurally short fatigue cracks.
It is distinct from :doc:`slip_transmission`, which gathers the *traditional* parameters
(:math:`m'`, :math:`LRB`, residual Burgers vector, ...) describing **plasticity transmission** across grain boundaries.

Parameters are not used here to predict whether a dislocation crosses a boundary,
but to compare candidate boundaries or slip systems and to identify the most likely crack path.

Fatigue life and microstructure
--------------------------------

Fatigue life is usually divided into crack initiation (including growth through the first few grains) and crack propagation.
Microstructurally small cracks are sensitive to the local microstructure (grain orientation, neighbours, grain boundaries),
whereas long cracks are not [#Hansen_2024]_.

Crack path parameters implemented in the STABiX toolbox
---------------------------------------------------------

.. csv-table::
   :header: "Parameter", "Function", "|matlab| function", "Reference"
   :widths: 30, 40, 20, 10

   ":math:`\chi` factor from Jiménez et al.", ":math:`\chi = \cos(\hat{\alpha})\cdot\cos(\hat{\delta})`", `chi_factor.m <https://github.com/stabix/stabix/tree/master/slip_transfer/chi_factor.m>`_, [#Jimenez_2019]_

:math:`\chi` factor from Jiménez et al. (2019)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. math:: \chi = \cos(\hat{\alpha}) \cdot \cos(\hat{\delta})
    :label: chi_factor

The :math:`\chi` factor follows the approach of Beyerlein et al. [#Beyerlein_2012]_ and was used to study
the propagation of microstructurally short fatigue cracks across grain boundaries in Ni-based superalloys [#Jimenez_2019]_.
:math:`\hat{\alpha}` is the twist angle, i.e. the angle between the traces of the incoming and outgoing slip planes
on the grain boundary plane (:math:`\vec t_i = \vec n_i \times \vec n_\text{GB}`), and :math:`\hat{\delta}` is the minimum angle
between the incoming slip direction and the slip directions of the outgoing plane.
Both angles lie between :math:`0` and :math:`90°`, so :math:`\chi` ranges from :math:`0` (worst alignment) to :math:`1` (perfect alignment).
Among candidate outgoing slip systems, the one with the highest :math:`\chi` is the most likely crack path.
Cracks were found to propagate across boundaries for :math:`\hat{\alpha} < 45°` and :math:`\hat{\delta} < 45°`,
with :math:`\chi` close to :math:`1`, independently of the Schmid factor.

The |matlab| function is
`chi_factor.m <https://github.com/stabix/stabix/tree/master/slip_transfer/chi_factor.m>`_.
A Python example for visualization is available as a notebook:
`chi_factor_example.ipynb <https://github.com/stabix/stabix/tree/master/python/chi_factor_example.ipynb>`_
(script version: `chi_factor_example.py <https://github.com/stabix/stabix/tree/master/python/chi_factor_example.py>`_).

Fatigue indicator parameters (FIPs)
------------------------------------

Fatigue indicator parameters are computed from crystal plasticity finite element simulations (see :doc:`bicrystal_gui` and :doc:`preCPFE_gui`)
and serve as a proxy for crack initiation driving force.
The Fatemi-Socie FIP is, for example:

.. math:: \text{FIP}_\text{FS} = \frac{\Delta\gamma_p^\text{max}}{2}\left(1 + \frac{\sigma_n^\text{max}}{\sigma_y}\right)

where :math:`\Delta\gamma_p^\text{max}` is the maximum cyclic plastic shear strain range on a slip plane,
:math:`\sigma_n^\text{max}` the maximum stress normal to that plane and :math:`\sigma_y` the yield strength [#Hansen_2024]_.
Because FIPs follow extreme-value (Gumbel) statistics, statistical volume elements are used instead of representative volume elements.

Microstructure features correlated with FIPs
---------------------------------------------

Hansen et al. [#Hansen_2024]_ used symbolic regression to build interpretable surrogate models of FIPs for IN625
from features defined at three scales:

* **local**: grain size, volume, strain;
* **neighbourhood**: misorientation, shared boundary area, difference in maximum Schmid factor, and the :math:`m'` slip transmission factor
  (computed with a Python port of STABiX [#Mercier_2015]_);
* **global**: maximum and average Schmid factor, Taylor factor, number of slip systems with Schmid factor above 0.4.

.. note::
    In that dataset the neighbourhood-scale features, including slip transmission, were the least correlated with the FIP,
    whereas Schmid-factor and local-strain features dominated. The authors state that this is not conclusive.
    Slip transmission parameters should therefore be seen as a complementary ranking tool, not a standalone FIP predictor.

References
-----------
.. [#Hansen_2024] `J. Hansen, S. Whelan, J. Hochhalter et al., "Interpretable machine learning for microstructure-dependent models of fatigue indicator parameters.", Int. J. of Fatigue (2024), 178, 108019. <https://doi.org/10.1016/j.ijfatigue.2023.108019>`_
.. [#Jimenez_2019] `J.A. Jiménez, W. Ludwig, C. Gonzalez and J.M. Molina-Aldareguia, "The role of slip transfer at grain boundaries in the propagation of microstructurally short fatigue cracks in Ni-based superalloys.", Scripta Materialia (2019), 162, pp. 261-265. <https://doi.org/10.1016/j.scriptamat.2018.11.014>`_
.. [#Beyerlein_2012] `I. Beyerlein et al., "Structure–Property–Functionality of Bimetal Interfaces.", The Journal of The Minerals, Metals & Materials Society (TMS) (2012), pp. 1192-1207. <https://doi.org/10.1007/s11837-012-0431-0>`_
.. [#Mercier_2015] `D. Mercier, C. Zambaldi and T.R. Bieler, "A Matlab toolbox to analyze slip transfer through grain boundaries.", IOP Conf. Ser.: Mater. Sci. Eng. (2015), 82, 012090. <https://doi.org/10.1088/1757-899X/82/1/012090>`_
