::vsim -novopt -c top +num_sequence=100 -do "log -r /top/*;run -all; exit;" -wlf waveform.wlf -l log.svh
vsim -novopt -c top +num_sequence=1000 -do "run -all; exit;" -l log.svh