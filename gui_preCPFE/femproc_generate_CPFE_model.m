function femproc_generate_CPFE_model()
gui = guidata(gcf)
if strfind(gui.description, 'single crystal')
femproc_generate_indentation_model_SX
end
if strfind(gui.description, 'bicrystal')
femproc_generate_indentation_model_BX
end