usage: excel2testrail.py [-h] [-d] (-f INFILE | --file-ini FILE_INI) -u
                         USERNAME -p PASSWORD

optional arguments:
  -h, --help            show this help message and exit
  -d, --debug           print debug message
  -f INFILE, --infile INFILE
                        specify input Suite Excel file
  --file-ini FILE_INI   specify input Suite ini file
  -u USERNAME, --username USERNAME
                        specify testrail user name.
  -p PASSWORD, --password PASSWORD
                        specify testrail password


* parser.add_argument("-m", "--macro-only", action="store_true", help="Adding case MUST match the macro")
  will not uploading cases which cannot match the macros.
