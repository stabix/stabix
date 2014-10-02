#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys,os

def mapped_unc_to_drive_letter(unc_path=None, network_name='Microsoft'):
    """ Finds the Windows drive letter from (partial) UNC path of a mapped network drive.
        If unc_path is partial, e.g. the server name, the first match will be returned
    """
    # Maybe http://covenanteyes.github.io/py_win_unc/ is also helpful in this context
    mapped_drives = mapped_network_drives()
    for d_line in mapped_drives:
        #if network_name in d_line:
        if '\\\\' in d_line:
            #print d_line
            d_list = d_line.split()
            #print d_list
            if 'OK' in  d_list[0]:
                #print 'OKOK'
                if unc_path in d_list[2]:
                    #print '***' + d_list[1]
                    return d_list[1]
                else:
                    pass
                    #print 'not what we are looking for'
                        
def mapped_network_drives():
    """ 
    """
    import subprocess
    # see also:  os.path.ismount
    # from: http://stackoverflow.com/questions/12672981/python-os-independent-list-of-available-storage-devices
    if 'win' in sys.platform:
        net_use_output = subprocess.Popen('net use', shell=True, stdout=subprocess.PIPE)
        drives_list, err = net_use_output.communicate()
        mapped_drives = drives_list.split('\n')   
        mapped_drives = [d.rstrip() for d in mapped_drives]
        for d in mapped_drives: 
            print(d)
        return mapped_drives

def net_use():
    """alias"""        

net_use = mapped_network_drives
    
def test():
    server = 'mufs4'
    letter = mapped_unc_to_drive_letter(unc_path=server)
    assert(letter is not '')    
    print letter