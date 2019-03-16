#!/usr/bin/env python3

# This script is run at the startup of each interactive python console when
# defined in PYTHONSTARTUP.

import readline
import atexit
import os

python_history = os.environ.get('XDG_STATE_HOME', '%s/.var/state' % os.environ['HOME'])
if python_history:
    python_history = '%s/python_history' % python_history
else:
    python_history = '%s/.python_history' % os.environ['HOME']

if os.path.exists(python_history):
    readline.read_history_file(python_history)
atexit.unregister(readline.write_history_file)
atexit.register(readline.write_history_file, python_history)
