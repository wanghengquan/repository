squish case is just like our normal engine case, the final case pass or fail is totally depends on the check result(according the bqs.conf file)
here is a demo config file.


[configuration information]
area = script_test
type = gui_flow
cr_note = xxxxx                 ==> to indicate any history CRs here
cr_status = 1/0                 ==> to indicate the CR status, 1: means CR list above still open


By default(and it cannot be changed) when squish case run by our TMP all runtime console info will be output to 'console.log' and in this file we will have: all test::pass/fail/log(defined in test.pl) results and total gui flow result.
to make sure there is no test::fail triggered we use 'check_grep_1' method.
to make sure this case go through the GUI flow we use 'check_grep_2' method.

[check_grep_1]
file = console.log
grep = \sFAIL\s
modifier = re.I
action=negative

[check_grep_2]
file = console.log
grep = GUI test end
modifier = re.I
action=positive