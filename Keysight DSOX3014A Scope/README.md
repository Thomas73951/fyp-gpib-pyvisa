# Keysight DSOX3014A Oscilloscope

This folder contains Python scripts for controlling a Keysight DSOX3014A oscilloscope. Additionally, GNU Octave (FOSS version of MATLAB) scripts are provided which are used for processing and plotting oscilloscope data.

Programming manual (requires email to access file): https://www.keysight.com/us/en/assets/9018-06894/programming-guides/9018-06894.pdf

Recommended files:
- [Connection test](keysightDSO_test.py)
- [Save channel data](keysightDSO_saveresult.py)
- [Plot saved channel data](plot_keysight.m)

Other:

- [RFID system detect (one)](detect_tag.py), [RFID system detect (multi)](detect_tag_multi.py), and [processing/plotting](process_detect_tag.m). This combines recording and saving data from the oscilloscope with the Arduino used with the firmware in https://github.com/Thomas73951/fyp-reader-control.
