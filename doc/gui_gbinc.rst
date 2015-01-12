A Matlab toolbox to analyze grain boundary inclination from SEM images
======================================================================

.. include:: includes.rst

.. include:: source_code.rst

This toolbox helps to find the grain boundary inclination from two micrographs from serial polishing.
At least three marks such as microindents are needed for registration of the images. 

Examples of `micrographs from serial polishing. <https://github.com/stabix/stabix/tree/master/gui_gbinc/sem_pictures_serial_polishing>`_

To get started with gbinc toolbox, clone the repository, then run Matlab, and cd into the folder containing this README file. Then add the package path to the Matlab search path by typing "path_management".
Finally you can start the launcher by typing `demo <https://github.com/stabix/stabix/blob/master/demo.m>`_ or `A_gui_gbinc <https://github.com/stabix/stabix/blob/master/gui_gbinc/A_gui_gbinc.m>`_ at the Matlab command prompt.

How to use the toolbox ?
------------------------
1) Run the function `A_gui_gbinc.m. <https://github.com/stabix/stabix/blob/master/gui_gbinc/A_gui_gbinc.m>`_
2) Select your first image before serial polishing.
3) Do the calibration to get the factor scale.
4) Do the edge detection.
5) Repeat the same operation for the second image obtained after serial polishing.
6) Do the overlay.
    - If control points don't exist (it's the case for the 1st time), a window appears and it is possible to define control points.
    - Define 3 control points per images.
    - Select a point on the figure on the left, then on the figure on the right, and repeat this operation 2 times.
    - Close the window for the selection of control points (Ctrl+W).
    - Control points are saved in .mat file (in the same folder than the 1st picture loaded).
7) If the control points are not satisfying, delete them and redo the step 6 to set new control points and to get a new overlay.
8) Save the overlay (see Figure 1) in the same folder than the 1st picture loaded (as a screenshot.png) (optional).
9) Do the measurement of the distance between edges (Vickers faces) or ridges of a unique Vickers indent (see Figure 2).
10) Do the measurement of the distance between edges of a unique grain boundary.
11) The value of the grain boundary inclination is finally given.
  
.. only:: html

    .. figure:: ./_pictures/GUIs/gui_gb_inc.png.gif
       :scale: 100 %
       :align: center
       
       *Figure 1 : Screenshots of the Matlab GUI used to calculate grain boundary inclination.*

.. only:: latex

    .. figure:: ./_pictures/GUIs/gui_gb_inc.png
       :scale: 100 %
       :align: center
       
       *Figure 1 : Screenshot of the Matlab GUI used to calculate grain boundary inclination.*
       
.. figure:: ./_pictures/Schemes_SlipTransmission/Vickers_indent.png
   :scale: 40 %
   :align: center
   
   *Figure 2 : Schemes of a) the top view of a Vickers indent (before and after polishing) and of b) the cross-section view.*

N.B.: Images should have the same scale factor.

N.B.: Distances and grain boundary inclination values are obtained with the mean scale factor of the two images...

See also
--------
`V. Randle, "A methodology for grain boundary plane assessment by single-section trace analysis.", Scripta Mater., 2001, 44, pp. 2789-2794. <http://dx.doi.org/10.1016/S1359-6462(01)00975-7>`_

Links
-----
- `Matlab - Interactive Exploration with the Image Viewer App <http://fr.mathworks.com/help/images/interactive-exploration-with-the-image-tool.html>`_
- `Matlab - Distance tool <http://www.mathworks.fr/help/images/ref/imdistline.html>`_
- `Matlab - Image conversions <http://fr.mathworks.com/help/images/image-type-conversions.html>`_
- `Matlab - Image filtering <http://fr.mathworks.com/help/images/linear-filtering.html>`_
- `Matlab - Control Point Selection Tool <http://www.mathworks.fr/help/images/ref/cpselect.html>`_
- `Matlab - Spatial transformation from control point pairs <http://www.mathworks.fr/help/images/ref/cp2tform.html>`_
- `Matlab - Edge detection <http://www.mathworks.fr/help/images/ref/edge.html>`_

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