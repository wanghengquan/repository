# Demo of "dump" flow

The scripts can dump data from database to csv files (by default) or Excel files.

## Usage

```text
usage: reportgen.py dump [-h] [-d] [-o OUTPUT] [-e OUTPUT_EXCEL] -i PLAN_RUN_ID [PLAN_RUN_ID ...]
                         [-s SECTION [SECTION ...]] [-t FIELDS] [-a] [-CDI CUSTOM_DUMP_INI]

optional arguments:
  -h, --help            show this help message and exit
  -d, --debug           print debug message
  -o OUTPUT, --output OUTPUT
                        specify output directory
  -e OUTPUT_EXCEL, --output-excel OUTPUT_EXCEL
                        specify output Excel file name
  -i PLAN_RUN_ID [PLAN_RUN_ID ...], --plan-run-id PLAN_RUN_ID [PLAN_RUN_ID ...]
                        specify test plan/run id(s)
  -s SECTION [SECTION ...], --section SECTION [SECTION ...]
                        specify suite's section name(s)
  -t FIELDS, --fields FIELDS
                        dump data in fields only. fields list was defined in dump-configuration
  -a, --apart-by-section
                        dump test data into different file which is apart by section name
  -CDI CUSTOM_DUMP_INI, --custom-dump-ini CUSTOM_DUMP_INI
                        specify custom dump.ini file
```

## Description

1. "-o", "--output": specify output directory. If not specified, will dump the report files in current working directory.
2. "-e", "--output-excel": scripts will try to dump report to csv files by default.  and will dump to Excel file when output_excel file is specified. The scripts will try to use  file extension name ".xlsx" by force, so you can just specify the output_excel file's file name, such as "-o ng31p2_ThunderPlus"
3. "-i", "--plan-run-id": support plan id and run id. The output files/sheets will be named like: 

   - `Plan$(plan_id)_$(plan_name)_Run$(run_id)_$(run_name).csv `

   - `P$(plan_id)_R$(run_id)_Section_$(section_name).csv`

   - Sheet name: `R$(run_id)`

   - Sheet name: `P$(plan_id)_R$(run_id)`

   - Sheet name: `R$(run_id)_$(section_name)`
4. "-s", "--section": will dump data for this section or these sections
5. "-t", "--fields": specify custom dump fields, the output file will contains the fields data only. Field "Design" will be added by force.
   - use custom-built fields, which are defined in conf/dump_titles.ini
   - No space in arguments like: `-t Design,DSP,fmax,LUT,NoExistField`
   - have space and will be split by comma: `-t "Design, DSP, fmax"`
6. "-a", "--apart-by-section": Data in one sheet or one csv file are in the same section.
7. "-CDI",  "--custom-dump-ini":  You can define your own "dump_titles.ini" and use it by "--fields"



## Typical application 

```sh
python ../../reportgen.py dump -i 143001 -o demo_plan_143001_data
python ../../reportgen.py dump -i 143003 -o demo_run_143003_data -e run1430003.xlsx
python ../../reportgen.py dump -i 141233 141234 -o demo_two_runs_excel_divided_by_section -e 2runs -a 
python ../../reportgen.py dump -i 141233 141234 -o demo_two_runs_excel -e 2runs_merge.xlsx
python ../../reportgen.py dump -i 142037 -t  pap_only -s jedi_E30_syn jedi_S21_lse -o demo_pap_only_fields -e pap_only_data -a
python ../../reportgen.py dump -i 142037 -t  "Design, CARRY, fmax" -o demo_only_3_fields -e only_3_fields.any_fext

```

