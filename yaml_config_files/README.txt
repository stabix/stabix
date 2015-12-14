How to set your user YAML configuration files ?

1) In Matlab Command Window, call the function 'username_get' stored
in the 'util' folder of STABiX repository, to determine your username.

2) Rename the folder 'username' with your own username...

3) Rename the YAML configuration files inside this folder by replacing 'username' by your own username.

4) Then, change the default configuration without modifying fieldnames !

Visit the STABiX documentation for more details: http://stabix.readthedocs.org/en/latest/index.html
Visit the YAML website for more informations: http://www.yaml.org/
Visit the YAML code for Matlab: https://code.google.com/p/yamlmatlab/

N.B.: When changing your YAML configuration files, be careful to give only absolute paths
and to put a space after the comma in a list (e.g. [x, y, z]) !!!
