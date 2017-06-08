##########################################################
#This is for public used template
#
#11/23/12: Add rerunallProcess and check result function
#11/23/12: Add layout for special tools
#02/26/13: Add RerunExportFile()
#02/27/13: Modify setLayout($) and setDefaultLayout()
##########################################################

### set layout with specific ini file.
### input: layout file name
sub setLayout($);  

### set default layout
sub setDefaultLayout();  

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

### copy project in work dir to Log dir.
### input:tst_name,work_dir,log_dir
sub cpWork2Log($$);

### select synplify pro for synthesis
sub SelectSynPro();

### select LSE for synthesis
sub SelectLse();

### wait at most 5 min--Cherry
sub waitRunEnd();

#############################################################################################

sub setLayout($)
{  
    waitForObject(":MainWindow",5000000);
    my ($layOut) = @_;

    activateItem(waitForObjectItem( ":Lattice Diamond - Start Page_QMenuBar", "Window" ));
    activateItem(waitForObjectItem(":Lattice Diamond - Start Page.Window_QMenu","Load Layout"));
    #activateItem(waitForObjectItem( ":Window.Load Layout_QMenu", "Project\\_Navigator" ));
    activateItem(waitForObjectItem( ":Window.Load Layout_QMenu", $layOut ));

    snooze(2);   
}

sub setDefaultLayout()
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
        test::warning("$dir already exists!");
    }
    else
    {
        mkdir $dir || die "can not make dir $dir...";
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

    #Enter the project name
    waitForObject(":MainWindow.QFileDialog.fileNameEdit");
    snooze(2);
    type(":MainWindow.QFileDialog.fileNameEdit", $prjName);
    waitForObject(":MainWindow.QFileDialog.buttonBox.Open");
    clickButton(":MainWindow.QFileDialog.buttonBox.Open");
    snooze(2);
    if(object::exists(":Lattice Diamond_QMessageBox"))
    {
        test::fail("Unknown Message box found when opening project");
        waitForObject(":Lattice Diamond.OK_QPushButton");
        clickButton(":Lattice Diamond.OK_QPushButton");
    }
    if(object::exists(":MainWindow.Device"))
	{  
	    test::fail("Device not support");
  	    clickButton( waitForObject(":Device.Use Default_QPushButton") );
  	}
    if(object::exists(":MainWindow.QMessageBox1.qt_msgbox_buttonbox"))
	{   
	    test::warning("Opening old project");
		waitForObject(":MainWindow.QMessageBox1.qt_msgbox_buttonbox.Yes");
  	    clickButton(waitForObject(":MainWindow.QMessageBox1.qt_msgbox_buttonbox.Yes"));
  	}
    snooze(1);
    waitForObjectItem("MainWindow.PN Process View.PNTreeView1", "Export Files",60000);#1min
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

    waitForObject(":MainWindow");
    sendEvent("QMoveEvent", ":MainWindow", -4, -4, 1063, 337);
    waitForObject(":MainWindow");
    sendEvent("QResizeEvent", ":MainWindow", 1280, 968, 1063, 337);


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
      test::fail("Flow is fail:$strError");
   }     
}

sub SelectSynPro()
{
    snooze(1);
    waitForObjectItem(":MainWindow.QMenuBar1", "Project");
    activateItem(":MainWindow.QMenuBar1", "Project");
    waitForObjectItem(":MainWindow.QMenuBar1.Project", "Synthesis Tool...");
    snooze(1);
    activateItem(":MainWindow.QMenuBar1.Project", "Synthesis Tool...");
    waitForObject(":MainWindow.Select Synthesis Tool.Synthesis Tools:.Synplify Pro");
    clickButton(":MainWindow.Select Synthesis Tool.Synthesis Tools:.Synplify Pro");
    waitForObject(":MainWindow.Select Synthesis Tool.OK");
    clickButton(":MainWindow.Select Synthesis Tool.OK");
}


sub SelectLse()
{
    snooze(1);
    waitForObjectItem(":MainWindow.QMenuBar1", "Project");
    activateItem(":MainWindow.QMenuBar1", "Project");
    waitForObjectItem(":MainWindow.QMenuBar1.Project", "Synthesis Tool...");
    snooze(1);
    activateItem(":MainWindow.QMenuBar1.Project", "Synthesis Tool...");
    waitForObject(":MainWindow.Select Synthesis Tool.Synthesis Tools:.Lattice LSE");
    clickButton(":MainWindow.Select Synthesis Tool.Synthesis Tools:.Lattice LSE");
    waitForObject(":MainWindow.Select Synthesis Tool.OK");
    clickButton(":MainWindow.Select Synthesis Tool.OK");
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

sub copyProject($$)
{
    my ($case_dir, $work_dir) = @_;
    #Delete files in Work dir
    system("rm -fR $work_dir/*") and test::fail("Delete work files failed: $?");
    #Copy Bali Project to Work dir
    system ("cp -R $case_dir $work_dir") and test::fail("Copy project files failed: $?");
}

sub cpWork2Log($$)
{
    my ($tstname, $work, $log) = @_;
    if ( -e $log )
    {
        test::warning("$log already exists!");
    }
    else
    {
        mkdir $log || die "can not make dir $log...";
    }
    chdir($log); 
    my($sec,$min,$hour,$day,$mon,$year) = localtime();
    $mon++; 
    $year += 1900;   
    my $yyyymmddZH = sprintf("%04d%02d%02d%02d%02d", $year, $mon, $day,$hour,$min);
    my $log_bak=$log."/".$tstname.'_'.$yyyymmddZH;
    my $work_path = $work."/".$tstname;
    system("cp -R $work_path $log_bak") and test::fail("copy project files to log failed: $?");
    system("rm -fR $work/*");
}

sub waitRunEnd()
{   
 # Wait until the process has finished or the Max time is out.

   my $MAXRUNTIME = 300;
   my $timeCost = 0;
   my $objBtnStop = findObject("MainWindow.Process.Stop");
  
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

sub GetOutputMsg2($$)
{
  my ($item, $location_dir) = @_;

  my $strMainWindow = "MainWindow";
  my $strErrorWnd = "$strMainWindow.PN Error[*] View.PNOutputWindow1.PNLogWindow1";

   my $item1 = $item + 1 ;

   my $objErrorOutput = findObject("$strErrorWnd");
   my $strErrorMsg = $objErrorOutput->plainText();

   if ($strErrorMsg eq "") 
   {  test::pass("11-$item1-$location_dir pass"); }         #error capture
    else
   { test::fail("$strErrorMsg ");} 
    
   snooze(1);
}

sub GetOutputMsg3($$)
{
  my ($item, $location_dir) = @_;

  my $strMainWindow = "MainWindow";
  my $strOutputWnd = "$strMainWindow.PN Output View.PNOutputWindow1.PNLogWindow1";
 
   my $item1 = $item + 1 ;

   my $objOutput = findObject("$strOutputWnd");
   my $strOutputMsg = $objOutput->plainText();
   my $strOutputMsg2 = $objOutput->plainText();
   
   my @ErrorLine = grep {/ERROR/} split /\n/, $strOutputMsg;  
   my @ErrorCode = grep {/error code/} split /\n/, $strOutputMsg2;  
   
   if(@ErrorCode)
   {
            test::fail("---Flow is fail with error code---");
            foreach my $strErrorMsg (@ErrorCode) {test::log($strErrorMsg);} 
            test::log("---error code---");   
    }
   else
   {
       if(@ErrorLine)
        {
            test::fail("---Flow is fail with ERROR---");
            foreach my $strErrorMsg2 (@ErrorLine) {test::log($strErrorMsg2);} 
            test::log("---ERROR---");   
        }      

        else
        {  test::pass("$item1-$location_dir pass"); }         #error capture
   }
    
   snooze(1);
}

sub GetPrjInfo(\%)
{
    my $strMainWindow = "MainWindow";
    my $strProcessTree = "$strMainWindow.PN Process View.PNTreeView1";
    my $strFileTree = "$strMainWindow.PN File List View.PNTreeView1";
    my $strDesignEntry = "$strFileTree.item_0/0";
    my $strDeviceEntry = "$strDesignEntry.item_0/0";
      
    my ($hashRef) = @_;
    waitForObjectItem("$strProcessTree", "Export Files", 600000);#10min
    
    my $objDesignName = findObject("$strDesignEntry");
    my $objDeviceItem = findObject("$strDeviceEntry");
    my $objImpl;
    my @objImplItems;
    # my $objImplementationItem = findObject("MainWindow.PN File List View.PNTreeView1.item_0/0.item_2/0");
    for(my $i=2; $i<10; $i++)
    {
      
        if(object::exists("$strDesignEntry.item_$i/0"))
        {
            $objImpl = findObject("$strDesignEntry.item_$i/0");
        
            last unless $objImpl->text;
            push @objImplItems,$objImpl->text;
        }
        else
        {
            last;
        }
    }
   
    my $strDesignName = $objDesignName->text;
    my $strDeviceName = $objDeviceItem->text;
    $$hashRef{"Design"} = $strDesignName;
    $$hashRef{"Device"} = $strDeviceName;
    $$hashRef{"Impl"} = \@objImplItems;
  
    test::log("Device Name : $$hashRef{Device}");
    #test::log("Implementation Name : @{$$hashRef{Impl}}");
}
     