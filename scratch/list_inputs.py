#! /usr/bin/env nix-shell
#! nix-shell -i python3 -p python3Packages.pynput
import time
import sys
from pynput import keyboard


def on_press(key):
    try:
        t = time.time()
        try:
            # Alphanumeric key pressed
            print('{} {}'.format(t, key.char), flush=True)
        except AttributeError:
            # Special key pressed
            key_name = str(key)[4:] # Strip "Key."
            print('{} {}'.format(t, key_name), flush=True)
    except:
        sys.exit(0)

# Collect events until released
with keyboard.Listener(on_press=on_press) as listener:
    try:
        while True:
            t = time.time()
            print('{} heartbeat'.format(t))
            time.sleep(1)
    except:
        sys.exit(0)
listener.join()
