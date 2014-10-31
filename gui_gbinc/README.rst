A Matlab toolbox to analyze grain boundary inclination from SEM images
======================================================================

.. figure:: ./_pictures/download.png
   :scale: 20 %
   :align: left
   :target: https://github.com/stabix/stabix
   
`Source code is hosted at Github <https://github.com/stabix/stabix/gui_gbinc>`_.

This toolbox helps to find the grain boundary inclination from two micrographs from serial polishing.
At least three marks such as microindents are needed for registration of the images. 

To get started with gbinc toolbox, clone the repository, then run Matlab, and cd into the folder containing this README file. Then add the package path to the Matlab search path by typing "path_management".
Finally you can start the launcher by typing "demo" or "A_gui_gbinc" at the Matlab command prompt.

How to use the toolbox ?
------------------------
1) Run the function "A_gui_gbinc.m".
2) Select your first image before serial polishing.
3) Do the calibration to get the factor scale.
4) Do the edge detection.
5) Repeat the same operation for the second image obtained after serial polishing.
6) Do the overlay.
    If control points don't exist (it's the case for the 1st time), a window appears 
    and it is possible to define control points. You have to define 3 control points per images.
    You have to select a point on the figure on the left, then on the figure on the right, and repeat this operation 2 times.
    You can close the window for the selection of control points (Ctrl+W).
    Control points are saved in .mat file (in the same folder than the 1st picture loaded).
7) Save the overlay (see Figure 1) in the same folder than the 1st picture loaded (as a screenshot - .png) (optional).
8) Do the measurement of the distance between edges or rigdes (select before if edge or ridge) of a unique Vickers indent.
9) Do the measurement of the distance between edges of a unique grain boundary.
10) The value of the grain boundary inclination is finally given.

.. figure:: ./_pictures/GUIs/gui_gb_inc.png
   :scale: 50 %
   :align: center
   
   *Figure 1 : Screenshot of the GUI with the overlay after edge detection.*

N.B.: Distances and grain boundary inclination values are obtained with the mean scale factor of the two images...

Reference paper
---------------
`V. Randle, "A methodology for grain boundary plane assessment by single-section trace analysis.", Scripta Mater., 2001, 44, pp. 2789-2794. <http://dx.doi.org/10.1016/S1359-6462(01)00975-7>`_ 

Links
-----
- `Matlab - Control Point Selection Tool <http://www.mathworks.fr/help/images/ref/cpselect.html>`_
- `Matlab - Spatial transformation from control point pairs <http://www.mathworks.fr/help/images/ref/cp2tform.html>`_
- `Matlab - Edge detection <http://www.mathworks.fr/help/images/ref/edge.html>`_
- `Matlab - Distance tool <http://www.mathworks.fr/help/images/ref/imdistline.html>`_

Authors
-------
Written by D. Mercier [1] and C. Zambaldi [1].

[1] Max-Planck-Institut für Eisenforschung, 40237 Düsseldorf, Germany

Acknowledgements
-----------------
Parts of this work were supported under the NSF/DFG Materials World Network program (DFG ZA 523/3-1 and NSF-DMR-1108211).

Keywords
--------
Matlab; Graphical User Interface (GUI); Grain Boundaries; Polycrystalline Metals; Grain Boundary Inclination; Serial Polishing;
Scanning electron microscope (SEM).