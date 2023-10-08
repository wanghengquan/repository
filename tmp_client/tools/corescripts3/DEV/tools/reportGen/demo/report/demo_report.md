# Demo of "report" flow

The scripts can generate comparation spreadsheet in Excel file.

## Usage

```text
usage: reportgen.py report [-h] [-d] [-o OUTPUT] [-e OUTPUT_EXCEL]
                           [-f REPORT_CONF [REPORT_CONF ...]] [-a SRC]
                           [-b DST] [--src-name SRC_NAME]
                           [--dst-name DST_NAME]
                           [--src-section SRC_SECTION [SRC_SECTION ...]]
                           [--dst-section DST_SECTION [DST_SECTION ...]]
                           [--section SECTION [SECTION ...]]
                           [--src-titles SRC_TITLES] [--dst-titles DST_TITLES]
                           [--titles TITLES] [--compare-titles COMPARE_TITLES]
                           [--group-name GROUP_NAME] [--sub-name SUB_NAME]
                           [--sheet-name SHEET_NAME]
                           [-c {AVERAGE,STDEVPA} [{AVERAGE,STDEVPA} ...]]
                           [--case-group-name CASE_GROUP_NAME] [--force]
                           [--add-test-id]

optional arguments:
  -h, --help            show this help message and exit
  -d, --debug           print debug message
  -o OUTPUT, --output OUTPUT
                        specify output directory
  -e OUTPUT_EXCEL, --output-excel OUTPUT_EXCEL
                        specify output Excel file name
  -f REPORT_CONF [REPORT_CONF ...], --report-conf REPORT_CONF [REPORT_CONF ...]
                        specify report configuration file(s)
  -a SRC, --src SRC     specify source report file or source run id
  -b DST, --dst DST     specify destination report file or destination run id
  --src-name SRC_NAME   specify source name, will be shown in Excel
  --dst-name DST_NAME   specify destination name, will be shown in Excel
  --src-section SRC_SECTION [SRC_SECTION ...]
                        specify source data section
  --dst-section DST_SECTION [DST_SECTION ...]
                        specify destination data section
  --section SECTION [SECTION ...]
                        specify section, will be used as src_section or
                        dst_section ONLY when they are not specified.
  --src-titles SRC_TITLES
                        specify source data titles
  --dst-titles DST_TITLES
                        specify destination data titles
  --titles TITLES       specify titles, will be used as src_titles or
                        dst_titles ONLY when they are not specified.
  --compare-titles COMPARE_TITLES
                        specify compare titles
  --group-name GROUP_NAME
                        specify group name in summary sheet
  --sub-name SUB_NAME   specify sub name in summary sheet
  --sheet-name SHEET_NAME
                        specify sheet name, should be less than 31 characters
  -c {AVERAGE,STDEVPA} [{AVERAGE,STDEVPA} ...], --calculate {AVERAGE,STDEVPA} [{AVERAGE,STDEVPA} ...]
                        specify statistical method(s)
  --case-group-name CASE_GROUP_NAME
                        specify ordered cases group name
  --force               dump report from database by force
  --add-test-id         add column xTestID in final report

```

## Description

1. -a SRC, --src SRC and --b DST, --dst DST

   src and dst can be: 1) run id; 2) csv file; 3) Excel file

## Typical application

1. Compare 2 sections in a run

   ```sh
   python ../../reportgen.py report -a142037 -b142037 --src-section jedi_E30_syn --dst-section jedi_E30_lse -o demo_E30_lseVSsyn
   ```

2. Compare sections in a run ( include of negative settings, the src_section and dst_section should have same length at least)

   > Including of negative settings. the src_section and dst_section should have same length at least.
   >
   > jedi_L26_lse cannot compare with jedi_S21_lse
   >
   > section jedi_none_exist is not in the run
   
   ```sh
   python ../../reportgen.py report -a142037 -b142037 --src-section jedi_E30_syn jedi_L26_lse jedi_none_exist --dst-section jedi_E30_lse jedi_S21_lse jedi_L26_syn -o demo_negative_settings
   ```

3. Compare 2 runs by default

   ```sh
   python ../../reportgen.py report --src 142037 -b 141233 -o demo_compare_2_runs --output-excel compare_by_default
   ```

4. Compare 2 runs by default with more custom inputs

   ```sh
   python ../../reportgen.py report --src 142037 -b 141233 -o demo_more_inputs --src-name demo_very_long_name_for_source_name
     --dst-name ng31p42_data
   ```

   Since sheet name length in Excel file is not exceed than 31 characters, the script will try to shorten the sheet name length to 31 and contain more information. 

5. Mixed inputs

   ```sh
   python ../../reportgen.py report -f mixed_inputs/lse4.ini mixed_inputs/syn4.ini mixed_inputs/lseVsyn4.ini -o demo_mixed
   ```

6. Mixed inputs with report file and command arguments

   ```sh
   python ../../reportgen.py report -f mixed_inputs/reused.ini  -o demo_mixed_cmd_file  -e use_ini_straightly
   python ../../reportgen.py report -f mixed_inputs/reused.ini  -a134724 -b141234 --dst-name ng30p24_flow -o demo_mixed_cmd_file  -e with_new_runs
   ```

7. Compare custom fields only

   ```sh
   python ../../reportgen.py report -a143145 -b143039 --compare-titles lse_carry,lse_even,lse_lut4,lse_odd,lse_reg  --titles  lse_carry,lse_even,lse_lut4,lse_odd,lse_reg -e compare_lse_only
   ```

8. use all data for split flow

   ```sh
   python DEV\tools\reportGen\reportgen.py report -a 224749 --src-name D2LSE --dst-name D2SYN --src-section Jedi_D2_E30_lse  --dst-section Jedi_D2_E30_syn   -b 224749 --add-test-id --compare-titles Register,LUT,Slice,IO,fmax,geo_fmax --best-fmax --force --use-all-data
   ```

   
