#!/usr/bin/env python3
# ABOUTME: Sniffs raw HID data from the 8BitDo in gamepad mode.
# ABOUTME: Use this to identify which bytes change when buttons are pressed.

"""
Gamepad Sniffer - see raw HID data from your 8BitDo in gamepad mode.

Press buttons and watch which bytes change.
Ctrl+C to quit.
"""

import hid

# 8BitDo in Switch Pro Controller mode
VENDOR_ID = 0x057E
PRODUCT_ID = 0x2009


def find_gamepad():
    """Find the 8BitDo's gamepad HID interface."""
    for dev in hid.enumerate(VENDOR_ID, PRODUCT_ID):
        # usage_page 0x01 (Generic Desktop), usage 0x05 (Gamepad)
        if dev["usage_page"] == 0x01 and dev["usage"] == 0x05:
            return dev["path"]
    return None


def main():
    print("=" * 60)
    print("GAMEPAD SNIFFER - Press buttons on your 8BitDo")
    print("=" * 60)

    path = find_gamepad()
    if not path:
        print("ERROR: 8BitDo gamepad not found!")
        print("Make sure it's connected and in gamepad/Switch mode.")
        return

    print(f"Found gamepad at: {path}")
    print("Press buttons and watch the bytes change")
    print("Ctrl+C to quit\n")

    device = hid.device()
    device.open_path(path)
    device.set_nonblocking(False)

    last_data = None
    try:
        while True:
            data = device.read(64)
            if data and data != last_data:
                # Show hex dump of the report
                hex_str = " ".join(f"{b:02x}" for b in data)
                print(f"[{len(data):2d} bytes] {hex_str}")
                last_data = data
    except KeyboardInterrupt:
        print("\nExiting...")
    finally:
        device.close()


if __name__ == "__main__":
    main()
