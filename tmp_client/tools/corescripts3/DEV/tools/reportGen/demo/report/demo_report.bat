python ../../reportgen.py report -a142037 -b142037 --src-section jedi_E30_syn --dst-section jedi_E30_lse -o demo_E30_lseVSsyn

python ../../reportgen.py report -a142037 -b142037 --src-section jedi_E30_syn jedi_L26_lse jedi_none_exist --dst-section jedi_E30_lse jedi_S21_lse jedi_L26_syn -o demo_negative_settings

python ../../reportgen.py report --src 142037 -b 141233 -o demo_compare_2_runs --output-excel compare_by_default

python ../../reportgen.py report --src 142037 -b 141233 -o demo_more_inputs --src-name demo_very_long_name_for_source_name --dst-name ng31p42_data

python ../../reportgen.py report -f mixed_inputs/lse4.ini mixed_inputs/syn4.ini mixed_inputs/lseVsyn4.ini -o demo_mixed

python ../../reportgen.py report -f mixed_inputs/reused.ini  -o demo_mixed_cmd_file  -e use_ini_straightly
python ../../reportgen.py report -f mixed_inputs/reused.ini  -a134724 -b141234 --dst-name ng30p24_flow -o demo_mixed_cmd_file  -e with_new_runs

python ../../reportgen.py report -a143145 -b143039 --compare-titles lse_carry,lse_even,lse_lut4,lse_odd,lse_reg  --titles lse_carry,lse_even,lse_lut4,lse_odd,lse_reg -e compare_lse_only

cmd
