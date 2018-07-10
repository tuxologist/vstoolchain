#
# Launch VS from the Magic WindRiver Shell
#

import subprocess, os

#build a custom local PATH to include Visual Studio
custom_env = os.environ.copy()
custom_env['PATH'] = "C:\Program Files (x86)\Microsoft Visual Studio\\2017\Community\Common7\IDE;" \
                     + custom_env['PATH']

#spawn unix /dev/null emulation
DEVNULL = open(os.devnull, 'w');

#build a command string for subprocess manipulation
WRshell = "C:\WindRiver\wrenv.exe"
command = [WRshell, '-p', 'vxworks653-2.2']

#spawn a Magic WindRiver Shell
proc = subprocess.Popen(command, stdin=subprocess.PIPE,
                                 stdout=DEVNULL,           # send to dev/null
                                 stderr=subprocess.STDOUT, # send to /dev/null
                                 env=custom_env,
                                 shell=False)

#launch Visual Studio from new Magic WindRiver Shell
proc.communicate(input='devenv.exe\n');
