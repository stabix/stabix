Strain Transfer Across Grain Boundaries
=======================================

.. include:: includes.rst

The strain transfer across grain boundaries can be defined by the four following mechanisms (see :numref:`sutton_balluffi`) [#LimRaj_1985_1]_, [#SuttonBalluffi_1995]_, [#Zaefferer_2003]_ and [#Priester_2013]_ :

 1) direct transmission with slip systems having the same Burgers vector, and the grain boundary is transparent to dislocations (no strengthening effect) (:numref:`sutton_balluffi`-a);

 2) direct transmission, but slip systems have different Burgers vector (leaving a residual boundary dislocations) (:numref:`sutton_balluffi`-b);

 3) indirect transmission, and slip systems have different Burgers vector (leaving a residual boundary dislocations) (:numref:`sutton_balluffi`-c);

 4) no transmission and the grain boundary acts as an impenetrable boundary, which implies stress accumulations, localized rotations, pile-up of dislocations... (:numref:`sutton_balluffi`-d).

.. figure:: ./_pictures/schemes_slip_transmission/slip_transfer.png
   :name: sutton_balluffi
   :scale: 40 %
   :align: center
   
   *Possible strain transfer across grain boundaries (GB) from Sutton and Balluffi.*
       
Several authors proposed slip transfer parameters from modellings or experiments for the last 60 years.
A non-exhaustive list of those criteria is given in the next part of this work, including geometrical parameter,
stress and energetic functions, and recent combinations of the previous parameters.

.. note::
    Most of the time, following criteria are used to quantify slip transmission across grain boundaries in monophasic bicrystals.
	But in case of bimetal interfaces, it sounds that stress-based criteria are more relevant than
	geometrical criteria, given much higher stresses required for for slip transmission [#Hunter_2017]_ .

Geometrical Criteria
-----------------------
Based on numerous investigations of dislocation-grain boundary interactions,
quantitative geometrical expressions describing the slip transmission mechanisms have been developed. 
A non-exhaustive list of geometrical criteria is detailed subsequently.
The geometry of the slip transfer event is most of the time described by the scheme given :numref:`slipTransmissionScheme`.
:math:`\kappa` is the angle between slip directions, :math:`\theta`
is the angle between the two slip plane intersections with the grain boundary,
:math:`\psi` is the angle between slip plane normal directions, :math:`\gamma`
is the angle between the direction of incoming slip and the plane normal of outgoing slip,
and :math:`\delta` is between the direction of outgoing slip and the plane normal of incoming slip.
:math:`n`, :math:`d` and :math:`l` are respectively the slip plane normals,
slip directions and the lines of intersection of the slip plane and the grain boundary.
:math:`\vec b` is the Burgers vector of the slip plane and :math:`\vec b_\text r`
is the |rbv| of the residual dislocation at the grain boundary.
The subscripts :math:`\text{in}` and :math:`\text{out}` refer to the incoming and outgoing slip systems, respectively.

.. figure:: ./_pictures/schemes_slip_transmission/slip_transmission_scheme2.png
   :name: slipTransmissionScheme
   :scale: 45 %
   :align: center

   *Geometrical description of the slip transfer.*

* :math:`N` **factor from Livingston and Chalmers in 1957** [#LivingstonChalmers_1957]_ 

    .. math:: N = (\vec n_\text{in} \cdot \vec n_\text{out})(\vec d_\text{in} \cdot \vec d_\text{out}) + (\vec n_\text{in} \cdot \vec d_\text{out})(\vec n_\text{out} \cdot \vec d_\text{in})
        :label: n_factor
        
    .. math:: N = \cos(\psi) \cdot \cos(\kappa) + \cos(\gamma) \cdot \cos(\delta)
        :label: n_factor_angle
        
  Many authors referred to this criterion to analyze slip transmission [#HauserChamlers_1961]_, [#Davis_1966]_, [#HookHirth_1967_1]_,
  [#HookHirth_1967_2]_, [#Shen_1986]_, [#Shen_1988]_, [#Lee_1990_1]_, [#Lee_1990_2]_, [#Clark_1992]_ and [#Ueda_2002]_.
  Pond et al. proposed to compute this geometric criteria for hexagonal metals using Frank's method [#Pond_1986]_.
  
  The |matlab| function used to calculate the N factor is :
  `N_factor.m <https://github.com/stabix/stabix/tree/master/slip_transfer/N_factor.m>`_
  
* :math:`LRB` **factor from Shen et al. in 1986** [#Shen_1986]_ and [#Shen_1988]_

    .. math:: LRB = (\vec l_\text{in} \cdot \vec l_\text{out})(\vec d_\text{in} \cdot \vec d_\text{out})
        :label: LRB_factor
        
    .. math:: LRB = \cos(\theta) \cdot \cos(\kappa)
        :label: LRB_factor_angle
        
  The original notation of this :math:`LRB` factor is :math:`M`,
  but unfortunately this notation is often used for the Taylor factor [#Bieler_2014]_.
  Pond et al. proposed to compute this geometric criteria for hexagonal metals using Frank's method [#Pond_1986]_. 
  Recently, Spearot and Sangid have plotted this parameter as a function of
  the misorientation of the bicrystal using atomistic simulations [#SpearotSangid_2014]_.
  
  [#Lee_1989]_, [#Lee_1990_1]_, [#Lee_1990_2]_, [#Clark_1992]_, [#Kehagias_1995]_, [#Kehagias_1996]_, [#Ashmawi_2001]_, [#Gemperle_2004]_,
  [#Gemperlova_2004]_ and [#Shi_2011]_ mentioned in their respective studies this geometrical parameter as a condition for slip transmission.
  
  The inclination of the grain boundary (:math:`\beta`) is required to evaluate
  this factor and the :math:`LRB` or :math:`M` factor should be maximized.
  
  The |matlab| function used to calculate the LRB factor is :
  `LRB_parameter.m <https://github.com/stabix/stabix/tree/master/slip_transfer/LRB_parameter.m>`_

* :math:`m'` **parameter from Luster and Morris in 1995** [#LusterMorris_1995]_
        
    .. math:: m' = (\vec n_\text{in} \cdot \vec n_\text{out})(\vec d_\text{in} \cdot \vec d_\text{out}) 
        :label: m_prime
        
    .. math:: m' = \cos(\psi) \cdot \cos(\kappa)
        :label: m_prime_angle

  Many authors found that this :math:`m'` parameter, which takes into account the degree of coplanarity of slip systems, is promising
  to predict slip transmission [#WangNgan_2004]_, [#WoNgan_2004]_, [#Britton_2009]_, [#Bieler_2009]_, [#Bieler_2014]_ , [#Guo_2014]_, [#Wang_2014]_, [#Guo_2015]_ and [#Nervo_2016].
  Both :math:`m'` and :math:`LRB` can be easily assessed in computational experiments [#Bieler_2014]_.
  This :math:`m'` factor should be maximized (1 means grain boundary
  is transparent and 0 means grain boundary is an impenetrable boundary).

   .. figure:: ./_pictures/schemes_slip_transmission/mprime_values.png
      :name: mprime_values
      :scale: 30 %
      :align: center
      
      *Distribution of m' parameter in function of angles values.*

   .. figure:: ./_pictures/schemes_slip_transmission/mprime_values_vs_misorientation.png
      :name: mprime_values_vs_misorientation
      :scale: 50 %
      :align: center
      
      *Distributions of m' parameter calculated for a) basal vs basal slip systems,
      b) basal vs prismatic <a> slip systems and c) prismatic <a> vs prismatic <a>
      slip systems in function of misorientation angle.*

   A resistance factor of the grain boundary can be described by the following equation : 
   
    .. math:: GB_\text{resfac} = 1 - m'
        :label: resistance_factor
        
  This factor is equal to 0, when grain boundary is transparent to dislocations.
  This implies :math:`m'` parameter equal to 1 (slip perfectly aligned).
   
  The |matlab| function used to calculate the m' parameter is :
  `mprime.m <https://github.com/stabix/stabix/tree/master/slip_transfer/mprime.m>`_
     
* :math:`\vec b_\text r` **the residual Burgers vector** [#Marcinkowski_1970]_, [#Bollmann_1970]_, [#LimRaj_1985_1]_, [#LimRaj_1985_2]_, [#Clark_1989]_, [#Lee_1990_2]_ and [#Clark_1992]_.
    .. math:: \vec b_\text{r} = \vec g_\text{in}\cdot\vec b_\text{in} - \vec g_\text{out}\cdot\vec b_\text{out}
        :label: residual_burgers_vector
        
  The magnitude of this |rbv| should be minimized.
  
  Shirokoff et al., Kehagias et al., and Kacher et al. used the |rbv| as a criterion to analyse slip transmission in cp-Ti (HCP)
  [#Shirokoff_1993]_, [#Kehagias_1995]_, [#Kehagias_1996]_ and [#KacherRobertson_2014]_,
  Lagow et al. in Mo (BCC) [#Lagow_2001]_, Gemperle et al. and Gemperlova et al. in FeSi (BCC) [#Gemperle_2004]_ and [#Gemperlova_2004]_,
  Kacher et al. in 304 stainless steel (FCC) [#KacherRobertson_2012]_,
  and Jacques et al. for semiconductors [#Jacques_1990]_.
  
  Patriarca et al. demonstrated for BCC material the role of the |rbv| in predicting slip transmission,
  by analysing strain field across GBs determined by digital image correlation [#Patriarca_2013]_. 
  
  Misra and Gibala used the |rbv| to analyze slip across a FCC/BCC interphase boundary [#MisraGibala_1999]_.
  
  The |matlab| function used to calculate the |rbv| is :
  `residual_Burgers_vector.m <https://github.com/stabix/stabix/tree/master/slip_transfer/residual_Burgers_vector.m>`_
 
* **The misorientation or disorientation** (:math:`\Delta g` or :math:`\Delta g_\text d`)  [#AustChen_1954]_, [#ClarkChalmers_1954]_ and [#WoNgan_2004]_

  It has been observed during first experiments of bicrystals deformation in 1954, that the yield stress and the rate of work hardening
  increased with the orientation difference between the crystals [#AustChen_1954]_ and [#ClarkChalmers_1954]_.
  
  Some authors demonstrated a strong correlation between misorientation between grains in a bicrystal and the grain boundary energy through
  crystal plasticity finite elements modelling and
  molecular dynamics simulations [#SuttonBalluffi_1995]_, [#Ma_2006]_, [#Li_2009]_, [#Bachurin_2010]_, [#Sangid_2011]_ and [#Sangid_2012]_.
  Some authors studied the stability of grain boundaries by the calculations
  of energy difference vs. misorientation angle through the hexagonal c-axis/a-axis [#Faraoun_2006]_.
  
  The misorientation and disorientation equations are given in the
  `crystallographic properties of a bicrystal. <http://stabix.readthedocs.org/en/latest/bicrystal_definition.html>`_
 
  The |matlab| function used to calculate the misorientation angle is :
  `misorientation.m <https://github.com/stabix/stabix/tree/master/crystallo/misorientation.m>`_

* :math:`\lambda` **function from Werner and Prantl in 1990** [#Werner_1990]_

  With this function, slip transmission is expected to occur only when the angle :math:`\psi` between 
  slip plane normal directions is lower than a given critical value (:math:`\psi_c = 15°`) and
  the angle :math:`\kappa` between slip directions is lower than a given critical value (:math:`\kappa_c = 45°`).

    .. math:: \lambda = \cos\left(\frac{90°}{\psi_c}\arccos(\vec n_\text{in} \cdot \vec n_\text{out})\right)\cos\left(\frac{90°}{\kappa_c}\arccos(\vec d_\text{in} \cdot \vec d_\text{out})\right)
        :label: lambda_function
        
    .. math:: \lambda = \cos\left(\frac{90° \psi}{\psi_c}\right)\cos\left(\frac{90° \kappa}{\kappa_c}\right)
        :label: lambda_function_ang
        
  The |matlab| function used to calculate the :math:`\lambda` function is :
  `lambda.m <https://github.com/stabix/stabix/tree/master/slip_transfer/lambda.m>`_

  The authors proposed to plot pseudo-3D view of the :math:`\lambda` map (see Figures 5 and 6) using the following equation [#Werner_1990]_ :
  
    .. math:: \lambda = \sum\limits_{\alpha=1}^N \sum\limits_{\beta=1}^N \cos\left(\frac{90°}{\psi_c}\arccos(\vec n_{\text{in},\alpha} \cdot \vec n_{\text{out},\beta})\right)\cos\left(\frac{90°}{\kappa_c}\arccos(\vec d_{\text{in},\alpha} \cdot \vec d_{\text{out},\beta})\right)
        :label: 3Dmap_lambda_function

  With :math:`N` the number of slip systems for each adjacent grains.

   .. figure:: ./_pictures/schemes_slip_transmission/lambda_fcc-fcc.png
      :name: lambda_fcc_fcc
      :scale: 50 %
      :align: center
      
      *Pseudo-3D view of the lambda map for the FCC-FCC case.*

   .. figure:: ./_pictures/schemes_slip_transmission/lambda_bcc-bcc.png
      :name: lambda_bcc_bcc
      :scale: 50 %
      :align: center
      
      *Pseudo-3D view of the lambda map for the BCC-BCC case.*

  The |matlab| function used to plot pseudo-3D view of the the :math:`\lambda` function is :
  `lambda_plot_values.m <https://github.com/stabix/stabix/tree/master/slip_transfer/plots/lambda_plot_values.m>`_

  This function is modified by Beyerlein et al., using the angle :math:`\theta` between the two slip plane intersections with the grain boundary, instead of using the angle :math:`\psi` between the two 
  slip plane normal directions [#Beyerlein_2012]_.

    .. math:: \lambda = \cos\left(\frac{90°}{\theta_c}\arccos(\vec l_\text{in} \cdot \vec l_\text{out})\right)\cos\left(\frac{90°}{\kappa_c}\arccos(\vec d_\text{in} \cdot \vec d_\text{out})\right)
        :label: lambda_modified_function
        
    .. math:: \lambda = \cos\left(\frac{90° \theta}{\theta_c}\right)\cos\left(\frac{90° \kappa}{\kappa_c}\right)
        :label: lambda_modified_function_ang

  The |matlab| function used to calculate the modified :math:`\lambda` function is :
  `lambda_modified.m <https://github.com/stabix/stabix/tree/master/slip_transfer/lambda_modified.m>`_

Stress Criteria
-----------------
* **Schmid Factor** (:math:`m`) [#Reid_1973]_, [#Seal_2012]_ and [#Abuzaid_2012]_

  The Schmid's law can be expressed by the following equation:
  
    .. math:: \tau^i = \sigma : {S_0}^i
        :label: schmid_factor
        
    .. math:: {S_0}^i = \vec d^i \otimes \vec n^i
        :label: schmid_matrix
  
  :math:`\sigma` is an arbitrary stress state and :math:`\tau^i` the resolved shear stress on slip system :math:`i`.
  :math:`{S_0}^i` is the Schmid matrix defined by the dyadic product of the slip plane normals
  :math:`\vec n` and the slip directions :math:`\vec d` of the slip system :math:`i`.
  The Schmid factor, :math:`m`, is defined as the ratio of the resolved shear stress :math:`\tau^{i}` to a given uniaxial stress.
  
  Knowing the value of the highest Schmid factor of a given slip system for both grains
  in a bicrystal, Abuzaid et al. [#Abuzaid_2012]_ proposed the following criterion :

    .. math:: m_\text{GB} = m_\text{in} + m_\text{out}
        :label: schmid_factor_gb
        
  The subscripts :math:`\text{GB}`, :math:`\text{in}`, and :math:`\text{out}`
  refer to the grain boundary, and the incoming and outgoing slip systems, respectively.
  This GB Schmid factor (:math:`m_\text{GB}`) factor should be maximized.
  
  The |matlab| function used to calculate the Schmid factor is :
  `resolved_shear_stress.m <https://github.com/stabix/stabix/tree/master/crystal_plasticity/resolved_shear_stress.m>`_
  
* **Generalized Schmid Factor** (:math:`GSF`) [#Reid_1973]_ and [#Bieler_2014]_

  The generalized Schmid factor, which describes the shear stress on a given slip system, can be
  computed from any stress tensor :math:`\sigma` based on the Frobenius norm of the tensor.

    .. math:: GSF = \vec d \cdot g \sigma g \cdot \vec n
        :label: generalized_schmid_factor
    
  :math:`\vec n` and :math:`\vec d` are respectively the slip plane normals and the slip directions
  of the slip system. The :math:`g` is the orientation matrix for a given crystal.
        
  The |matlab| function used to calculate the generalized Schmid factor is :
  `generalized_schmid_factor.m <https://github.com/stabix/stabix/tree/master/crystal_plasticity/generalized_schmid_factor.m>`_
        
* **Resolved Shear Stress** (:math:`\tau`) [#Lee_1989]_, [#Lee_1990_1]_, [#Lee_1990_2]_, [#Clark_1992]_, [#Lagow_2001]_, [#Bieler_2009]_,  [#Dewald1_2007]_, [#Dewald2_2007]_ and [#Dewald3_2011]_
  
  The resolved shear stress :math:`\tau` acting on the outgoing slip system from the piled-up dislocations should be maximized.
  This criterion considers the local stress state.
  
  The resolved shear stress on the grain boundary should be minimized.
  
  For Shi and Zikry, the ratio of the resolved shear stress to the reference shear stress of the outgoing slip system
  (stress ratio) should be greater than a critical value (which is approximately 1) [#Shi_2011]_.
  
  For Li et al. and Gao et al. the resolved shear stress acting on the incoming
  dislocation on the slip plane must be larger than the critical penetration stress.
  From the energy point of view, only when the work by the external force on the
  incoming dislocation is greater than the summation of the GB energy
  and strain energy of GB dislocation debris, it is possible that the incoming
  dislocation can penetrate through the GB [#Li_2009]_ and [#Gao_2011]_.
  
  It is possible to assess the shear stress from the geometrical factor :math:`N` (Livingston and Chamlers) :
    
    .. math:: \tau_{\text{in}} = \tau_{\text{out}} * N
        :label: shear_stress_n_factor
    
  Where :math:`\tau_{\text{out}}` is the shear stress at the head of the
  accumulated dislocations in their slip plane and :math:`\tau_{\text{in}}`
  is the shear acting on the incoming slip system [#LivingstonChalmers_1957]_, 
  [#HookHirth_1967_1]_ and [#HookHirth_1967_2]_.
  
  The |matlab| function used to calculate the resolved shear stress is :
  `resolved_shear_stress.m <https://github.com/stabix/stabix/tree/master/crystal_plasticity/resolved_shear_stress.m>`_

Combination of Criteria
-------------------------

* **Geometrical function weighted by the accumulated shear stress or the Schmid factor** [#Bieler_2014]_ :

  Bieler et al. proposed to weight slip transfer parameters by the sum of
  accumulated shear :math:`\gamma` on each slip system, knowing the local stress tensor.
  From a crystal plasticity simulation, the accumulated shear is the total accumulated shear
  on each slip system for a given integration point.
  This leads to the following shear-informed version of a slip transfer parameter:  

    .. math:: m_{\gamma}^{'} = \frac{\sum_{\alpha} \sum_{\beta} m_{\alpha\beta}^{'} \left(\gamma^{\alpha} \gamma^{\beta} \right)}{\sum_{\alpha} \sum_{\beta} \left(\gamma^{\alpha} \gamma^{\beta} \right)}
        :label: shear_weighting_mprime
        
    .. math:: LRB_{\gamma} = \frac{\sum_{\alpha} \sum_{\beta} LRB_{\alpha\beta}^{'} \left(\gamma^{\alpha} \gamma^{\beta} \right)}{\sum_{\alpha} \sum_{\beta} \left(\gamma^{\alpha} \gamma^{\beta} \right)}
        :label: shear_weighting_LRB
        
    .. math:: s_{\gamma} = \frac{\sum_{\alpha} \sum_{\beta} s_{\alpha\beta}^{'} \left(\gamma^{\alpha} \gamma^{\beta} \right)}{\sum_{\alpha} \sum_{\beta} \left(\gamma^{\alpha} \gamma^{\beta} \right)}
        :label: shear_weighting_sum_cosines
        
    .. math:: s = \cos(\psi) \cdot \cos(\kappa) \cdot \cos(\theta)
        :label: sum_cosines
        
  The |matlab| function used to calculate the :math:`s` function is :
  `s_factor.m <https://github.com/stabix/stabix/tree/master/slip_transfer/s_factor.m>`_
        
  Similarly, the :math:`m^{'}` parameter can be weighted using the Schmid factor :math:`m`
  on each slip system as a metric for the magnitude of slip transfer:
        
    .. math:: m_{GSF}^{'} = \frac{\sum_{\alpha} \sum_{\beta} m_{\alpha\beta}^{'} \left(m^{\alpha} m^{\beta} \right)}{\sum_{\alpha} \sum_{\beta} \left(m^{\alpha} m^{\beta} \right)}
        :label: SchmidFactor_weighting_mprime
        
  In 2016, Tsuru et al. proposed a new criterion, based on the :math:`N` factor, for the transferability of dislocations through  a  GB that  considers  both  the intergranular  crystallographic  orientation  of slip systems and the applied stress condition [#Tsuru_2016]_   .
        
Relationships between slip transmission criteria
-----------------------------------------------------------------------

  Some authors proposed to study relationships between slip transmission criteria [#Guo_2014]_ and [#Wang_2016]_.
  Thus, it is possible to find in the litterature the :math:`m'` parameter plotted in function of the Schmid factor or the misorientation angle.
  Such plots based on experimental values allow to map slip transmissivity at grain boundaries for a given material.
		
Slip transmission parameters implemented in the STABiX toolbox
-----------------------------------------------------------------------
.. csv-table::
   :header: "Slip transmission parameter", "Function", "|matlab| function", "Reference"
   :widths: 40, 40, 20, 10

   "Misorientation angle (FCC and BCC materials) (:math:`\omega`)", ":math:`\omega = cos^{-1}((tr(\Delta g)-1)/2)`", `misorientation.m <https://github.com/stabix/stabix/tree/master/crystallo/misorientation.m>`_, [#SuttonBalluffi_1995]_
   "C-axis misorientation angle (HCP material) (:math:`\omega`)", , `c-axis misorientation.m <https://github.com/stabix/stabix/tree/master/crystallo/eul2Caxismisor.m>`_, [#SuttonBalluffi_1995]_
   ":math:`N` factor from Livingston and Chamlers", ":math:`N = \cos(\psi)\cdot\cos(\kappa) + \cos(\gamma)\cdot\cos(\delta)`", `N_factor.m <https://github.com/stabix/stabix/tree/master/slip_transfer/N_factor.m>`_, [#LivingstonChalmers_1957]_
   ":math:`LRB` factor from Shen et al.", ":math:`LRB = \cos(\theta)\cdot\cos(\kappa)`", `LRB_parameter.m <https://github.com/stabix/stabix/tree/master/slip_transfer/LRB_parameter.m>`_, [#Shen_1986]_ / [#Shen_1988]_
   ":math:`m'` parameter from Luster and Morris", ":math:`m' = \cos(\psi)\cdot\cos(\kappa)`", `mprime.m <https://github.com/stabix/stabix/tree/master/slip_transfer/mprime.m>`_, [#LusterMorris_1995]_
   "|rbv| (:math:`\vec b_\text{r}`)", ":math:`\vec b_\text{r} = g_\text{in}\cdot\vec b_\text{in} - g_\text{out}\cdot\vec b_\text{out}`", `residual_Burgers_vector.m <https://github.com/stabix/stabix/tree/master/slip_transfer/residual_Burgers_vector.m>`_, [#Marcinkowski_1970]_
   ":math:`\lambda` function from Werner and Prantl", ":math:`\lambda = \cos(\frac{90° \psi}{\psi_c})\cos(\frac{90° \kappa}{\kappa_c})`", `lambda.m <https://github.com/stabix/stabix/tree/master/slip_transfer/lambda.m>`_, [#Werner_1990]_
   "Resolved Shear Stress (:math:`\tau^{i}`) / Schmid Factor", ":math:`\tau^{i} = \sigma : {S_0}^{i}` with :math:`{S_0}^{i} = d \otimes n`", `resolved_shear_stress.m <https://github.com/stabix/stabix/tree/master/crystal_plasticity/resolved_shear_stress.m>`_, [#Reid_1973]_
   "Grain boundary Schmid factor", ":math:`m_\text{GB} = m_\text{in} + m_\text{out}`", `resolved_shear_stress.m <https://github.com/stabix/stabix/tree/master/crystal_plasticity/resolved_shear_stress.m>`_, [#Abuzaid_2012]_
   "Generalized Schmid Factor (:math:`GSF`)", ":math:`GSF = d \cdot g \sigma g \cdot n`", `generalized_schmid_factor.m <https://github.com/stabix/stabix/tree/master/crystal_plasticity/generalized_schmid_factor.m>`_, [#Reid_1973]_

Slip and twin systems implemented in the STABiX toolbox
--------------------------------------------------------------
* List of slip and twin systems for FCC phase material used in `STABiX <https://github.com/stabix/stabix/blob/master/crystallo/slip_systems.m>`_
  and `DAMASK - FCC <http://damask.mpie.de/Documentation/FCC>`_.
* List of slip and twin systems for BCC phase material used in `STABiX <https://github.com/stabix/stabix/blob/master/crystallo/slip_systems.m>`_
  and `DAMASK - BCC <http://damask.mpie.de/Documentation/BCC>`_.
* List of slip and twin systems for HCP phase material used in `STABiX <https://github.com/stabix/stabix/blob/master/crystallo/slip_systems.m>`_
  and `DAMASK - HCP <http://damask.mpie.de/Documentation/Hex>`_.

References
-----------
.. [#Abuzaid_2012] `W.Z. Abuzaid et al., "Slip transfer and plastic strain accumulation across grain boundaries in Hastelloy X.", J. of the Mech. and Phys. of Sol. (2012), 60(6) ,pp. 1201–1220. <https://www.doi.org/10.1016/j.jmps.2012.02.001>`_
.. [#Ashmawi_2001] `W.M. Ashmawi and M.A. Zikry, "Prediction of Grain-Boundary Interfacial Mechanisms in Polycrystalline Materials.", Journal of Engineering Materials and Technology (2001), 124(1), pp. 88-96. <https://www.doi.org/10.1115/1.1421611>`_
.. [#AustChen_1954] `K.T. Aust and N.K. Chen, "Effect of orientation difference on the plastic deformation of aluminum bicrystals.", Acta Metallurgica (1954), 2, pp. 632-638. <https://www.doi.org/10.1016/0001-6160(54)90199-6>`_
.. [#Aust_1968] `K.T. Aust et al., "Solute induced hardening near grain boundaries in zone refined metals.", Acta Metallurgica (1968), 16(3), pp. 291-302. <https://www.doi.org/10.1016/0001-6160(68)90014-X>`_
.. [#Bachurin_2010] `D.V. Bachurin et al., "Dislocation–grain boundary interaction in <111> textured thin metal films.", Acta Materialia (2010), 58, pp. 5232–5241. <https://www.doi.org/10.1016/j.actamat.2010.05.037>`_
.. [#Bamford_1988] `T.A. Bamford et al., "A thermodynamic model of slip propagation.", Scripta Metallurgica (1988), 22(12), pp. 1911–1916. <https://www.doi.org/10.1016/S0036-9748(88)80237-0>`_
.. [#Bayerschen_2015] `E. Bayerschen et al., "On Slip Transmission Criteria in Experiments and Crystal Plasticity Models.", arXiv:1507.05748 (2015), pp. 1-9. <http://arxiv.org/abs/1507.05748>`_
.. [#Bayerschen_2015_2] `E. Bayerschen et al., "Review on slip transmission criteria in experiments and crystal plasticity models.", J. Mater. Sci. (2015), pp. 1-16. <https://www.doi.org/10.1007/s10853-015-9553-4>`_
.. [#Beyerlein_2012] `I. Beyerlein al., "Structure–Property–Functionality of Bimetal Interfaces.", The Journal of The Minerals, Metals & Materials Society (TMS) (2012), pp. 1192-1207. <https://www.doi.org/10.1007/s11837-012-0431-0>`_
.. [#Bieler_2009] `T.R. Bieler et al., "The role of heterogeneous deformation on damage nucleation at grain boundaries in single phase metals.", Int. J. of Plast. (2009), 25(9), pp. 1655–1683. <https://www.doi.org/10.1016/j.ijplas.2008.09.002>`_
.. [#Bieler_2014] `T.R. Bieler et al., "Grain boundaries and interfaces in slip transfer.", Current Opinion in Solid State and Materials Science, (2014), 18(4), pp. 212-226. <https://www.doi.org/10.1016/j.cossms.2014.05.003>`_
.. [#Bollmann_1970] `W. Bollmann, "Crystal Defects and Crystalline Interfaces", Springer-Verlag (1970) <https://www.doi.org/10.1007/978-3-642-49173-3>`_
.. [#Britton_2009] `T.B. Britton et al., "Nanoindentation study of slip transfer phenomenon at grain boundaries.", J. Mater. Res., (2009), 24(3), pp. 607-615. <https://www.doi.org/10.1557/jmr.2009.0088>`_
.. [#Britton_2012] `T.B. Britton and A.J. Wilkinson, "Stress fields and geometrically necessary dislocation density distributions near the head of a blocked slip band.", Acta Materialia (2012), 60, pp. 5773–5782. <https://www.doi.org/10.1016/j.actamat.2012.07.004>`_
.. [#ClarkChalmers_1954] `W.A.T. Clark and B. Chalmers, "Mechanical deformation of aluminium bicrystals.", Acta Metallurgica (1954), 2(1), pp. 80-86. <https://www.doi.org/10.1016/0001-6160(54)90097-8>`_
.. [#Clark_1989] `W.A.T. Clark et al., "The use of the transmission electron microscope in analyzing slip propagation across interfaces.", Ultramicroscopy (1989), 30(1-2), pp. 76-89. <https://www.doi.org/10.1016/0304-3991(89)90175-7>`_
.. [#Clark_1992] `W.A.T. Clark et al., "On the criteria for slip transmission across interfaces in polycrystals.", Scripta Metallurgica et Materialia (1992), 26(2), pp. 203–206. <https://www.doi.org/10.1016/0956-716X(92)90173-C>`_
.. [#Cui_2014] `B. Cui et al., "Influence of irradiation damage on slip transfer across grain boundaries.", Acta Materialia (2014), 65, pp. 150-160. <https://www.doi.org/10.1016/j.actamat.2013.11.033>`_
.. [#Davis_1966] `K.G. Davis et al., "Slip band continuity across grain boundaries in aluminum.", Acta Metallurgica (1966), 14, pp. 1677-1684. <https://www.doi.org/10.1016/0001-6160(66)90020-4>`_
.. [#DeKoning_2002] `M. DeKoning et al., "Modelling grain-boundary resistance in intergranular dislocation slip transmission.", Phil. Mag. A (2002), 82(13), pp. 2511-2527. <https://www.doi.org/10.1080 /0141861021014442 1>`_
.. [#DeKoning_2003] `M. DeKoning et al., "Modeling of dislocation–grain boundary interactions in FCC metals.", Journal of Nuclear Materials (2003), 323, pp. 281–289. <https://www.doi.org/10.1016/j.jnucmat.2003.08.008>`_
.. [#Dewald1_2007] `M.P. Dewald et al., "Multiscale modelling of dislocation/grain-boundary interactions: I. Edge dislocations impinging on Σ11 (1 1 3) tilt boundary in Al.", Modelling Simul. Mater. Sci. Eng. (2007), 15(1). <https://www.doi.org/10.1088/0965-0393/15/1/S16>`_
.. [#Dewald2_2007] `M.P. Dewald et al., "Multiscale modelling of dislocation/grain boundary interactions. II. Screw dislocations impinging on tilt boundaries in Al.", Phil. Mag. (2007), 87(30), pp. 1655–1683. <https://www.doi.org/10.1080/14786430701297590>`_
.. [#Dewald3_2011] `M.P. Dewald et al., "Multiscale modeling of dislocation/grain-boundary interactions: III. 60° dislocations impinging on Σ3, Σ9 and Σ11 tilt boundaries in Al.", Modelling Simul. Mater. Sci. Eng. (2011), 19(5). <https://www.doi.org/10.1088/0965-0393/19/5/055002>`_
.. [#Eshelby_1951] `J.D. Eshelby et al., "XLI. The equilibrium of linear arrays of dislocations.", Philosophical Magazine Series 7 (1951), 42(327), pp. 351-365. <https://www.doi.org/10.1080/14786445108561060>`_
.. [#Faraoun_2006] `H. Faraoun et al., "Study of stability of twist grain boundaries in hcp zinc.", Scripta Materialia (2006), 54, pp. 865–868. <https://www.doi.org/10.1016/j.scriptamat.2005.11.008>`_
.. [#Gao_2011] `Y. Gao et al., "A hierarchical dislocation-grain boundary interaction model based on 3D discrete dislocation dynamics and molecular dynamics." Science China Physics, Mechanics and Astronomy (2011), 54(4), pp. 625-632. <https://www.doi.org/10.1007/s11433-011-4298-9>`_
.. [#Gemperle_2004] `A. Gemperle et al., "Interaction of slip dislocations with grain boundaries in body-centered cubic bicrystals.", Materials Science and Engineering A (2004), 378-389, pp. 46-50. <https://www.doi.org/10.1016/j.msea.2004.03.081>`_
.. [#Gemperlova_2004] `J. Gemperlova et al., "Slip transfer across grain boundaries in Fe–Si bicrystals.", Journal of Alloys and Compounds (2004), 378(1-2), pp. 97-101. <https://www.doi.org/10.1016/j.jallcom.2003.10.086>`_
.. [#Guo_2014] `Y. Guo et al., "Slip band–grain boundary interactions in commercial-purity titanium.", Acta Materialia (2014), 76, pp. 1-12. <https://www.doi.org/10.1016/j.actamat.2014.05.015>`_
.. [#Guo_2015] `Y. Guo et al., "Measurements of stress fields near a grain boundary: Exploring blocked arrays of dislocations in 3D.", Acta Materialia (2015), 96, pp. 229-236. <https://www.doi.org/10.1016/j.actamat.2015.05.041>`_
.. [#HauserChamlers_1961] `J.J. Hauser and B. Chamlers, "The plastic deformation of bicrystals of f.c.c. metals.", Acta Metallurgica (1961), 9(9), pp. 802-818. <https://www.doi.org/10.1016/0001-6160(61)90183-3>`_
.. [#Herbert_2011] `F.W. Herbert et al., "Nanoindentation Induced Deformation Near Grain Boundaries of Corrosion Resistant Nickel Alloys.", Mater. Res. Soc. Symp. Proc., (2011), 1297. <https://www.doi.org/10.1557/opl.2011>`_
.. [#HookHirth_1967_1] `R.E. Hook and J.P. Hirth, "The deformation behavior of isoaxial bicrystals of Fe-3%Si.", Acta Metallurgica (1967), 15(3), pp. 535-551. <https://www.doi.org/10.1016/0001-6160(67)90087-9>`_
.. [#HookHirth_1967_2] `R.E. Hook and J.P. Hirth, "The deformation behavior of non-isoaxial bicrystals of Fe-3% Si.", Acta Metallurgica (1967), 15(7), pp. 1099-1110. <https://www.doi.org/10.1016/0001-6160(67)90383-5>`_
.. [#Hunter_2017] `A. Hunter et al., "A review of slip transfer: applications of mesoscale techniques.", Journal of Materials Science (2017), pp. 1-20. <https://www.doi.org/10.1007/s10853-017-1844-5>`_
.. [#Jacques_1990] `A. Jacques et al., "New results on dislocation transmission by grain boundaries in elemental semiconductors.", Le Journal de Physique Colloques (1990), 51(C1), pp. 531-536. <https://www.doi.org/10.1051/jphyscol:1990183>`_
.. [#KacherRobertson_2012] `J. Kacher and I.M. Robertson, "Quasi-four-dimensional analysis of dislocation interactions with grain boundaries in 304 stainless steel.", Acta Materialia (2012), 60(19), pp. 6657–6672. <https://www.doi.org/10.1016/j.actamat.2012.08.036>`_
.. [#KacherRobertson_2014] `J. Kacher and I.M. Robertson, "In situ and tomographic analysis of dislocation/grain boundary interactions in α-titanium.", Philosophical Magazine (2014), 94(8), pp. 814-829. <https://www.doi.org/10.1080/14786435.2013.868942>`_
.. [#Kacher_2014] `J. Kacher et al., "Dislocation interactions with grain boundaries.", Current Opinion in Solid State and Materials Science, (2014), 18(4), pp. 227-243. <https://www.doi.org/10.1016/j.cossms.2014.05.004>`_
.. [#Kalidindi_2014] `S.R. Kalidindi and S.J. Vachhani, "Mechanical characterization of grain boundaries using nanoindentation.", Current Opinion in Solid State and Materials Science, (2014), 18(4), pp. 196–204. <https://www.doi.org/10.1016/j.cossms.2014.05.002>`_
.. [#Kehagias_1995] `T. Kehagias et al., "Slip transfer across low-angle grain boundaries of deformed titanium.", Interface Science (1995), 3(3), pp. 195-201. <https://www.doi.org/10.1007/BF00191046>`_
.. [#Kehagias_1996] `T. Kehagias et al., "Pyramidal Slip in Electron Beam Heated Deformed Titanium.", Scripta Metallurgica et Materialia (1996), 33(12), pp. 1883-1888. <https://www.doi.org/10.1016/0956-716X(95)00351-U>`_
.. [#Kobayashi_2005] `S. Kobayashi et al., "Grain boundary hardening and triple junction hardening in polycrystalline molybdenum.", Acta Materialia (2005), 53, pp. 1051–1057. <https://www.doi.org/10.1016/j.actamat.2004.11.002>`_
.. [#Lagow_2001] `B.W. Lagow, "Observation of dislocation dynamics in the electron microscope.", Materials Science and Engineering: A, 2001, 309–310, pp. 445-450. <https://www.doi.org/10.1016/S0921-5093(00)01699-3>`_
.. [#Lawrence_2014] `S.K. Lawrence et al., "Grain Boundary Contributions to Hydrogen-Affected Plasticity in Ni-201.", The Journal of The Minerals, Metals & Materials Society (2014), 66(8), pp. 1383-1389. <https://www.doi.org/10.1007/s11837-014-1062-4>`_
.. [#Lee_1989] `T.C. Lee et al., "Prediction of slip transfer mechanisms across grain boundaries.", Scripta Metallurgica, (1989), 23(5), pp. 799–803. <https://www.doi.org/10.1016/0036-9748(89)90534-6>`_
.. [#Lee_1990_1] `T.C. Lee et al., "TEM in situ deformation study of the interaction of lattice dislocations with grain boundaries in metals.", Philosophical Magazine A (1990), 62(1), pp. 131-153. <https://www.doi.org/10.1080/01418619008244340>`_
.. [#Lee_1990_2] `T.C. Lee et al., "An In Situ transmission electron microscope deformation study of the slip transfer mechanisms in metals", Metallurgical Transactions A (1990), 21(9), pp. 2437-2447. <https://www.doi.org/10.1007/BF02646988>`_
.. [#Li_2009] `Z. Li et al., "Strengthening mechanism in micro-polycrystals with penetrable grain boundaries by discrete dislocation dynamics simulation and Hall–Petch effect.", Computational Materials Science (2009), 46(4), pp. 1124-1134. <https://www.doi.org/10.1016/j.commatsci.2009.05.021>`_
.. [#LimRaj_1985_1] `L.C. Lim and R. Raj, "Continuity of slip screw and mixed crystal dislocations across bicrystals of nickel at 573K.", Acta Metallurgica (1985), 33, pp. 1577. <https://www.doi.org/10.1016/0001-6160(85)90057-4>`_
.. [#LimRaj_1985_2] `L.C. Lim and R. Raj, "The role of residual dislocation arrays in slip induced cavitation, migration and dynamic recrystallization at grain boundaries.", Acta Metallurgica (1985), 33(12), pp. 2205-2214. <https://www.doi.org/10.1016/0001-6160(85)90182-8>`_
.. [#LivingstonChalmers_1957] `J.D. Livingston and B. Chalmers, "Multiple slip in bicrystal deformation.", Acta Metallurgica (1957), 5(6), pp. 322-327. <https://www.doi.org/10.1016/0001-6160(57)90044-5>`_
.. [#LusterMorris_1995] `J. Luster and M.A. Morris, "Compatibility of deformation in two-phase Ti-Al alloys: Dependence on microstructure and orientation relationships.", Metal. and Mat. Trans. A (1995), 26(7), pp. 1745-1756. <https://www.doi.org/10.1007/BF02670762>`_
.. [#Ma_2006] `A. Ma et al., "On the consideration of interactions between dislocations and grain boundaries in crystal plasticity finite element modeling – Theory, experiments, and simulations.", Acta Materialia (2006), 54(8), pp.2181-2194. <https://www.doi.org/10.1016/j.actamat.2006.01.004>`_
.. [#Marcinkowski_1970] `M.J. Marcinkowski and W.F. Tseng, "Dislocation behavior at tilt boundaries of infinite extent.", Metal. Trans. (1970), 1(12), pp. 3397-3401. <https://www.doi.org/10.1007/BF03037870>`_
.. [#MisraGibala_1999] `A. Misra and R. Gibala, "Slip Transfer and Dislocation Nucleation Processes in Multiphase Ordered Ni-Fe-Al Alloys", Metallurgical and Materials Trans. A (1999), 30A, pp. 991-1001. <https://www.doi.org/10.1007/s11661-999-0152-3>`_
.. [#Nervo_2016] `L. Nervo et al., "A study of deformation twinning in a titanium alloy by X-ray diffraction contrast tomography", Acta Materialia (2016), 105, pp. 417-428. <https://www.doi.org/10.1016/j.actamat.2015.12.032>`_
.. [#Nibur_2003] `K.A. Nibur and D.F. Bahr, "Indentation Techniques for the Study of Deformation Across Grain Boundaries.", Mat. Res. Soc. Symp. Proc. (2003), 778, pp. 129-134. <https://www.doi.org/10.1557/PROC-778-U4.10>`_
.. [#Ohmura_2005] `T. Ohmura et al., "Nanoindentation-Induced Deformation Behavior in the Vicinity of Single Grain Boundary of Interstitial-Free Steel.", Materials Transactions (2005), 46(9), pp. 2026-2029. <https://www.doi.org/10.2320/matertrans.46.2026>`_
.. [#Pathak_2009] `S. Pathak et al., "Measurement of the local mechanical properties in polycrystalline samples using spherical nanoindentation and orientation imaging microscopy.", Acta Materialia (2009), 57, pp. 3020–3028. <https://www.doi.org/10.1016/j.actamat.2009.03.008>`_
.. [#Pathak_2012] `S. Pathak et al., "Studying grain boundary regions in polycrystalline materials using spherical nano-indentation and orientation imaging microscopy.", J. Mater. Sci. (2012), 47, pp. 815–823. <https://www.doi.org/10.1007/s10853-011-5859-z>`_
.. [#Patriarca_2013] `L. Patriarca et al., "Slip transmission in bcc FeCr polycrystal.", Materials Science&Engineering (2013), A588, pp. 308–317. <https://www.doi.org/10.1016/j.msea.2013.08.050>`_
.. [#Pond_1986] `R.C. Pond et al., "On the crystallography of slip transmission in hexagonal metals.", Scripta Metallurgica (1986), 20, pp. 1291-1295. <https://www.doi.org/10.1016/0036-9748(86)90051-7>`_
.. [#Priester_2013] `L. Priester, "Grain Boundaries: From Theory to Engineering.", Springer Series in Materials Science (2013). <http://www.springer.com/materials/surfaces+interfaces/book/978-94-007-4968-9>`_
.. [#ReadShockley_1950] `W.T. Read and W. Shockley, "Dislocation Models of Crystal Grain Boundaries.", Physical Review, 1950, 78(3), pp. 275-289. <https://www.doi.org/10.1103/PhysRev.78.275>`_
.. [#Reid_1973] `C.N. Reid, "Deformation Geometry for Materials Scientists.", Pergamon Press, Oxford, United Kingdom, 1973. <http://www.sciencedirect.com/science/book/9780080172378>`_
.. [#Sangid_2011] `M.D. Sangid et al., "Energy of slip transmission and nucleation at grain boundaries.", Acta Materialia (2011), 59(1), pp. 283–296. <https://www.doi.org/10.1016/j.actamat.2010.09.032>`_
.. [#Sangid_2012] `M.D. Sangid et al., "Energetics of residual dislocations associated with slip–twin and slip–GBs interactions.", Materials Science and Engineering A (2012), 542, pp. 21–30. <https://www.doi.org/10.1016/j.msea.2012.02.023>`_
.. [#Seal_2012] `J.R. Seal et al., "Analysis of slip transfer and deformation behavior across the α/β interface in Ti–5Al–2.5Sn (wt.%) with an equiaxed microstructure.", Mater. Sc. and Eng.: A (2012), 552, pp. 61-68. <https://www.doi.org/10.1016/j.msea.2012.04.114>`_
.. [#Shan_2013] `D. Shan et al., "Effect of the Σ5(310)/[001]Φ 5 53.1° grain boundary on the incipient yield of bicrystal copper: A quasicontinuum simulation and nanoindentation experiment.", J. Mater. Res. (2013), 28(5), pp. 766-773. <https://www.doi.org/10.1557/jmr.2012.424>`_
.. [#Shen_1986] `Z. Shen et al., "Dislocation pile-up and grain boundary interactions in 304 stainless steel.", Scripta Metallurgica (1986), 20(6), pp. 921–926. <https://www.doi.org/10.1016/0036-9748(86)90467-9>`_
.. [#Shen_1988] `Z. Shen et al., "Dislocation and grain boundary interactions in metals.", Acta Metallurgica (1988), 36(12), pp. 3231–3242. <https://www.doi.org/10.1016/0001-6160(88)90058-2>`_
.. [#Shi_2011] `J. Shi and M.A. Zikry, "Modeling of grain boundary transmission, emission, absorption and overall crystalline behavior in Σ1, Σ3, and Σ17b bicrystals.", J. Mater. Res., (2011), 26(14), pp. 1676-1687. <https://www.doi.org/10.1557/jmr.2011.192>`_
.. [#Shirokoff_1993] `J. Shirokoff et al., "The Slip Transfer Process Through Grain Boundaries in HCP Ti.", MRS Online Proceedings Library (1993), 319, pp. 263-272. <https://www.doi.org/10.1557/PROC-319-263>`_
.. [#Soer_2005] `W.A. Soer et al. ,"Incipient plasticity during nanoindentation at grain boundaries in body-centered cubic metals.", Acta Materialia (2005), 53, pp. 4665–4676. <https://www.doi.org/10.1016/j.actamat.2005.07.001>`_
.. [#SoerDeHosson_2005] `W.A. Soer and J.Th.M. De Hosson, "Detection of grain-boundary resistance to slip transfer using nanoindentation.", Materials Letters (2005), 59, pp. 3192–3195. <https://www.doi.org/10.1016/j.matlet.2005.03.075>`_
.. [#Soifer_2002] `Y.M. Soifer et al., "Nanohardness of copper in the vicinity of grain boundaries.", Scripta Materialia (2002), 47(12), pp. 799-804. <https://www.doi.org/10.1016/S1359-6462(02)00284-1>`_
.. [#SpearotSangid_2014] `D.E. Spearot and M.D. Sangid, "Insights on slip transmission at grain boundaries from atomistic simulations.", Current Opinion in Solid State and Materials Science (2014), in press. <https://www.doi.org/10.1016/j.cossms.2014.04.001>`_
.. [#SuttonBalluffi_1995] `A.P. Sutton and R.W. Balluffi, "Interfaces in Crystalline Materials.", OUP Oxford (1995). <https://www.doi.org/10.1007/s100080050033>`_
.. [#Tsurekawa_2014] `S. Tsurekawa et al., "Local plastic deformation in the vicinity of grain boundaries in Fe–3 mass% Si alloy bicrystals and tricrystal.", J. Mater. Sci., (2014), 49(14), pp. 4698–4704. <https://www.doi.org/10.1007/s10853-014-8150-2>`_
.. [#Tsuru_2016] `T. Tsuru et al., "A predictive model for transferability of plastic deformation through grain boundaries.", AIP ADVANCES, (2016), 6(015004). <https://www.doi.org/10.1063/1.4939819>`_
.. [#Ueda_2002] `M. Ueda et al., "Effect of grain boundary on martensite transformation behaviour in Fe–32 at.%Ni bicrystals.", Science and Technology of Advanced Materials (2002), 3(2), pp. 171. <https://www.doi.org/10.1016/S1468-6996(02)00004-9>`_
.. [#Wang_2014] `Wang F. et al., "In situ observation of collective grain-scale mechanics in Mg and Mg–rare earth alloys.", Acta Materialia, (2014), 80, pp. 77–93. <https://www.doi.org/10.1016/j.actamat.2014.07.048>`_
.. [#Wang_2016] `Wang H. et al., "In situ analysis of the slip activity during tensile deformation of cast and extruded Mg-10Gd-3Y-0.Zr(wt.%) at 250°C", Materials characterization, (2016), 116, pp. 8-17. <https://www.doi.org/10.1016/j.matchar.2016.04.001>`_
.. [#WangNgan_2004] `M.G. Wang and A.H.W. Ngan, "Indentation strain burst phenomenon induced by grain boundaries in niobium.", Journal of Materials Research (2004), 19(08), pp. 2478-2486. <https://www.doi.org/10.1557/JMR.2004.0316>`_
.. [#Werner_1990] `E. Werner and W. Prantl, "Slip transfer across grain and phase boundaries.", Acta Metallurgica et Materialia (1990), 38(3), pp. 533-537. <https://www.doi.org/10.1016/0956-7151(90)90159-E>`_
.. [#WestWas_2013] `E.A. West and G.S. Was, "Strain incompatibilities and their role in intergranular cracking of irradiated 316L stainless steel.", J. of Nucl. Mater. (2013), 441(1-3), pp. 623–632. <https://www.doi.org/10.1016/j.jnucmat.2012.10.021>`_
.. [#WoNgan_2004] `P.C. Wo and A.H.W. Ngan, "Investigation of slip transmission behavior across grain boundaries in polycrystalline Ni3Al using nanoindentation.", J. Mater. Res. (2004), 19(1), pp. 189-201. <https://www.doi.org/10.1557/jmr.2004.19.1.189>`_
.. [#Zaefferer_2003] `S. Zaefferer et al., "On the influence of the grain boundary misorientation on the plastic deformation of aluminum bicrystals.", Acta Materialia (2003), 51(16), pp. 4719-4735. <https://www.doi.org/10.1016/S1359-6454(03)00259-3>`_
