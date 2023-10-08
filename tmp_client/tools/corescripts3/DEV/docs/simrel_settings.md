## Simrel section samples

### active_input/output on all bidi ports

```text
[simrel]
active_input = select
; select = 1, all bidi ports are input
; select = 0, all bidi ports are output
; active_input with Higher priority when both active_input and active_output are specified.
```

```tex
[simrel]
active_output = nselect
; nselect = 1, all bidi ports are output
; nselect = 0, all bidi ports are input
```

### active_input/output with select signal on bidi ports

```tex
[simrel]
active_input_1 = sel_2 : bidi_1, bidi_3[4:0]
active_output_1 = sel_1 : bidi_2
active_output_2 = sel_3 : bidi_3[9:5]
active_input_19 = ddr_dqs_oe[0]:ddr_dqs_io[0]+
active_input_20 = ddr_dqs_oe[1]:ddr_dqs_io[1]+
active_input_21 = ddr_dqs_oe[0]:ddr_dqs_io[0]-
active_input_22 = ddr_dqs_oe[1]:ddr_dqs_io[1]-

; one port CANNOT be in both active_input and active_output at the same time
; sel_1 = 1, bidi_2 ports are output
; sel_1 = 0, bidi_2 ports are input
; sel_2 = 1, bidi_2 ports, bidi_3[4], bidi_3[3],bidi_3[2],bidi_3[1],bidi_3[0] are input
; sel_2 = 0, bidi_2 ports, bidi_3[4], bidi_3[3],bidi_3[2],bidi_3[1],bidi_3[0] are output
; sel_3 = 1, bidi_3[9], bidi_3[8],bidi_3[7],bidi_3[6],bidi_3[5] are output
; sel_3 = 0, bidi_3[9], bidi_3[8],bidi_3[7],bidi_3[6],bidi_3[5] are input
```

always in/output

```tex
; bidi_in with Higher priority when both bidi_in and bidi_out are specified
[simrel]
bidi_in = bidi_3[2], bidi_3[1], bidi_3[0]
; bidi_3[2], bidi_3[1], bidi_3[0] are input
; other bidi ports are output
```

```tex
[simrel]
bidi_out = __all__
; all bidi ports are output
```



