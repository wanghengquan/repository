Usage: excel2testrail.py [options]

Options:
  -h, --help            show this help message and exit
  -d, --debug           Debug only
  -f INFILE, --infile=INFILE
                        specify Excel conf file
  -u USERNAME, --username=USERNAME
                        specify testrail user name.
  -p PASSWORD, --password=PASSWORD
                        specify testrail password
  -t TESTRAIL, --testrail=TESTRAIL
                        specify testrail URL, format: http://$server/testrail


--debug: generate the internal ini file only.
--infile: suite file in Excel format
--username: testrail API username, the scripts have already set a default one.
--password: testrail API password, the scripts have already set a default one.
--testrail: testrail server URL. the scripts' default value is http://linux-d50553/testrail

