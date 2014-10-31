Bicrystal Definition
====================

..  |matlab| replace:: Matlab\ :sup:`TM` \

Crystallographic properties of a bicrystal
******************************************

A bicrystal is formed by two adjacent crystals separated by a grain boundary.

**Five macroscopic degrees of freedom are required to characterize a grain boundary** [#Priester_2013]_, [#Randle_2001]_, [#Randle_2005]_ and [#SuttonBalluffi_1995]_ :
    • 3 for the rotation between the two crystals;
    • 2 for the orientation of the grain boundary plane defined by its normal :math:`n`.

The rotation between the two crystals is defined by the rotation angle :math:`\omega` and the rotation axis common to both crystals :math:`[uvw]`.

Using orientation matrix of both crystals obtained by EBSD measurements, the misorientation or disorientation matrix :math:`(\Delta g)` or :math:`(\Delta g_d)` is calculated [#RandleEngler_2000]_ and [#Morawiec_2004]_ :

  .. math:: \Delta g = g_{B}g_{A}^{-1} = g_{A}g_{B}^{-1}
        :label: misorientation_matrix
        
  .. math:: \Delta g_d = (g_{B}*CS)(CS^{-1}*g_{A}^{-1}) = (g_{A}*CS)(CS^{-1}*g_{B}^{-1})
        :label: disorientation
        
Disorientation describes the misorientation with the smallest possible rotation angle and :math:`CS` denotes one of the symmetry operators for the material [#Kocks_2000]_.

The |matlab| function used to set the symmetry operators is: `sym_operators.m <https://github.com/stabix/stabix/blob/master/crystallo/sym_operators.m>`_
        
The orientation matrix :math:`g` of a crystal is calculated from the Euler angles (:math:`\phi_{1}`, :math:`\Phi`, :math:`\phi_{2}`) using the following equation :
    
  .. math::
       g = 
      \begin{pmatrix}
      \cos(\phi_{1})\cos(\phi_{2})-\sin(\phi_{1})\sin(\phi_{2})\cos(\Phi)  & \sin(\phi_{1})\cos(\phi_{2})+\cos(\phi_{1})\sin(\phi_{2})\cos(\Phi)  & \sin(\phi_{2})\sin(\Phi) \\
      -\cos(\phi_{1})\sin(\phi_{2})-\sin(\phi_{1})\cos(\phi_{2})\cos(\Phi) & -\sin(\phi_{1})\sin(\phi_{2})+\cos(\phi_{1})\cos(\phi_{2})\cos(\Phi) & \cos(\phi_{2})\sin(\Phi) \\
      \sin(\phi_{1})\sin(\Phi)                                          & -\cos(\phi_{1})\sin(\Phi)                                         & \cos(\Phi) \\
      \end{pmatrix}
      :label: orientation_matrix

The orientation of a crystal (Euler angles) can be determined via electron backscatter diffraction (EBSD) measurement or via transmission electron microscopy (TEM).

The |matlab| function used to generate random Euler angles is: `randBunges.m <https://github.com/stabix/stabix/blob/master/crystallo/randBunges.m>`_
      
The |matlab| function used to calculate the orientation matrix from Euler angles is: `eulers2g.m <https://github.com/stabix/stabix/blob/master/crystallo/eulers2g.m>`_

The |matlab| function used to calculate Euler angles from the orientation matrix is: `g2eulers.m <https://github.com/stabix/stabix/blob/master/crystallo/g2eulers.m>`_
        
Then, from this misorientation matrix (:math:`\Delta g`), the rotation angle (:math:`\omega`) and the rotation axis :math:`[u, v, w]` can be obtained by the following equations :
  
  .. math:: \omega = \cos^{-1}((tr(\Delta g)-1)/2)
        :label: misorientation_angle
        
  .. math:: 
            u = \Delta g_{23} - \Delta g_{32} \\
            v = \Delta g_{31} - \Delta g_{13} \\
            w = \Delta g_{12} - \Delta g_{21}
        :label: misorientation_axis
        
The |matlab| function used to calculate the misorientation angle is: `misorientation.m <https://github.com/stabix/stabix/blob/master/crystallo/misorientation.m>`_
        
The grain boundary plane normal :math:`n` can be determined knowing the grain boundary trace angle :math:`\alpha` and the grain boundary inclination :math:`\beta`.
        
The grain boundary trace angle is obtained through the EBSD measurements (grain boundary endpoints coordinates) and the grain boundary inclination can be assessed
by a serial polishing (chemical-mechanical polishing or FIB sectioning), either parallel or perpendicular to the surface of the sample.

A `Matlab toolbox <https://github.com/stabix/stabix/tree/master/gui_gbinc>`_ has been developed to assess the grain boundary inclination by a comparison of SEM images obtained before and after a polishing step.
At least three Vickers indents are needed as fixed markers. For more details, please see the `README file. <https://github.com/stabix/stabix/blob/master/gui_gbinc/README.rst>`_

.. figure:: ./_pictures/Schemes_SlipTransmission/bicrystal.png
   :scale: 50 %
   :align: center
   
   *Figure 1 : Schematic of a bicrystal.*

.. only:: html
    .. figure:: ./_pictures/GUIs/gui_gb_inc.png.gif
       :scale: 50 %
       :align: center
       
       *Figure 2 : Screenshots of the Matlab GUI used to calculate grain boundary inclination.*

.. only:: latex
    .. figure:: ./_pictures/GUIs/gui_gb_inc.png
       :scale: 50 %
       :align: center
       
       *Figure 2 : Screenshot of the Matlab GUI used to calculate grain boundary inclination.*

.. [#Kocks_2000] `U.F. Kocks et al., "Texture and Anisotropy: Preferred Orientations in Polycrystals and Their Effect on Materials Properties." Cambridge University Press (2000). <http://www.cambridge.org/gb/academic/subjects/engineering/materials-science/texture-and-anisotropy-preferred-orientations-polycrystals-and-their-effect-materials-properties>`_
.. [#Morawiec_2004] `A. Morawiec, "Orientations and Rotations: Computations in Crystallographic Textures.", Springer, 2004. <http://www.springer.com/materials/book/978-3-540-40734-8>`_
.. [#Priester_2013] `L. Priester, "Grain Boundaries: From Theory to Engineering.", Springer Series in Materials Science (2013). <http://www.springer.com/materials/surfaces+interfaces/book/978-94-007-4968-9>`_
.. [#RandleEngler_2000] `V. Randle and O. Engler, "Introduction to Texture Analysis: Macrotexture, Microtexture and Orientation Mapping.", CRC Press (2000). <http://www.crcpress.com/product/isbn/9781420063653>`_
.. [#Randle_2001] `V. Randle, "A methodology for grain boundary plane assessment by single-section trace analysis.", Scripta Mater., 2001, 44, pp. 2789-2794. <http://dx.doi.org/10.1016/S1359-6462(01)00975-7>`_ 
.. [#Randle_2005] `V. Randle, "Five-parameter’ analysis of grain boundary networks by electron backscatter diffraction.", J. Microscopy, 2005, 222, pp. 69-75. <http://dx.doi.org/10.1111/j.1365-2818.2006.01575.x>`_
.. [#SuttonBalluffi_1995] `A.P. Sutton and R.W. Balluffi, "Interfaces in Crystalline Materials.", OUP Oxford (1995). <http://ukcatalogue.oup.com/product/9780199211067.do>`_