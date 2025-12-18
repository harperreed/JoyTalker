#!/usr/bin/env python3
# ABOUTME: Lists all connected HID devices to find vendor/product IDs.
# ABOUTME: Use this to identify your 8BitDo Micro's device identifiers.

"""
Device Sniffer - find your 8BitDo Micro's vendor/product ID.

Run this with your 8BitDo connected to see all HID devices.
Look for something with "8BitDo" or "Micro" in the name.
"""

import hid


def main():
    print("=" * 60)
    print("HID DEVICE SNIFFER - Looking for your 8BitDo Micro")
    print("=" * 60)
    print()

    devices = hid.enumerate()

    if not devices:
        print("No HID devices found!")
        return

    print(f"Found {len(devices)} HID device(s):\n")

    for i, dev in enumerate(devices):
        vendor_id = dev["vendor_id"]
        product_id = dev["product_id"]
        manufacturer = dev.get("manufacturer_string") or "(unknown)"
        product = dev.get("product_string") or "(unknown)"
        usage_page = dev.get("usage_page", 0)
        usage = dev.get("usage", 0)

        # Highlight likely candidates
        name_lower = f"{manufacturer} {product}".lower()
        is_likely = any(x in name_lower for x in ["8bitdo", "micro", "game", "controller"])
        marker = " <<<< LIKELY 8BitDo!" if is_likely else ""

        print(f"[{i}] {manufacturer} - {product}{marker}")
        print(f"    Vendor ID:  0x{vendor_id:04x} ({vendor_id})")
        print(f"    Product ID: 0x{product_id:04x} ({product_id})")
        print(f"    Usage:      page=0x{usage_page:04x} usage=0x{usage:04x}")
        print(f"    Path:       {dev['path']}")
        print()


if __name__ == "__main__":
    main()
