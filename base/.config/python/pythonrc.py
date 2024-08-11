import atexit
import os
import readline

# Change history file
os.makedirs(os.path.join(os.path.expanduser("~"), ".cache/python"), exist_ok=True)
histfile = os.path.join(os.path.expanduser("~"), ".cache/python/python_history")
try:
    readline.read_history_file(histfile)
    # default history len is -1 (infinite), which may grow unruly
    readline.set_history_length(1000)
except FileNotFoundError:
    pass

atexit.register(readline.write_history_file, histfile)

