STABiX applications and examples
================================

STABiX supports workflows for studying crystallographic slip and its
interaction with grain boundaries. The examples below illustrate practical
ways to use the toolbox and point to related research. Tutorial videos show
hands-on workflows; the papers are research context and should not be read as
evidence that STABiX was used in their analyses.

Related research
----------------

The following papers cite the original STABiX toolbox publication,
`A Matlab toolbox to analyze slip transfer through grain boundaries
<https://doi.org/10.1088/1757-899X/82/1/012090>`_. They address related
microstructure and crystal-plasticity problems, but their abstracts describe
their own methods; the citations alone do not establish that STABiX was used
to produce their results.

Tutorials
---------

Importing EBSD experimental data
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

`How to Use STABIX for Slip Analysis Transmission from EBSD Experimental Data
<https://www.youtube.com/watch?v=TMAbw3VZofI>`_ walks through importing EBSD
data into STABiX and preparing it for slip-transmission analysis. The video
also discusses a MATLAB indexing error encountered during the workflow. For
the supported import routes and file requirements, see :doc:`experimental_data`.
The documentation describes importing EBSD data through MTEX or using the
TSL-OIM grain and reconstructed-boundary files.

Statistical slip-trace analysis at grain boundaries
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

`Slip Trace Analysis Using Stabix, Mtex and Matlab from EBSD Data
<https://www.youtube.com/watch?v=zn53WGQSmXs>`_ demonstrates statistical slip
trace analysis at grain boundaries using STABiX, MTEX, and MATLAB. This is a
practical example of combining EBSD-derived crystallographic information with
slip-trace observations to examine slip activity in relation to grain
boundaries.

Other academic research
~~~~~~~~~~~~~~~~~~~~~~~

Fatigue indicator parameters and interpretable machine learning
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

`Interpretable machine learning for microstructure-dependent models of fatigue
indicator parameters <https://doi.org/10.1016/j.ijfatigue.2023.108019>`_
(Hansen, Whelan, and Hochhalter, *International Journal of Fatigue*, 2024)
develops interpretable machine-learning models for fatigue indicator
parameters that depend on microstructure. It cites the STABiX toolbox paper,
making it useful related reading on microstructure-sensitive deformation;
the paper's described focus is fatigue modeling, not a documented STABiX
workflow.

Nanoindentation-based parameter identification for BCC metals
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

`Application of a nanoindentation-based approach for parameter identification
to a crystal plasticity model for bcc metals
<https://doi.org/10.1016/j.msea.2023.145373>`_ (Gallardo-Basile et al.,
*Materials Science and Engineering: A*, 2023) presents an inverse approach to
identify crystal-plasticity parameters from nanoindentation, supported by
micropillar-compression data. It also cites the STABiX toolbox paper. This is
relevant context for crystal-plasticity and crystallographic slip analysis,
but it is not presented here as an example of STABiX being used directly.