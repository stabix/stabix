###_POST-PROCESSING PACKAGE: SX MODEL (ABAQUS)_###

***DESCRIPTION***
Two python scripts are included. Only one ('extract_data.py') has to be run.
The second script ('auxiliary_script.py') is executed inside the main script ('extract_data.py').
Two .txt files are generated, including in each of them the next information:
   1) file 1: Load-Displacement curve of the indentation process. 
   2) file 2: Topography of the deformed surface around the indent. 
              In particular, the XYZ coordinates of the residual surface points
              are specified following a regular grid shape. This file can be read
              directly by the free SPM software Gwyddion (http://gwyddion.net/)


***INSTRUCTIONS***
   1) Paste in a same folder (post-processing folder) the two scripts included 
      in the package
   2) Specify the following variables in the main script:
        2.1) Name of the .odb file to be analysed. Include the full root
             if the file is not in the post-processing folder. The variable to be specified 
             is **Indentation_Job_Name** (line 8)
        2.2) Name of the file 1 (adding the .txt extension). Include the full root
             if you don't want the file to be generated in the post-processing folder. 
             The variable to be specified is **name_output_file_curve** (line 9)
        2.3) Name of the file 2 (adding the .txt extension). Include the full root
             if you don't want the file to be generated in the post-processing folder. 
             The variable to be specified is **name_output_file_topo** (line 10)
        2.4) Pixel resolution (a squared grid is supposed) of the final topography file. 
             The variable to be specified is **resolution** (line 11)
   3) Run the main script using the python environment. In addition to an ABAQUS CAE version,
      the following python modules have to be previously installed in your computer.
        3.1) csv
        3.2) numpy
        3.3) matplotlib
        3.4) os
        3.5) time
        3.6) sys
