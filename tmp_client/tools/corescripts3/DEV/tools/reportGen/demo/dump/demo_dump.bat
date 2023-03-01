python ../../reportgen.py dump -i 143001 -o demo_plan_143001_data
python ../../reportgen.py dump -i 143003 -o demo_run_143003_data -e run1430003.xlsx
python ../../reportgen.py dump -i 141233 141234 -o demo_two_runs_excel_divided_by_section -e 2runs -a 
python ../../reportgen.py dump -i 141233 141234 -o demo_two_runs_excel -e 2runs_merge.xlsx
python ../../reportgen.py dump -i 142037 -t  pap_only -s jedi_E30_syn jedi_S21_lse -o demo_pap_only_fields -e pap_only_data -a
python ../../reportgen.py dump -i 142037 -t  "Design, CARRY, fmax" -o demo_only_3_fields -e only_3_fields.any_fext

pause
