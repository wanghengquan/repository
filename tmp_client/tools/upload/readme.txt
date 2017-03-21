Usage: excel2testrail.py [options]

Options:
  -h, --help            show this help message and exit
  -d, --debug           Debug only
  -f INFILE, --infile=INFILE
                        specify Excel conf file
  -u USERNAME, --username=USERNAME
                        specify testrail user name, default user is
                        public@latticesemi.com
  -p PASSWORD, --password=PASSWORD
                        specify testrail password
  -t TESTRAIL, --testrail=TESTRAIL
                        specify testrail URL, format: http://$server/testrail



--debug: generate the internal ini file only.
--infile: suite file in Excel format
--username: testrail API username, the scripts have already set a default one.
--password: testrail API password, the scripts have already set a default one.
--testrail: testrail server URL. the scripts' default value is http://linux-d50553/testrail


//////
2016/12/14 set default username/password for public@latticesemi.com.

2016/12/13 remove default username and password for testrail API.
           default testrail server is http://linux-d50553/testrail.


