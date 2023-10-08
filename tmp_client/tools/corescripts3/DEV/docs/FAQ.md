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

# step flow 

```text
  --run-step {map,placer,router,par} [{map,placer,router,par} ...]
                        run single step flow
  --par-threads {-1,0,1,2,4,8} [{-1,0,1,2,4,8} ...]
                        specify step par threads
  --run-step-synthesis  run step synthesis flow
  --step-times STEP_TIMES
                        times number for running a step
```

1. run 3 times for synthesis flow

   `--run-step-synthesis --step-times 3`

2. run 2 times for step flow of map, placer router or par

   `--run-step map placer router par --step-times 2`

3. run 3 times for step flow of par with dedicated threads

   `--run-step par --par-threads 0 --step-times 3`

4. run different threads

   `--run-step par --par-threads -1 0 1 4`
