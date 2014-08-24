# -*- coding: utf-8 -*-
"""
@author: c.zambaldi
"""

from .base import Proc


class Jobs(Proc):
    def jobListIndent(self, maxNr=63, label=''):
        self.jobListNr = [1, # 001
                          16, # <101>
                          22, # <100>
                          37, # <110>
                          21# <111>
        ] # near- or exact-high_sym_oris
        prefList = [38, 50, 13] #hkz305pos228
        #prefList=[38, 50, 13] #hkz305pos228
        self.jobListNr.extend(prefList) #put preferred (experimental) oris here
        rng = range(1, maxNr + 1)
        doppelt9 = [42, 43, 45, 48, 52, 57, 58, 59, 60, 61, 62, 63]
        self.jobListNr.extend(doppelt9)
        for j in self.jobListNr:
            if j in rng:
                rng.remove(j)
        self.jobListNr.extend(rng[:])
        #self.jobListNr.extend(doppelt9[:])
        self.makeJobList(label=label)

    def jobListIndentHCP(self, maxNr=23, label=''):
        self.jobListNr = [1, #
                          11, #
                          17] # near- or exact-high_sym_oris
        #prefList=[38, 50, 13] #hkz305pos228
        #prefList=[38, 50, 13] #hkz305pos228
        prefList = []
        self.jobListNr.extend(prefList) #put preferred (experimental) oris here
        rng = range(1, maxNr + 1)
        #doppelt9=[42,43,45,48,52,57,58,59,60,61,62,63]
        #self.jobListNr.extend(doppelt9)
        for j in self.jobListNr:
            if j in rng:
                rng.remove(j)
        self.jobListNr.extend(rng[:])
        #self.jobListNr.extend(doppelt9[:])
        self.makeJobList(label=label)

    def jobListIndentDPsteel(self, maxNr=20, label=''):
        self.jobListNr = [
            5, # G 71 near 001
            6, # G 80 near 111
            10, # G161 near 111
            12, # G180
            17, # G274 ~near 111
            18, # G286 near 101

        ]
        prefList = []
        self.jobListNr.extend(prefList) #put preferred (experimental) oris here
        rng = range(1, maxNr + 1)
        #doppelt9=[42,43,45,48,52,57,58,59,60,61,62,63]
        #self.jobListNr.extend(doppelt9)
        for j in self.jobListNr:
            if j in rng:
                rng.remove(j)
        self.jobListNr.extend(rng[:])
        #self.jobListNr.extend(doppelt9[:])
        self.makeJobList(label=label)

    def makeJobList(self, prefix='ori', label=''):
        #self.jobList=map(lambda x:'%s%03i_%s'%(prefix,x,label),self.jobListNr)
        self.jobList = ['%s%03i_%s' % (prefix, x, label) for x in self.jobListNr]

    def copy_jobs(self,
                  #  def startAllOrientations(self,
                  jobList=None,
                  maxNr=None,
                  label='',
                  startJobs=False):
        # see copyAndSubmitJobs in MSC_POST
        cmd_list = []
        if jobList == None:
            jobList = ['A1', 'B1', 'C1', 'D1', 'N']
        if maxNr != None:
            #self.jobListIndent(maxNr=maxNr,label=label)
            #self.jobListIndentHCP(maxNr=maxNr,label=label)
            self.jobListIndentDPsteel(maxNr=maxNr)
            #self.jobListNr=[1,# 001
            # 16,# <101>
            # 22,# <100>
            # 37,# <110>
            # 21# <111>
            # ] # near- or exact-high_sym_oris
            #prefList=[38,
            # 113, #hkz305_p228_ro_gruen
            # 128, #hkz305_p228_lo,oliv near 101, close to ori 17
            # 13] #hkz305pos228
            #prefList=[38, 50, 13] #hkz305pos228
            #self.jobListNr.extend(prefList) #put preferred (experimental) oris here
            #rng=range(1,maxNr+1)
            #for j in self.jobListNr:
            #  if j in rng:
            #    rng.remove(j)
            #self.jobListNr.extend(rng[:])
            if label != '': label = '_' + label
            jobList = map(lambda x: 'ori%03i%s' % (x, label), self.jobListNr)
        else:
            self.jobListNr = range(1, len(jobList) + 1)
        for ori in jobList:
            cmd_list.extend(['\n*copy_job\n',
                             '*job_name %s\n' % ori +
                             '*icond_type state_variable\n',
                             '*icond_param_value state_var_id %i\n' % \
                             2 +
                             '*icond_dof_value var %i\n' \
                                 #%(jobList.index(ori)+1),
                             % (self.jobListNr[jobList.index(ori)]),
                             '*save_model\n'])
            if startJobs == False:
                cmd_list.extend(['|'])
                #'*submit_job 1 |%s\n'%(ori),
            cmd_list.extend(
                ['*execute_job 1 |%s, %.1f pct completed\n' % (ori, jobList.index(ori) * 100. / len(jobList)),
                 #'*monitor_job |%s\n'%(ori),
                 '*job_option user_source:run_saved\n'])
        self.print_commands(cmd_list,
                            #filename='startAllOris_%s.proc'%(label),caller='startAllOris',
                            filename='copy_jobs%s.proc' % (label), caller='msc.proc.jobs.copy_jobs',
                            #filename='startAllOris.proc',caller='startAllOris',
                            addLineBreaks=0)
        #self.sendCommands(cmd_list)

