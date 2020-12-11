[Base]
test_software=diamond
test_tool=core_script
case_version=v1.00
update_date=2016-12-7
author=Jason Wang

[General]
nouse=
title=
section=
design_name=qas
testlevel=1
testscenarios=
description=
type=
priority=
crs=
create=
update=

[CaseInfo]
repository=
suite_path=
design_name=
script_address=
auth_key=
priority=
timeout=

[Environment]

[LaunchCommand]
cmd=python DEV/tools/runSquish/run_diamond.py  --design=qas --run-map-trce --devkit=LFE5UM-85F-6BG756C
override=

[Software]
diamond=3.9.0.201

[System]
os=
os_type=
os_arch=
min_space=
min_cpu=
min_mem=

[Machine]
terminal=
group=