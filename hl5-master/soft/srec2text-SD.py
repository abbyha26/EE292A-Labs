#!/usr/bin/env python3
# -*- coding: utf-8 -*-

__author__      = "Paolo Mantovani"
__copyright__   = "Copyright 2017, Columbia University, NY"
__credits__     = "Giuseppe Di Guglielmo"
__license__     = "DO NOT DISTRIBUTE!"
__maintainer__  = "Paolo Mantovani"
__email__       = "paolo@cs.columbia.edu"
__status__      = "Testing"

import sys

def main():
    if len(sys.argv) != 2:
        print(f"Usage: {sys.argv[0]} <input_file>")
        print("")
        print("  <input_file>   : Object in SREC format")
        print("")
        sys.exit(0)

    in_path = sys.argv[1]
    try:
        with open(in_path, 'r') as fd:
            srec_to_text(fd)
    except OSError:
        print(f"Error: failed to open {in_path}")
        sys.exit(0)

def srec_to_text(fd):
    current_address = 0

    for raw in fd:
        if not raw.strip():
            continue

        entry = raw.strip()

        # Basic checks
        if not entry.startswith('S') or len(entry) < 4:
            print(f'Error: SREC decoding error -> "{entry}"')
            sys.exit(0)

        try:
            s_type = int(entry[1])  # '0'..'9'
        except ValueError:
            print(f'Error: SREC decoding error -> "{entry}"')
            sys.exit(0)

        byte_cnt = 0
        data_start = 0

        if s_type == 0:
            # Header (skip)
            continue

        elif s_type in (5, 6):
            # Optional S1/S2/S3 count (skip)
            continue

        elif s_type in (1, 9):
            # 16-bit address entry
            byte_cnt = int(entry[2:4], 16) - 3
            data_start = 8

        elif s_type in (2, 8):
            # 24-bit address entry
            byte_cnt = int(entry[2:4], 16) - 4
            data_start = 10

        elif s_type in (3, 7):
            # 32-bit address entry
            byte_cnt = int(entry[2:4], 16) - 5
            data_start = 12

        else:
            print(f'Error: SREC decoding error -> "{entry}"')
            sys.exit(0)

        # Parse address
        try:
            address = int(entry[4:data_start], 16)
        except ValueError:
            print(f'Error: SREC decoding error -> "{entry}"')
            sys.exit(0)

        # Termination records (S7/S8/S9): skip after updating nothing
        if s_type in (7, 8, 9):
            continue

        # Contiguity check (keep silent exit behavior as in your original)
        if current_address != 0 and address != current_address:
            # print(f'Error: STRC skipping addresses -> "{entry}"')
            sys.exit(0)

        current_address = address

        # Process data as 32-bit little-endian words
        words = byte_cnt // 4
        for i in range(words):
            start = data_start + i * 8
            end = start + 8
            little = entry[start:end]

            if len(little) < 8:
                print(f'Error: SREC decoding error -> "{entry}"')
                sys.exit(0)

            # Little-endian bytes AABBCCDD -> big-endian DDCCBBAA
            big = little[6:8] + little[4:6] + little[2:4] + little[0:2]
            print(f"{hex(current_address)} 0x{big}")
            current_address += 4

if __name__ == "__main__":
    main()
