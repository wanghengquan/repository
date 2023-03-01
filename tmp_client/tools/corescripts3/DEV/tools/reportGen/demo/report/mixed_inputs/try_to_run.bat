python ..\..\..\r.py report -f syn4.ini
mv final_report_temp.xlsx jiangyongcheng\Summary_synp.xlsx

python ..\..\..\r.py report -f lseVsyn4.ini
mv final_report_temp.xlsx jiangyongcheng\Summary_lse_vs_syn.xlsx

python ..\..\..\r.py report -f lse4.ini
mv final_report_temp.xlsx jiangyongcheng\Summary_lse.xlsx

python ..\..\..\r.py report -f lse4.ini  syn4.ini  lseVsyn4.ini
mv final_report_temp.xlsx jiangyongcheng\all_in_one.xlsx
