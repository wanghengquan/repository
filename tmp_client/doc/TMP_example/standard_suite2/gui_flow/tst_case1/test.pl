###########################################################
#Date:2019.08.09
#Vasion:2.02
#Author:Jason.Wang
#Usage: This is a public template to record a squish test case
#--update:
#1. Read external dev path for check use
#2. Read external python path for check use
###########################################################
#use strict;
use Cwd;
use File::Spec;
use Data::Dumper;
use FindBin;
use lib "$FindBin::Bin/testmethod";

use Config::Tiny;
use Recursive;

#configure
###########################################################
my $run_dir = getcwd();
my $script_dir = "$FindBin::Bin";

my $PrjInfoFile = "bqs.info";
my $PrjConfFile = "bqs.conf";
my $PrjDataFile = "data.tsv";
my $PrjPublFile = "public.pl";
my $design_dir = "testdesign";
my $work_dir = "_scratch";
my $log_file = "test_results.log";
my $design_path = File::Spec -> catdir($script_dir , $design_dir);
my $data_path = File::Spec -> catdir($script_dir , "testdata");
my $method_path = File::Spec -> catdir($script_dir , "testmethod");
my $work_path = File::Spec -> catdir($script_dir , $work_dir);
my $log_path = File::Spec -> catfile($work_path, $log_file);
my $snooze_time = 1;

my $console_log = "console.log";  #it's a dummy log try to reproduce the log info in Test Results 
my $console_path = File::Spec -> catdir($script_dir , $console_log);
###########################################################


#GUI test flow
#==========================================================
sub main
{
    #waiting the GUI start
    &openNG();   
    #open design project
    my $prj_path = &getprjfile($PrjInfoFile);
    &openProject($prj_path);
    test::log("GUI test start.");
    &write_log("GUI test start.");
    setWindowState(waitForObject(":PNMainWindow_PNMainWindow"), WindowState::Maximize);
    #======================================================
    #======================================================
    #Your GUI test start from here

    snooze(2);  
    rerunAllProcess();
    
    #======================================================
    #======================================================
    saveProject();
    test::log("GUI test end.");
    &write_log("GUI test end.");    
    &closeProject();
    &ExitNG();
}


#other functions followed, don't care:)
#==========================================================
sub init {
    #prepare case dir
    Recursive::pathrmdir($work_path) if (-e $work_path);
    Recursive::dircopy($design_path, $work_path);   
    #inputing public functions
    my $public_fun_file = File::Spec -> catfile($method_path, $PrjPublFile);
    source($public_fun_file);
}

sub cleanup {
    #start to check the design no matter main crash or not
    my $check_path = File::Spec -> catfile($method_path, 'check', 'check.py');
    $check_path = File::Spec -> catfile($ENV{"EXTERNAL_DEV_PATH"}, 'tools', 'check', 'check.py') if (exists($ENV{"EXTERNAL_DEV_PATH"}));
    test::log("Check script: $check_path");
    my $updir = File::Spec -> updir($script_dir);
    my $report_dir = Cwd::abs_path(File::Spec -> catdir($script_dir, $updir));
    my @design_array = File::Spec -> splitdir($script_dir);
    my $design_name = pop(@design_array);
    my $run_cmd = "python $check_path --top-dir=$report_dir --design=$design_name --report=squish_run.csv";
    $run_cmd = "$ENV{\"EXTERNAL_PYTHON_PATH\"}/python $check_path --top-dir=$report_dir --design=$design_name --report=squish_run.csv" if (exists($ENV{"EXTERNAL_PYTHON_PATH"}));
    &write_log($run_cmd);
    my $run_status = system  $run_cmd;
    my $final_status = $run_status >> 8;
    if (($final_status == 0) or ($final_status == 200)){
        test::log('Check: PASS.');
    } else {
        test::log('Check: FAIL.');
    }
    &write_results('##########');
    &write_results(' ');
    if (($final_status == 0) or ($final_status == 200)){
        write_results('Check: PASS.');
    } else {
        write_results('Check: FAIL.');
    }    
}

sub getprjfile{
    my $info_file = shift @_;
    my $info_path = File::Spec -> catfile($script_dir, $info_file);
    my $prj_path = "";
    error("info_file do not exists:$info_path") unless (-e $info_path);
    return  $prj_path unless (-e $info_path);
    my $config_data_hash_ref = &get_config_info($info_path);
    my $prj_file = $config_data_hash_ref -> {'qa'} -> {'rdf_file'};
    $prj_file =~ s/$design_dir/$work_dir/g;
    return  $prj_path unless (defined($prj_file));
    $prj_path = "$script_dir/$design_dir/../$prj_file";
    return $prj_path;
}

sub get_config_info{
    my ($config_file_path) = @_;
    my $config_obj = Config::Tiny -> new();
    my $config_data_hash_ref = Config::Tiny -> read($config_file_path);
    return $config_data_hash_ref ;
}

sub write_log{
    my $log_str = shift @_;
    my $log_adr = $console_path;
    open my $log_fwh, ">>$log_adr";
    $log_str .= "\n";
    print $log_fwh $log_str;
    close $log_fwh;
}

sub write_results{
    my $log_str = shift @_;
    my $log_adr = $log_path;
    open my $log_fwh, ">>$log_adr";
    $log_str .= "\n";
    print $log_fwh $log_str;
    close $log_fwh;
}
