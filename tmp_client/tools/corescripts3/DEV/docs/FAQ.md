[toc]



# Set fixed frequency for clock in implementation flow and ignore/care clock in scan timing data flow

**Situation**:

> For multiple open core designs, data shift in/out clocks are ignored. They were set to 10 MHz all the times and they are not included in geoMean Fmax calculation. 

**Task:**

> 1. set fixed clock frequency in test flow
> 2. ignore clocks when scanning timing data
> 3. care only clocks when scanning timing data

**Action**:

> choices 1: --fixed-clock CLK:10  clk_core:20  --ignore-clock CLK clk_core  --care-clock clk_wishbone  (use space to separate multi-clocks )
>
> choices 2:  in info file’s [qa] section: 
>
> * fixed_clock = CLK:10  clk_core:20
> * ignore_clock = CLK clk_core
> * care_clock = clk_wishbone

**Result**:

> Clock MUST BE PORT/PIN
> Radiant/Vivado: Done.
> Diamond: TODO.
