A Matlab toolbox to analyze grain boundary inclination from SEM images
======================================================================

This toolbox helps to find the grain boundary inclination from two micrographs from serial polishing.
At least three marks such as microindents are needed for registration of the images. 

To get started with gbinc toolbox, clone the repository, then run Matlab, and cd into the folder containing this README file. Then add the package path to the Matlab search path by typing "path_management".
Finally you can start the launcher by typing "demo" at the Matlab command prompt.

Authors
-------
Written by D. Mercier [1] and C. Zambaldi [1].

[1] Max-Planck-Institut für Eisenforschung, 40237 Düsseldorf, Germany

Acknowledgements
-----------------
Parts of this work were supported under the NSF/DFG Materials World Network program (DFG ZA 523/3-1 and NSF-DMR-1108211). We also acknowledge useful discussions with Y. Su, P. Eisenlohr and M. Crimp from the Michigan State University.

Keywords
--------
Matlab; Graphical User Interface (GUI); Grain Boundaries; Polycrystalline Metals; Grain Boundary Inclination; Serial Polishing;
Scanning electron microscope (SEM).

How to use the toolbox ?
------------------------
1) Run the function demo.m
2) Select your first image before serial polishing
3) Do the calibration to get the factor scale.
4) Do the edge detection
5) Repeat the same operation for the second image obtained after serial polishing.
6) Do the overlay
If control points don't exist (it's the case for the 1st time you do it for a couple of measurement), a window appear 
and it is possible to define control point. You have to define 3 control points.
You have to select a point on the figure on lhe left, then on the figure on the right and repeat this 2 times more.
You can close the window for the selection of control points (Ctrl+W).
7) Save the obtained overlay (as a screenshot) (optional).
8) Do the measurement of the distance between edges or rigdes (select before if edge or ridge) of a unique Vickers indent.
9) Do the measurement of the distance between edges of a unique grain boundary.
10) The value of the grain boundary inclination is finally given.

.. figure:: ./sem_pictures_serial_polishing/cpTi_before_polishing.tif_cpTi_post_polishing.tif.mat.png"
   :scale: 50 %
   :align: center
   
   *Figure 1 : Screenshot of the gUI with the overlay after edge detection.*

N.B.: Distances and grain boundary inclination values are obtained with the mean scale factor of the two images...

Reference paper
---------------
`V. Randle, "A methodology for grain boundary plane assessment by single-section trace analysis.", Scripta Mater., 2001, 44, pp. 2789-2794. <http://dx.doi.org/10.1016/S1359-6462(01)00975-7>`_ 

Links
-----
`Matlab - Control Point Selection Tool <http://www.mathworks.fr/help/images/ref/cpselect.html>`_
`Matlab - Spatial transformation from control point pairs <http://www.mathworks.fr/help/images/ref/cp2tform.html>`_
`Matlab - Edge detection <http://www.mathworks.fr/help/images/ref/edge.html>`_
`Matlab - Distance tool <http://www.mathworks.fr/help/images/ref/imdistline.html>`_