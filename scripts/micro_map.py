#!/usr/bin/env python3
# ABOUTME: Maps 8BitDo Micro button to Option+Space with hold-to-talk behavior.
# ABOUTME: Reads directly from the 8BitDo gamepad, ignoring all other input devices.

"""
Push-to-Talk mapper for 8BitDo Micro controller (in gamepad/Switch mode).

Reads raw HID input from the 8BitDo gamepad only.
Button press → Option+Space (for Handy)
Hold behavior: shortcut stays held while you hold the button.

Permissions:
  System Settings -> Privacy & Security -> Accessibility
  Enable for your terminal app.
"""

import hid
from pynput import keyboard

# 8BitDo in Switch Pro Controller emulation mode
VENDOR_ID = 0x057E
PRODUCT_ID = 0x2009

# Button mappings in byte 1 of HID report
BUTTON_BYTE = 1
PTT_MASK = 0x20      # bit 5 - push-to-talk button
ESC_MASK = 0x40      # bit 6 - escape button

ctl = keyboard.Controller()
is_holding_ptt = False
is_holding_esc = False


def find_gamepad():
    """Find the 8BitDo's gamepad HID interface."""
    for dev in hid.enumerate(VENDOR_ID, PRODUCT_ID):
        # usage_page 0x01 (Generic Desktop), usage 0x05 (Gamepad)
        if dev["usage_page"] == 0x01 and dev["usage"] == 0x05:
            return dev["path"]
    return None


def main():
    global is_holding_ptt, is_holding_esc

    print("=" * 50)
    print("8BitDo Micro Button Mapper")
    print("  PTT button → Option+Space")
    print("  Other button → Escape")
    print("=" * 50)

    path = find_gamepad()
    if not path:
        print("ERROR: 8BitDo gamepad not found!")
        print("Make sure it's connected and in gamepad/Switch mode.")
        return

    print(f"Found 8BitDo at: {path}")
    print("Hold your button to activate Handy")
    print("Ctrl+C to quit\n")

    device = hid.device()
    device.open_path(path)
    device.set_nonblocking(False)

    try:
        while True:
            data = device.read(64)
            if data:
                ptt_pressed = (data[BUTTON_BYTE] & PTT_MASK) != 0
                esc_pressed = (data[BUTTON_BYTE] & ESC_MASK) != 0

                # Push-to-talk: Option+Space
                if ptt_pressed and not is_holding_ptt:
                    is_holding_ptt = True
                    ctl.press(keyboard.Key.alt)
                    ctl.press(keyboard.Key.space)
                    print("🎤 HOLDING Option+Space")
                elif not ptt_pressed and is_holding_ptt:
                    is_holding_ptt = False
                    ctl.release(keyboard.Key.space)
                    ctl.release(keyboard.Key.alt)
                    print("🎤 RELEASED")

                # Escape button
                if esc_pressed and not is_holding_esc:
                    is_holding_esc = True
                    ctl.press(keyboard.Key.esc)
                    print("⎋ ESC pressed")
                elif not esc_pressed and is_holding_esc:
                    is_holding_esc = False
                    ctl.release(keyboard.Key.esc)
                    print("⎋ ESC released")
    except KeyboardInterrupt:
        print("\nExiting...")
    finally:
        if is_holding_ptt:
            ctl.release(keyboard.Key.space)
            ctl.release(keyboard.Key.alt)
        if is_holding_esc:
            ctl.release(keyboard.Key.esc)
        device.close()


if __name__ == "__main__":
    main()

