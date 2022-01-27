set EXTERNAL_RADIANT_PATH=C:\radiant_auto\ng3_1b.32
set EXTERNAL_DIAMOND_PATH=C:\lscc\diamond\3.12

rem pytest -vs -n 4
pytest -vs -m "radiant and not sim_lib"

pause
