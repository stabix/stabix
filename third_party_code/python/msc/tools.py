from __future__ import with_statement
import os

class Tools():
    def print_commands(self, cmdList,
                       filename='commands.proc',
                       caller='msc.tools.Tools.printCommands',
                       addLineBreaks=1, run=0):
        fid = file(filename, 'w')
        with open(filename, 'w') as fid:
            fid.write('| File written by %s' % caller)
            for cmd in cmdList:
                fid.write(cmd)
                if addLineBreaks:
                    fid.write('\n')
                    #fid.close()
        print('Commands written to ', os.getcwd(), filename)
        if run == 1:
            self.sendCommands(cmdList)

def mkdir_p(path):
    """Make dir if it does not exist
       after: http://stackoverflow.com/questions/600268/mkdir-p-functionality-in-python
    """
    # in python3 just use makedirs exist_ok=True
    import os, errno

    print('Ensuring (mkdir_p) that directory exists: %s' % path)
    try:
        os.makedirs(path)
        print('Created directory: %s' % path)
    except OSError, exc:  # as exc: # "as" needs Python >2.5
        if exc.errno == errno.EEXIST and os.path.isdir(path):
            pass
        else:
            raise
           
def label_str(label):
    if label is None:
        return ''
    else:
        return '_'+label
      
            
  