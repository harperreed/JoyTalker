#!/usr/bin/env python3
# ABOUTME: Key sniffer utility to identify what keys a device sends.
# ABOUTME: Shows key-down and key-up events with timing for debugging.

"""
Key Sniffer - see exactly what your 8BitDo Micro is sending.

Run this, press buttons on your controller, and watch what shows up.
Ctrl+C to quit.

Permissions needed:
  System Settings -> Privacy & Security -> Accessibility
  Enable for your terminal app.
"""

from pynput import keyboard
import time


def on_press(key):
    timestamp = time.strftime("%H:%M:%S")
    try:
        # Regular character key
        print(f"[{timestamp}] DOWN: '{key.char}' (char)")
    except AttributeError:
        # Special key (F1, Ctrl, etc.)
        print(f"[{timestamp}] DOWN: {key} (special)")


def on_release(key):
    timestamp = time.strftime("%H:%M:%S")
    try:
        print(f"[{timestamp}]   UP: '{key.char}' (char)")
    except AttributeError:
        print(f"[{timestamp}]   UP: {key} (special)")

    # Quit on Escape
    if key == keyboard.Key.esc:
        print("\nEscape pressed - exiting.")
        return False


def main():
    print("=" * 50)
    print("KEY SNIFFER - Press buttons on your 8BitDo Micro")
    print("=" * 50)
    print("Press ESC to quit\n")

    with keyboard.Listener(on_press=on_press, on_release=on_release) as listener:
        listener.join()


if __name__ == "__main__":
    main()
