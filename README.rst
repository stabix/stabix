A MATLAB toolbox to analyze slip transfer through grain boundaries
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Current toolbox version: **3.0**.

To get started with STABiX, clone the repository, start MATLAB, and change to the folder containing this README file. Add the toolbox folders to the MATLAB search path by running ``path_management``.
Then start the launcher by typing ``demo`` at the MATLAB command prompt.
See the full documentation at https://stabix.readthedocs.io/en/latest/.

Python example
==============

The `python/ <python/>`_ folder contains a standalone EBSD map example that colors
grain boundaries by maximum Luster-Morris m-prime, with a synthetic demo and
cubic-phase CTF input. Its notebook imports reconstructed Ti-alloy GF2/RB data
with HCP/BCC slip systems. See `the Python instructions <python/README.md>`_.


Authors
========

:Author: `David Mercier <mailto:david9684@gmail.com>`_ [1] and C. Zambaldi [1], based on previous work of T. R. Bieler [2] and C. Zambaldi [1].

[1] `Max-Planck-Institut für Eisenforschung, 40237 Düsseldorf, Germany <http://www.mpie.de/>`_

[2] `Chemical Engineering and Materials Science, Michigan State University, East Lansing 48824 MI, USA <http://www.msu.edu/>`_

How to cite STABiX in your papers?
====================================

`"STABiX v1.6" <https://doi.org/10.5281/zenodo.14854>`_ = https://doi.org/10.5281/zenodo.14854

`"STABiX v2.0" <https://dx.doi.org/10.13140/RG.2.2.25845.83687/2>`_ = https://dx.doi.org/10.13140/RG.2.2.25845.83687/2

Reference paper
================

`"STABiX documentation." <https://stabix.readthedocs.io/en/latest/>`_

`"A Matlab toolbox to analyze slip transfer through grain boundaries" <http://dx.doi.org/10.1088/1757-899X/82/1/012090>`_
D. Mercier, C. Zambaldi, T. R. Bieler, 17th International Conference on Textures of Materials (ICOTOM17), at Dresden, Germany (2014).
IOP Conference Series: Materials Science and Engineering Volume 82 conference 1.
http://dx.doi.org/10.1088/1757-899X/82/1/012090

`"Spherical indentation and crystal plasticity modeling near grain boundaries in alpha-Ti." <http://dx.doi.org/10.13140/RG.2.1.3044.8486>`_
D. Mercier, C. Zambaldi, P. Eisenlohr, Y. Su, M. A. Crimp, T. R. Bieler,
Poster presented at "Indentation 2014" Conference in Strasbourg (France) (December 2014).
http://dx.doi.org/10.13140/RG.2.1.3044.8486

`"Study of Bi-Crystal Grain Boundary Deformation in Commercially Pure Tantalum." <http://dx.doi.org/10.13140/RG.2.2.30343.91049>`_
B. Dunlap et al., CHEMS Forum (2015).

`"Grain Boundaries and Plasticity." <http://dx.doi.org/10.13140/RG.2.2.27427.66084>`_
D. Mercier, C. Zambaldi, P. Eisenlohr, M. A. Crimp, T. R. Bieler, R. Sánchez Martín.
Invited talk at "MTEX Workshop 2016" Conference in Chemnitz (Germany) (February 2016).
http://dx.doi.org/10.13140/RG.2.2.27427.66084

`"Quantifying deformation processes near grain boundaries in α titanium using nanoindentation and crystal plasticity modeling." <http://dx.doi.org/10.1016/j.ijplas.2016.08.007>`_
Y. Su, C. Zambaldi, D. Mercier, P. Eisenlohr, T.R. Bieler, M.A. Crimp, International Journal of Plasticity, (2016).
http://dx.doi.org/10.1016/j.ijplas.2016.08.007

`"Micromechanics of magnesium and its alloys studied by nanoindentation." <http://hdl.handle.net/10016/24981>`_
R. Sánchez Martín, PhD thesis, Universidad Carlos III de Madrid (2017).

`"Investigation of single crystal and bi-crystal deformation in body-centered cubic tantalum using indentation." <https://search.proquest.com/openview/b91c4b357cd85972c6c9b5be34ba9688/1?pq-origsite=gscholar&cbl=18750&diss=y>`_
B. Dunlap, PhD thesis, Michigan State University (2018).

Contributors
=============

- Raúl Sánchez Martín (`IMDEA <https://materials.imdea.org/>`_, Madrid, Spain) contributed Python code to generate *Abaqus* indentation models.
- Adrien Berger (`LML <http://mecanique.univ-lille1.fr/Recherche/LML/>`_, Lille, France) contributed the residual Burgers vector calculation.

Acknowledgements
=================

Parts of this work were supported under the NSF/DFG Materials World Network program (DFG ZA 523/3-1 and NSF-DMR-1108211). We also acknowledge useful discussions with Y. Su, P. Eisenlohr and M. Crimp from Michigan State University.


Keywords
=========

MATLAB; Graphical User Interface (GUI); Grain Boundaries; Polycrystalline Metals; Slip Transmission; Bi-Crystal (BX);
Electron backscatter diffraction (EBSD); Instrumented indentation; Crystal Plasticity Finite Element Method (CPFEM); Python toolbox.
