##########################################################
#This is for public used template
#Vasion:2.01
#11/23/12: Add rerunallProcess and check result function
#11/23/12: Add layout for special tools
#03/03/16: use perl-self language replace shell command cp rm
##########################################################
use File::Copy;
use File::Path;

### set layout with specific ini file.
### input: layout file name
sub setLayout($);

### set default layout
sub setLayout_default();

### run all the process, from synthesis to bitstream
sub rerunAllProcess();

### run to Export File.
### you need to check the item which you want to generate yourself.
sub RerunExportFile();

### run synthesis
sub runSynthesis();

### run util Map
sub rerunMap();

### run util PAR
sub rerunPar();

### open project
### input: path of the project file
sub openProject($);  

### close project
sub closeProject();

### exit Diamond
sub ExitBali();

### Get the Diamond Version
sub GetBaliVersion();

### Check the output of the error pane
sub checkResult();

### make directory according to the input
### input: dir path
sub mkDir($);

### copy projects from src dir to des dir
### input: src_path  des_path
sub copyProject($$);

### copy project in work dir to Log dir.
### input:tst_name,work_dir,log_dir
sub cpWork2Log($$);

#############################################################################################

sub setLayout($){
    waitForObject(":MainWindow",5000000);
    sendEvent("QMoveEvent", ":MainWindow", -4, -4, 1063, 337);
    waitForObject(":MainWindow");
    sendEvent("QResizeEvent", ":MainWindow", 1280, 968, 1063, 337);
    snooze(0.5);
    activateItem(waitForObjectItem(":Lattice Diamond - Start Page_QMenuBar", "Window"));
    snooze(0.5);
    activateItem(waitForObjectItem(":_QMenu", "Load Layout"));
    snooze(0.5);
    ($layOut) = @_;
    activateItem(waitForObjectItem(":Window.Load Layout_QMenu_2", $layOut));
    snooze(1);
}

sub setLayout_default()
{
    waitForObject(":MainWindow",5000000);
    sendEvent("QMoveEvent", ":MainWindow", -4, -4, 1063, 337);
    waitForObject(":MainWindow");
    sendEvent("QResizeEvent", ":MainWindow", 1280, 968, 1063, 337);
}

sub mkDir($)
{
    my ($dir) = @_;
    if ( -e $dir )
    {
        print "$dir already exists!\n";
    }
    else
    {
        mkdir $dir or die "can not make dir $dir...\n";
    }
}

sub getTstname($)
{
    my ($path) = @_;
    my (@array) = split(/\//,$path);
    $tstname = $array[$#array];
    return $tstname;
}

sub openProject($)
{

    my ($prjName) = @_;
    # $prjName    =~ s/\//\\/g;
    test::log("Opening Diamond Project : $prjName");

    #Open the Bali Project
    waitForObjectItem(":MainWindow.QMenuBar1", "File");
    activateItem(":MainWindow.QMenuBar1", "File");
    waitForObjectItem(":MainWindow.QMenuBar1.File", "Open");
    activateItem(":MainWindow.QMenuBar1.File", "Open");
    waitForObjectItem(":MainWindow.QMenuBar1.File.Open", "Project...");
    activateItem(":MainWindow.QMenuBar1.File.Open", "Project...");
    snooze(1);
    #Enter the project name
    waitForObject(":MainWindow.QFileDialog.fileNameEdit");
    type(":MainWindow.QFileDialog.fileNameEdit", $prjName);
    snooze(1);
    waitForObject(":MainWindow.QFileDialog.buttonBox.Open");
    snooze(1);
    clickButton(":MainWindow.QFileDialog.buttonBox.Open");
    snooze(2);
    if(object::exists(":Lattice Diamond_QMessageBox"))
    {
        test::fatal("FATAL: Unknown Message box found when opening project");
        waitForObject(":Lattice Diamond.OK_QPushButton");
        clickButton(":Lattice Diamond.OK_QPushButton");
    }
    if(object::exists(":MainWindow.Device"))
	{
		waitForObject(":MainWindow.Device.qt_msgbox_buttonbox.OK");
  	    clickbutton(":MainWindow.Device.qt_msgbox_buttonbox.OK");
  	}
    if(object::exists(":MainWindow.QMessageBox1.qt_msgbox_buttonbox"))
	{
		waitForObject(":MainWindow.QMessageBox1.qt_msgbox_buttonbox.Yes");
  	    clickButton(waitForObject(":MainWindow.QMessageBox1.qt_msgbox_buttonbox.Yes"));
  	}
    snooze(1);
    waitForObjectItem("MainWindow.PN Process View.PNTreeView1", "Export Files");
}

sub closeProject()
{
    waitForObjectItem(":MainWindow.QMenuBar1", "File");
    activateItem(":MainWindow.QMenuBar1", "File");
    waitForObjectItem(":MainWindow.QMenuBar1.File", "Close Project");
    activateItem(":MainWindow.QMenuBar1.File", "Close Project");
    test::log("Closing project....");
    snooze(5);
    # Check whether the Save dialog pops up. If so, click OK to continue
    my $strBtnSaveOK = ":MainWindow.Save Modified Files.OK";
    if(object::exists("$strBtnSaveOK")) {
        clickButton("$strBtnSaveOK");
    }

    snooze(3);
    # Check whether unknown Message Box pops up
    if(object::exists(":Lattice Diamond_QMessageBox"))
    {
        test::fatal("FATAL: Unknown Message box found after closing the project");
        waitForObject(":Lattice Diamond.OK_QPushButton");
        clickButton(":Lattice Diamond.OK_QPushButton");
    }

}


sub ExitBali()
{
    waitForObject(":MainWindow");
    waitForObjectItem(":MainWindow.QMenuBar1", "File");
    activateItem(":MainWindow.QMenuBar1", "File");
    waitForObjectItem(":MainWindow.QMenuBar1.File", "Exit");
    activateItem(":MainWindow.QMenuBar1.File", "Exit");
}


sub GetBaliVersion()
{
    waitForObject(":MainWindow",5000000);
    waitForObjectItem(":MainWindow.QMenuBar1", "Help");
    activateItem(":MainWindow.QMenuBar1", "Help");
    waitForObjectItem(":MainWindow.QMenuBar1.Help", "About Lattice Diamond");
    activateItem(":MainWindow.QMenuBar1.Help", "About Lattice Diamond");
    waitForObject(":Diamond_Version");
    my $objBaliVersion=findObject(":Diamond_Version");
    my $BaliVersion = $objBaliVersion->text;
    waitForObject("MainWindow.About Lattice Diamond.QDialogButtonBox1.OK");
    clickButton("MainWindow.About Lattice Diamond.QDialogButtonBox1.OK");
    test::log("$BaliVersion");
    return $BaliVersion;
}

sub GetBaliPath()
{
    waitForObject(":MainWindow",5000000);
    waitForObjectItem(":MainWindow.QMenuBar1", "Help");
    activateItem(":MainWindow.QMenuBar1", "Help");
    waitForObjectItem(":MainWindow.QMenuBar1.Help", "About Lattice Diamond");
    activateItem(":MainWindow.QMenuBar1.Help", "About Lattice Diamond");
    waitForObject(":Lattice Diamond install path");
    my $objBaliPath = findObject(":Lattice Diamond install path");
    my $BaliPath = $objBaliPath -> text;
    $BaliPath =~ s/lattice\s*diamond\s*install\s*path\s*:\s*//gi;
    waitForObject("MainWindow.About Lattice Diamond.QDialogButtonBox1.OK");
    clickButton("MainWindow.About Lattice Diamond.QDialogButtonBox1.OK");
    test::log("Lattice Diamond Install Path $BaliPath");
    return $BaliPath;
}
sub checkResult()
{
   my $objErrorOutput = findObject("MainWindow.PN Error[*] View.PNOutputWindow1.PNLogWindow1");
   my $strError = $objErrorOutput->plainText();
   
   if($strError eq "")
   {
      our  $result = "pass";
      test::pass("Flow is pass");
   }
   else
   {
      our $result = "fail";
      test::fail("Flow is fail");
   }     
}

sub rerunAllProcess()
{
   waitForObject(":MainWindow");
   my $mark = 0;
   eval{
       waitForObjectItem(":MainWindow.PN Process View.PNTreeView1", "Export Files.JEDEC File");
       clickItem(":MainWindow.PN Process View.PNTreeView1", "Export Files.JEDEC File", 9, 6, 1, Qt::LeftButton);
       $mark = 1;
  };
  if($mark eq 0){
       waitForObjectItem(":MainWindow.PN Process View.PNTreeView1", "Export Files.Bitstream File");
       clickItem(":MainWindow.PN Process View.PNTreeView1", "Export Files.Bitstream File", 10, 8, 1, Qt::LeftButton);
  }

   my $objRerunAll = "MainWindow.Process.Rerun All";
   waitForObject("$objRerunAll");

   #Get Process button
   my $objBtnRun = findObject("MainWindow.Process.Run");
   my $objBtnRerun = findObject("MainWindow.Process.Rerun");
   my $objBtnRerunAll = findObject("MainWindow.Process.Rerun All");
   my $objBtnStop = findObject("MainWindow.Process.Stop");

   #Get the status of Process buttons
   my $fRunStatus = $objBtnRun->enabled;
   my $fRerunStatus = $objBtnRerun->enabled;
   my $fRerunAllStatus = $objBtnRerunAll->enabled;
   my $fStopStatus = $objBtnStop->enabled;

   #Check the status of Process buttons
   test::fail("Error: Run button is disabled") if (!$fRunStatus);
   test::fail("Error: Rerun button is disabled") if(!$fRerunStatus);
   test::fail("Error: Rerun all button is disabled") if(!$fRerunAllStatus);
   test::fail("Error: Stop button is disabled") if($fStopStatus);

   #Start Rerun All process
   clickButton($objBtnRerunAll);

   # Wait until the process has finished or the Max time is out.
   my $MAXRUNTIME = 3600;
   my $timeCost = 0;
   while($objBtnStop->enabled && ($timeCost != $MAXRUNTIME))
   {
      snooze(1);
      $timeCost++;
   }

   if($timeCost==$MAXRUNTIME)
   {
       test::fail("MAXRUNTIME is out");
       $fStopStatus = $objBtnStop->enabled;
       if($fStopStatus) {
           waitForObjectItem(":MainWindow.QMenuBar1", "Process");
           activateItem(":MainWindow.QMenuBar1", "Process");
           waitForObjectItem(":MainWindow.QMenuBar1.Process", "Stop");
           activateItem(":MainWindow.QMenuBar1.Process", "Stop");
       }
   }

    # Check whether unknown Message Box pops up during rerun all process
    snooze(2);
    if(object::exists(":Lattice Diamond_QMessageBox"))
    {
        test::fatal("FATAL: Unknown Message box found during Re-run All Process");
        waitForObject(":Lattice Diamond.OK_QPushButton");
        clickButton(":Lattice Diamond.OK_QPushButton");
    }
   snooze(1);
}

sub RerunExportFile()
{
   waitForObjectItem("MainWindow.PN Process View.PNTreeView1", "Export Files");
   clickItem("MainWindow.PN Process View.PNTreeView1", "Export Files", 79, 12, 1, Qt::LeftButton);
#   my $objRerunAll = "MainWindow.Process.Rerun All";
   my $objRerunAll = "MainWindow.Process.Rerun";   
   waitForObject("$objRerunAll");

   #Get Process button
   my $objBtnRun = findObject("MainWindow.Process.Run");
   my $objBtnRerun = findObject("MainWindow.Process.Rerun");
   my $objBtnRerunAll = findObject("MainWindow.Process.Rerun All");
   my $objBtnStop = findObject("MainWindow.Process.Stop");

   #Get the status of Process buttons

   my $fRunStatus = $objBtnRun->enabled;
   my $fRerunStatus = $objBtnRerun->enabled;
   my $fRerunAllStatus = $objBtnRerunAll->enabled;
   my $fStopStatus = $objBtnStop->enabled;

   #Check the status of Process buttons
   test::fail("Error: Run button is disabled") if (!$fRunStatus);
   test::fail("Error: Rerun button is disabled") if(!$fRerunStatus);
   test::fail("Error: Rerun all button is disabled") if(!$fRerunAllStatus);
   test::fail("Error: Stop button is disabled") if($fStopStatus);

   #Start Rerun All process
   clickButton($objBtnRerun); # change objBtnRerunAll to objBtnRerun by jye

   # Wait until the process has finished or the Max time is out.
   my $MAXRUNTIME = 3600;
   my $timeCost = 0;
   while($objBtnStop->enabled && ($timeCost != $MAXRUNTIME))
   {
      snooze(1);
      $timeCost++;
   }

   if($timeCost==$MAXRUNTIME)
   {
       test::fail("MAXRUNTIME is out");
       $fStopStatus = $objBtnStop->enabled;
       if($fStopStatus) {
           waitForObjectItem(":MainWindow.QMenuBar1", "Process");
           activateItem(":MainWindow.QMenuBar1", "Process");
           waitForObjectItem(":MainWindow.QMenuBar1.Process", "Stop");
           activateItem(":MainWindow.QMenuBar1.Process", "Stop");
       }
   }

    # Check whether unknown Message Box pops up during rerun all process
    snooze(1);
    if(object::exists(":Lattice Diamond_QMessageBox"))
    {
        test::fatal("FATAL: Unknown Message box found during Re-run All Process");
        waitForObject(":Lattice Diamond.OK_QPushButton");
        clickButton(":Lattice Diamond.OK_QPushButton");
    }
   snooze(1);
}

sub runSynthesis()
{
    #waitForObject(":MainWindow");
   waitForObjectItem(":MainWindow.PN Process View.PNTreeView1", "Synthesize Design");
   clickItem(":MainWindow.PN Process View.PNTreeView1", "Synthesize Design", 9, 6, 1, Qt::LeftButton);

   my $objRerunAll = "MainWindow.Process.Rerun All";
   waitForObject("$objRerunAll");

   #Get Process button
   my $objBtnRun = findObject("MainWindow.Process.Run");
   my $objBtnRerun = findObject("MainWindow.Process.Rerun");
   my $objBtnRerunAll = findObject("MainWindow.Process.Rerun All");
   my $objBtnStop = findObject("MainWindow.Process.Stop");

   #Get the status of Process buttons
   my $fRunStatus = $objBtnRun->enabled;
   my $fRerunStatus = $objBtnRerun->enabled;
   my $fRerunAllStatus = $objBtnRerunAll->enabled;
   my $fStopStatus = $objBtnStop->enabled;

   #Check the status of Process buttons
   test::fail("Error: Run button is disabled") if (!$fRunStatus);
   test::fail("Error: Rerun button is disabled") if(!$fRerunStatus);
   test::fail("Error: Rerun all button is disabled") if(!$fRerunAllStatus);
   test::fail("Error: Stop button is disabled") if($fStopStatus);

   #Start Rerun All process
   clickButton($objBtnRerunAll);

   # Wait until the process has finished or the Max time is out.
   my $MAXRUNTIME = 3600;
   my $timeCost = 0;
   while($objBtnStop->enabled && ($timeCost != $MAXRUNTIME))
   {
      snooze(1);
      $timeCost++;
   }

   if($timeCost==$MAXRUNTIME)
   {
       test::fail("MAXRUNTIME is out");
       $fStopStatus = $objBtnStop->enabled;
       if($fStopStatus) {
           waitForObjectItem(":MainWindow.QMenuBar1", "Process");
           activateItem(":MainWindow.QMenuBar1", "Process");
           waitForObjectItem(":MainWindow.QMenuBar1.Process", "Stop");
           activateItem(":MainWindow.QMenuBar1.Process", "Stop");
       }
   }

    # Check whether unknown Message Box pops up during rerun all process
    snooze(2);
    if(object::exists(":Lattice Diamond_QMessageBox"))
    {
        test::fatal("FATAL: Unknown Message box found during Re-run All Process");
        waitForObject(":Lattice Diamond.OK_QPushButton");
        clickButton(":Lattice Diamond.OK_QPushButton");
    }
   snooze(1);
}

sub rerunMap()
{
    #waitForObject(":MainWindow");
   waitForObjectItem(":MainWindow.PN Process View.PNTreeView1", "Map Design");
   clickItem(":MainWindow.PN Process View.PNTreeView1", "Map Design", 9, 6, 1, Qt::LeftButton);

   my $objRerunAll = "MainWindow.Process.Rerun All";
   waitForObject("$objRerunAll");

   #Get Process button
   my $objBtnRun = findObject("MainWindow.Process.Run");
   my $objBtnRerun = findObject("MainWindow.Process.Rerun");
   my $objBtnRerunAll = findObject("MainWindow.Process.Rerun All");
   my $objBtnStop = findObject("MainWindow.Process.Stop");

   #Get the status of Process buttons
   my $fRunStatus = $objBtnRun->enabled;
   my $fRerunStatus = $objBtnRerun->enabled;
   my $fRerunAllStatus = $objBtnRerunAll->enabled;
   my $fStopStatus = $objBtnStop->enabled;

   #Check the status of Process buttons
   test::fail("Error: Run button is disabled") if (!$fRunStatus);
   test::fail("Error: Rerun button is disabled") if(!$fRerunStatus);
   test::fail("Error: Rerun all button is disabled") if(!$fRerunAllStatus);
   test::fail("Error: Stop button is disabled") if($fStopStatus);

   #Start Rerun All process
   clickButton($objBtnRerunAll);

   # Wait until the process has finished or the Max time is out.
   my $MAXRUNTIME = 3600;
   my $timeCost = 0;
   while($objBtnStop->enabled && ($timeCost != $MAXRUNTIME))
   {
      snooze(1);
      $timeCost++;
   }

   if($timeCost==$MAXRUNTIME)
   {
       test::fail("MAXRUNTIME is out");
       $fStopStatus = $objBtnStop->enabled;
       if($fStopStatus) {
           waitForObjectItem(":MainWindow.QMenuBar1", "Process");
           activateItem(":MainWindow.QMenuBar1", "Process");
           waitForObjectItem(":MainWindow.QMenuBar1.Process", "Stop");
           activateItem(":MainWindow.QMenuBar1.Process", "Stop");
       }
   }

    # Check whether unknown Message Box pops up during rerun all process
    snooze(2);
    if(object::exists(":Lattice Diamond_QMessageBox"))
    {
        test::fatal("FATAL: Unknown Message box found during Re-run All Process");
        waitForObject(":Lattice Diamond.OK_QPushButton");
        clickButton(":Lattice Diamond.OK_QPushButton");
    }
   snooze(1);
}

sub rerunPar()
{
    #waitForObject(":MainWindow");
   waitForObjectItem(":MainWindow.PN Process View.PNTreeView1", "Place & Route Design");
   clickItem(":MainWindow.PN Process View.PNTreeView1", "Place & Route Design", 9, 6, 1, Qt::LeftButton);

   my $objRerunAll = "MainWindow.Process.Rerun All";
   waitForObject("$objRerunAll");

   #Get Process button
   my $objBtnRun = findObject("MainWindow.Process.Run");
   my $objBtnRerun = findObject("MainWindow.Process.Rerun");
   my $objBtnRerunAll = findObject("MainWindow.Process.Rerun All");
   my $objBtnStop = findObject("MainWindow.Process.Stop");

   #Get the status of Process buttons
   my $fRunStatus = $objBtnRun->enabled;
   my $fRerunStatus = $objBtnRerun->enabled;
   my $fRerunAllStatus = $objBtnRerunAll->enabled;
   my $fStopStatus = $objBtnStop->enabled;

   #Check the status of Process buttons
   test::fail("Error: Run button is disabled") if (!$fRunStatus);
   test::fail("Error: Rerun button is disabled") if(!$fRerunStatus);
   test::fail("Error: Rerun all button is disabled") if(!$fRerunAllStatus);
   test::fail("Error: Stop button is disabled") if($fStopStatus);

   #Start Rerun All process
   clickButton($objBtnRerunAll);

   # Wait until the process has finished or the Max time is out.
   my $MAXRUNTIME = 7200;
   my $timeCost = 0;
   while($objBtnStop->enabled && ($timeCost != $MAXRUNTIME))
   {
      snooze(1);
      $timeCost++;
   }

   if($timeCost==$MAXRUNTIME)
   {
       test::fail("MAXRUNTIME is out");
       $fStopStatus = $objBtnStop->enabled;
       if($fStopStatus) {
           waitForObjectItem(":MainWindow.QMenuBar1", "Process");
           activateItem(":MainWindow.QMenuBar1", "Process");
           waitForObjectItem(":MainWindow.QMenuBar1.Process", "Stop");
           activateItem(":MainWindow.QMenuBar1.Process", "Stop");
       }
   }

    # Check whether unknown Message Box pops up during rerun all process
    snooze(2);
    if(object::exists(":Lattice Diamond_QMessageBox"))
    {
        test::fatal("FATAL: Unknown Message box found during Re-run All Process");
        waitForObject(":Lattice Diamond.OK_QPushButton");
        clickButton(":Lattice Diamond.OK_QPushButton");
    }
   snooze(1);
}

#sub copyProject($$)
#{
#    my ($case_dir, $work_dir) = @_;
#    #Delete files in Work dir
#    system("rm -fR $work_dir/*") and test::warning("Delete work files failed: $?");
#    #Copy Bali Project to Work dir
#    system ("cp -R $case_dir $work_dir") and test::warning("Copy project files failed: $?");
#}
#
#sub cpWork2Log($$)
#{
#    my ($tstname, $work, $log) = @_;
#    if ( -e $log )
#    {
#        test::warning("$log already exists!");
#    }
#    else
#    {
#        mkdir $log || die "can not make dir $log...";
#    }
#    chdir($log); 
#    my($sec,$min,$hour,$day,$mon,$year) = localtime();
#    $mon++; 
#    $year += 1900;   
#    my $yyyymmddZH = sprintf("%04d%02d%02d%02d%02d", $year, $mon, $day,$hour,$min);
#    my $log_bak=$log."/".$tstname.'_'.$yyyymmddZH;
#    my $work_path = $work."/".$tstname;
#    system("cp -R $work_path $log_bak") and test::warning("copy project files to log failed: $?");
#    system("rm -fR $work/*");
#}

sub copy_dir($$)
{
	my($source_dir, $sink_dir) = @_;
	mkdir $sink_dir, 0777 or die "cannot make directory:$!\n";
	opendir TOP_DH, $source_dir or die "Can't open directory,information:$!!\n";
	my @dirs_list = readdir TOP_DH;
	foreach(@dirs_list)
	{
		if (-d $source_dir.'/'.$_)
		{

			if (not /^(\.|\.\.)$/)
			{
			    copy_dir($source_dir.'/'.$_ , $sink_dir.'/'.$_ );
			}
		}
		else
		{
			File::Copy::copy($source_dir."/$_",$sink_dir);
		}
	}
	closedir TOP_DH;
}

sub copyProject($$)
{
    my ($case_dir, $test_dir) = @_;
    eval{File::Path::rmtree($test_dir,{keep_root => 0})};
    if ($@){print "An error occurred ($@),continuing\n";}
    copy_dir($case_dir,$test_dir);
}

sub cpWork2Log($$)
{
    my ($tstname, $work, $log) = @_;
    if ( -e $log )
    {
        print "$log already exists!";
    }
    else
    {
        mkdir $log or die "can not make dir $log...";
    }
    chdir($log); 
    my($sec,$min,$hour,$day,$mon,$year) = localtime();
    $mon++; 
    $year += 1900;   
    my $yyyymmddZH = sprintf("%04d%02d%02d%02d%02d", $year, $mon, $day,$hour,$min);
    my $log_bak=$log."/".$tstname.'_'.$yyyymmddZH;
    my $work_path = $work."/".$tstname;
    copy_dir($work_path,$log_bak) ;
    eval{File::Path::rmtree($work_path,{keep_root => 0})};
    if ($@){print "An error occurred ($@),continuing\n";}
}
