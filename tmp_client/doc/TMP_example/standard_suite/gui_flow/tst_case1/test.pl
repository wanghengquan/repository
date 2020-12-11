###########################################################
#Date:2016.08.18
#Vasion:2.03
#Usage: This is a public template to record a squish test case
###########################################################
use strict;
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
my $sleep_time = 1;
my $myLayout = "suite_be_05_fv";
###########################################################


#GUI test flow
#==========================================================
sub main
{
    #waiting the Diamond GUI start
    &waitForObject(":MainWindow",5000000);
    #set Diamond's start coordinate and size of frame.     
    &setLayout($myLayout);
    #Get diamond version.
    my $BaliVersion = &GetBaliVersion();
    my $BaliPath = &GetBaliPath();
    #my $SquishPath = $ENV{'SQUISH_PREFIX'};
    #open design project
    my $prj_path = &getprjfile($PrjInfoFile);
    &openProject($prj_path);
    test::log("GUI test start.");
    &write_log("GUI test start.");    
    #======================================================
    #======================================================
    #Your GUI test start from here
    test::log("Set breakpoint here for your test code insertion.");
    sendEvent("QMouseEvent", waitForObject(":Lattice Diamond - Reports.File List_QTabBar"), QEvent::MouseButtonPress, 94, 10, Qt::LeftButton, 1, 0);
    sendEvent("QMouseEvent", waitForObject(":Lattice Diamond - Reports.Process_QTabBar"), QEvent::MouseButtonRelease, 94, 10, Qt::LeftButton, 0, 0);
    &rerunMap();
    test::pass('<1-1> map flow pass');
    &write_log('<1-1> map flow pass');
    #======================================================
    #======================================================
    test::log("GUI test end.");
    &write_log("GUI test end.");    
    &closeProject();
    &ExitBali();
}

#user functions insert here
#==========================================================


#==========================================================

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
    my $updir = File::Spec -> updir($script_dir);
    my $report_dir = Cwd::abs_path(File::Spec -> catdir($script_dir, $updir));
    my @design_array = File::Spec -> splitdir($script_dir);
    my $design_name = pop(@design_array);
    #&write_log("python $check_path --top-dir=$report_dir --design=$design_name --report=squish_run.csv");
    my $run_status = system "python $check_path --top-dir=$report_dir --design=$design_name --report=squish_run.csv";
    my $final_status = $run_status >> 8;
    test::log('Check: PASS.') unless $final_status;
    test::log('Check: FAIL.') if $final_status;
    &write_log(' ');
    &write_log('##########');
    &write_log('>>>Do not check following lines in your conf file.');
    &write_log('Check: PASS.') unless $final_status;
    &write_log('Check: FAIL.') if $final_status;
}

sub getprjfile{
    my $info_file = shift @_;
    my $info_path = File::Spec -> catfile($script_dir, $info_file);
    my $prj_path = "";
    error("info_file do not exists:$info_path") unless (-e $info_path);
    return  $prj_path unless (-e $info_path);
    my $config_data_hash_ref = &get_config_info($info_path);
    my $prj_file = $config_data_hash_ref -> {'qa'} -> {'ldf_file'};
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
    my $log_adr = $log_path;
    open my $log_fwh, ">>$log_adr";
    $log_str .= "\n";
    print $log_fwh $log_str;
    close $log_fwh;
}

