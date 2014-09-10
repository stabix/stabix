Motivation of this Work
=======================
..    include:: <isonum.txt>
The micromechanical behavior of grain boundaries is one of the key components in the understanding of heterogeneous deformation of metals [#Bieler_2014]_.
To investigate the nature of the strengthening effect of grain boundaries, slip transmission across interfaces has been investigated through
bicrystal deformation experiments during the sixty past decades [#Aust_1968]_, [#LivingstonChalmers_1957]_, [#Shen_1986]_, [#Shen_1988]_, [#LusterMorris_1995]_,
[#Marcinkowski_1970]_, [#Bollmann_1970]_, [#LimRaj_1985]_, [#Lee_1989]_, [#Lee_1990_2]_, [#Clark_1992]_, [#Abuzaid_2012]_, [#Seal_2012]_ and [#Kacher_2014]_.
Originally, interactions between dislocations and grain boundaries
have been observed in the transmission electron microscope (TEM) after strain test or in situ [#Shen_1986]_, [#Shen_1988]_ and [#Kacher_2014]_. Some authors observed as
well slip transmission during indentation tests performed close to grain boundaries [#WoNgan_2004]_, [#Soer_2005]_, [#Britton_2009]_, [#Pathak_2012]_ and [#Lawrence_2014]_.

To better understand the role played by the grain boundaries, we developed a Matlab\ :sup:`TM` \ Toolbox with Graphical User Interfaces (GUI),
to analyze and to quantify the micromechanics of grain boundaries.
This toolbox aims to link experimental results to crystal plasticity finite element (CPFE) simulations.

Strategy
--------

Comparison of topographies of indentations at grain boundaries to simulated indentations as predicted by 3D CPFE modelling.

The goals of this research are:

1 - Carry out indentation within the interiors of large grains of alpha-titanium to effectively collect single crystal data coupled with extensive
(three-dimensional) characterization of the resulting plastic defect fields surrounding the indents [#Zambaldi_2012]_. By correlating with models of the indentation,
a precise constitutive description of the anisotropic plasticity of single-crystalline titanium shall be developed [#Roters_2010]_ and [#DAMASK]_.

2 - Extension of this methodology to indentations close to grain boundaries, i.e. quasi bi-crystal deformation.

3 - Comparison of the measured characteristics of indentations at grain boundaries to simulated indentations as predicted by a constitutive model
calibrated using the single crystal indentations.
 
4 - Based on this qualitative understanding, a grain boundary transmissivity description will be
developed validated against the collected indent characteristics.

.. [#Bieler_2014] `T.R. Bieler et al., "Grain boundaries and interfaces in slip transfer.", Current Opinion in Solid State and Materials Science (2014), in press. <http://dx.doi.org/10.1016/j.cossms.2014.05.003>`_
.. [#Aust_1968] `K.T. Aust et al., "Solute induced hardening near grain boundaries in zone refined metals.", Acta Metallurgica (1968), 16(3), pp. 291-302. <http://dx.doi.org/10.1016/0001-6160(68)90014-X>`_
.. [#LivingstonChalmers_1957] `J.D. Livingston and B. Chalmers, "Multiple slip in bicrystal deformation.", Acta Metallurgica (1957), 5(6), pp. 322-327. <http://dx.doi.org/10.1016/0001-6160(57)90044-5>`_
.. [#Shen_1986] `Z. Shen et al., "Dislocation pile-up and grain boundary interactions in 304 stainless steel.", Scripta Metallurgica (1986), 20(6), pp. 921–926. <http://dx.doi.org/10.1016/0036-9748(86)90467-9>`_
.. [#Shen_1988] `Z. Shen et al., "Dislocation and grain boundary interactions in metals.", Acta Metallurgica (1988), 36(12), pp. 3231–3242. <http://dx.doi.org/10.1016/0001-6160(88)90058-2>`_
.. [#LusterMorris_1995] `J. Luster and M.A. Morris, "Compatibility of deformation in two-phase Ti-Al alloys: Dependence on microstructure and orientation relationships.", Metal. and Mat. Trans. A (1995), 26(7), pp. 1745-1756. <http://dx.doi.org/10.1007/BF02670762>`_
.. [#Marcinkowski_1970] `M.J. Marcinkowski and W.F. Tseng, "Dislocation behavior at tilt boundaries of infinite extent.", Metal. Trans. (1970), 1(12), pp. 3397-3401. <http://dx.doi.org/10.1007/BF03037870>`_
.. [#Bollmann_1970] `W. Bollmann, "Crystal Defects and Crystalline Interfaces", Springer-Verlag (1970) <http://dx.doi.org/10.1007/978-3-642-49173-3>`_
.. [#LimRaj_1985] `L.C. Lim and R. Raj, "Continuity of slip screw and mixed crystal dislocations across bicrystals of nickel at 573K.", Acta Metallurgica (1985), 33, pp. 1577. <http://dx.doi.org/10.1016/0001-6160(85)90057-4>`_
.. [#Lee_1989] `T.C. Lee et al., "Prediction of slip transfer mechanisms across grain boundaries.", Scripta Metallurgica, (1989), 23(5), pp. 799–803. <http://dx.doi.org/10.1016/0036-9748(89)90534-6>`_
.. [#Lee_1990_2] `T.C. Lee et al., "An In Situ transmission electron microscope deformation study of the slip transfer mechanisms in metals", Metallurgical Transactions A (1990), 21(9), pp. 2437-2447. <http://dx.doi.org/10.1007/BF02646988>`_
.. [#Clark_1992] `W.A.T. Clark et al., "On the criteria for slip transmission across interfaces in polycrystals.", Scripta Metallurgica et Materialia (1992), 26(2), pp. 203–206. <http://dx.doi.org/10.1016/0956-716X(92)90173-C>`_
.. [#Abuzaid_2012] `W.Z. Abuzaid et al., "Slip transfer and plastic strain accumulation across grain boundaries in Hastelloy X.", J. of the Mech. and Phys. of Sol. (2012), 60(6) ,pp. 1201–1220. <http://dx.doi.org/10.1016/j.jmps.2012.02.001>`_
.. [#Seal_2012] `J.R. Seal et al., "Analysis of slip transfer and deformation behavior across the α/β interface in Ti–5Al–2.5Sn (wt.%) with an equiaxed microstructure.", Mater. Sc. and Eng.: A (2012), 552, pp. 61-68. <http://dx.doi.org/10.1016/j.msea.2012.04.114>`_
.. [#Kacher_2014] `J. Kacher et al., "Dislocation interactions with grain boundaries.", Current Opinion in Solid State and Materials Science (2014), in press. <http://dx.doi.org/10.1016/j.cossms.2014.05.004>`_
.. [#WoNgan_2004] `P.C. Wo and A.H.W. Ngan, "Investigation of slip transmission behavior across grain boundaries in polycrystalline Ni3Al using nanoindentation.", J. Mater. Res. (2004), 19(1), pp. 189-201. <http://dx.doi.org/10.1557/jmr.2004.19.1.189>`_
.. [#Soer_2005] `W.A. Soer et al. ,"Incipient plasticity during nanoindentation at grain boundaries in body-centered cubic metals.", Acta Materialia (2005), 53, pp. 4665–4676. <http://dx.doi.org/10.1016/j.actamat.2005.07.001>`_
.. [#Britton_2009] `T.B. Britton et al., "Nanoindentation study of slip transfer phenomenon at grain boundaries.", J. Mater. Res., 2009, 24(3), pp. 607-615. <http://dx.doi.org/10.1557/jmr.2009.0088>`_
.. [#Pathak_2012] `S. Patthak et al., "Studying grain boundary regions in polycrystalline materials using spherical nano-indentation and orientation imaging microscopy.", J. Mater. Sci. (2012), 47, pp. 815–823. <http://dx.doi.org/10.1007/s10853-011-5859-z>`_
.. [#Lawrence_2014] `S.K. Lawrence et al., "Grain Boundary Contributions to Hydrogen-Affected Plasticity in Ni-201.", The Journal of The Minerals, Metals & Materials Society (2014), 66(8), pp. 1383-1389. <http://dx.doi.org/10.1007/s11837-014-1062-4>`_
.. [#Zambaldi_2012] `C. Zambaldi et al., "Orientation informed nanoindentation of α-titanium: Indentation pileup in hexagonal metals deforming by prismatic slip", J. Mater. Res. (2012), 27(01), pp. 356-367. <http://dx.doi.org/10.1557/jmr.2011.334>`_
.. [#Roters_2010] `F. Roters et al., "Overview of constitutive laws, kinematics, homogenization and multiscale methods in crystal plasticity finite-element modeling: Theory, experiments, applications.",  Acta Materialia (2010), 58(4), pp. 1152-1211. <http://dx.doi.org/10.1016/j.actamat.2009.10.058>`_
.. [#DAMASK] `DAMASK — the Düsseldorf Advanced Material Simulation Kit <http://damask.mpie.de/>`_
