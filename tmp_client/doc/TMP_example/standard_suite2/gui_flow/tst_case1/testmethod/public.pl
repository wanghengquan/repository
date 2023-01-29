##########################################################
#This is for public used template
#Vasion:2.01
#11/23/12: Add rerunallProcess and check result function
#11/23/12: Add layout for special tools
#03/03/16: use perl-self language replace shell command cp rm
##########################################################
use File::Copy;
use File::Path;

my $os = $^O;
test::log("Current OS is $os");
### open DiamondNG
sub openNG();

### open project
### input: path of the project file
sub openProject($);  

### save Project
sub saveProject();

### close project
sub closeProject();

### exit DiamondNG
sub ExitNG();

### run all the process, from synthesis to export files
sub rerunAllProcess();
#############################################################################################
sub openNG()
{      
    if($os =~ /win/i){
        startApplication("pnmain");
    }
    if($os =~ /linux/i){
        startApplication("radiant");
    }
    #maximize window
    setWindowState(waitForObject(":PNMainWindow_PNMainWindow", 120000), WindowState::Maximize);
}

sub pathTransType($)
{   
    my ($path) = @_;       
    if($os =~ /win/i){
        $path =~ s/\//\\/g;
    }
    if($os =~ /linux/i){                
        #$path = uc($path);#uppercase.Capital is not allowed for $path 
    }            
    snooze(6);
    nativeType($path);
    snooze(2);
    nativeType("<Return>");
    snooze(1);
}

sub openProject($)
{   
    my ($prjName) = @_;
    test::log("Opening Project : $prjName");
    
    if($os =~ /win/i){
        $prjName =~ s/\//\\/g;
    }
#    if($os =~ /linux/i){                
#        $prjName = uc($prjName);#uppercase.Capital is not allowed for $prjName 
#    }
            
    clickButton(waitForObject(":PNToolFrame_QToolButton"));    
#    nativeType($prjName);
#    snooze(2);
#    nativeType("<Return>");
    #mouseClick( waitForObject(":fileNameEdit_QLineEdit"),79, 13, Qt->NoModifier, Qt->LeftButton );
    type( waitForObject(":fileNameEdit_QLineEdit"), $prjName );
    snooze(1);
    clickButton( waitForObject(":QFileDialog.Open_QPushButton") );
    snooze(3);
    if(object::exists(":Project.Yes_QPushButton")){
        clickButton(waitForObject(":Project.Yes_QPushButton"));
    }    
}

sub saveProject()
{
    snooze(1);
    activateItem(waitForObjectItem(":PNMainWindow_QMenuBar", "File"));
    activateItem(waitForObjectItem(":PNMainWindow.File_QMenu", "Save Project"));   
    snooze(1);
    test::log("Project save done");
}

sub closeProject()
{
    snooze(1);
    activateItem(waitForObjectItem(":PNMainWindow_QMenuBar", "File"));
    activateItem(waitForObjectItem(":PNMainWindow.File_QMenu", "Close Project"));        
    snooze(1);
    if(object::exists(":Save Modified Files.OK_QPushButton")){
        clickButton(waitForObject(":Save Modified Files.OK_QPushButton"));
    }
}


sub ExitNG()
{
    snooze(1);
    activateItem(waitForObjectItem(":PNMainWindow_QMenuBar", "File"));
    activateItem(waitForObjectItem(":PNMainWindow.File_QMenu", "Exit")); 
    snooze(1);
}


sub rerunAllProcess()
{   
   #Start Rerun All process
   snooze(1);
   openContextMenu(waitForObject(":PNMainWindow.PnProcessIconBtn_QToolButton"), 8, 10, 0);
   activateItem(waitForObjectItem(":_QMenu", "Force Run from Start"));
   snooze(3);
   # Wait until the process has finished or the Max time is out.
   my $MAXRUNTIME = 3600;
   my $timeCost = 0;
   my $objTCE = findObject(":PNMainWindow.Device Constraint Editor_QToolButton");
   
   while(($objTCE->enabled == 0) && ($timeCost != $MAXRUNTIME))
   {
      snooze(1);
      $timeCost++;
   }
   #test::log("ok $objTCE_enable"); 
   if($timeCost==$MAXRUNTIME)
   {
       test::fail("MAXRUNTIME is out");       
       if($objTCE->enabled == 0) {
            clickButton(waitForObject(":PNMainWindow_QToolButton"));#stop
       }
   }
   snooze(1);
   test::log("Rerun All process done");
}


sub runsynProcess()
{   
   #Start Rerun All process
   clickButton(waitForObject(":PNMainWindow.PnProcessLabelBtn_QToolButton"));
   snooze(3);
   # Wait until the process has finished or the Max time is out.
   my $MAXRUNTIME = 3600;
   my $timeCost = 0;
   my $objTCE = findObject(":PNMainWindow.Device Constraint Editor_QToolButton");
   
   while(($objTCE->enabled == 0) && ($timeCost != $MAXRUNTIME))
   {
      snooze(1);
      $timeCost++;
   }
   #test::log("ok $objTCE_enable"); 
   if($timeCost==$MAXRUNTIME)
   {
       test::fail("MAXRUNTIME is out");       
       if($objTCE->enabled == 0) {
            clickButton(waitForObject(":PNMainWindow_QToolButton"));#stop
       }
   }
   snooze(1);
   test::log("Rerun syn process done");
}

sub runmapProcess()
{   
   #Start Rerun All process
   clickButton(waitForObject(":PNMainWindow.PnProcessLabelBtn_QToolButton_2"));
   snooze(3);
   # Wait until the process has finished or the Max time is out.
   my $MAXRUNTIME = 3600;
   my $timeCost = 0;
   my $objTCE = findObject(":PNMainWindow.Device Constraint Editor_QToolButton");
   
   while(($objTCE->enabled == 0) && ($timeCost != $MAXRUNTIME))
   {
      snooze(1);
      $timeCost++;
   }
   #test::log("ok $objTCE_enable"); 
   if($timeCost==$MAXRUNTIME)
   {
       test::fail("MAXRUNTIME is out");       
       if($objTCE->enabled == 0) {
            clickButton(waitForObject(":PNMainWindow_QToolButton"));#stop
       }
   }
   snooze(1);
   test::log("Rerun map process done");
}

sub runparProcess()
{   
   #Start Rerun All process
   clickButton(waitForObject(":PNMainWindow.PnProcessLabelBtn_QToolButton_3"));
   snooze(3);
   # Wait until the process has finished or the Max time is out.
   my $MAXRUNTIME = 3600;
   my $timeCost = 0;
   my $objTCE = findObject(":PNMainWindow.Device Constraint Editor_QToolButton");
   
   while(($objTCE->enabled == 0) && ($timeCost != $MAXRUNTIME))
   {
      snooze(1);
      $timeCost++;
   }
   #test::log("ok $objTCE_enable"); 
   if($timeCost==$MAXRUNTIME)
   {
       test::fail("MAXRUNTIME is out");       
       if($objTCE->enabled == 0) {
            clickButton(waitForObject(":PNMainWindow_QToolButton"));#stop
       }
   }
   snooze(1);
   test::log("Rerun par process done");
}

sub runexportProcess()
{   
   #Start Rerun All process
   clickButton(waitForObject(":PNMainWindow.PnProcessLabelBtn_QToolButton_4"));
   snooze(3);
   # Wait until the process has finished or the Max time is out.
   my $MAXRUNTIME = 3600;
   my $timeCost = 0;
   my $objTCE = findObject(":PNMainWindow.Device Constraint Editor_QToolButton");
   
   while(($objTCE->enabled == 0) && ($timeCost != $MAXRUNTIME))
   {
      snooze(1);
      $timeCost++;
   }
   #test::log("ok $objTCE_enable"); 
   if($timeCost==$MAXRUNTIME)
   {
       test::fail("MAXRUNTIME is out");       
       if($objTCE->enabled == 0) {
            clickButton(waitForObject(":PNMainWindow_QToolButton"));#stop
       }
   }
   snooze(1);
   test::log("Rerun export process done");
}

sub clickTableOption(@)
{
    my ($table, $itemName, $column,)   = @_; 
    #example: clickTableOption(":Strategies - abc_bali::strategygui::TableView", "Allow Duplicate Modules", 2);
    my $tableView       = waitForObject($table);
    my $model          = $tableView->model();  
    my @children=object::children($tableView);

    my $is_row = 0; 
    my $stop_traverse = 0;
    my $cur_column = 0;
    
    foreach $child (@children)
    { 
        my $typename = typeName($child);    
        if ($typename eq "QModelIndex&")
        {
            if ($model->hasChildren($child))
            {
                my @items2 = object::children($child);
                
                foreach $item2 (@items2)
                {
                    my $item2_text = $item2->text;                   
                    if ($is_row)
                    {
                        $cur_column = $cur_column + 1;
                        if($cur_column == $column)
                        {
                            my $x = $tableView->visualRect($item2)->topLeft()->x();
                            my $y = $tableView->visualRect($item2)->topLeft()->y();
                            mouseClick($tableView, ($x+10), ($y+10), 0, Qt::LeftButton);                            
                            $stop_traverse = 1;
                        }

                    }
                    last if($stop_traverse);
                    if ($item2_text =~ $itemName )
                    {
                        $is_row = 1;
                    }
                }
                last if($stop_traverse)
            }            
            else 
            {
                if ($is_row)
                {              
                    $cur_column = $cur_column + 1;
                    if($cur_column == $column)
                    {
                        my $x = $tableView->visualRect($child)->topLeft()->x();
                        my $y = $tableView->visualRect($child)->topLeft()->y();
                        mouseClick($tableView, ($x+10), ($y+10), 0, Qt::LeftButton);                        
                        $stop_traverse = 1;
                    }             
                }               
                last if($stop_traverse);
                my $item_text = $child->text;                  
                if ($item_text =~ $itemName )
                {
                    $is_row = 1;                              
                }
            }
        }
        
    }
    if ($is_row == 0 )
    {test::fail("fail to find object $itemName"); }
         
}

sub waitForFocus()
{
    my $MAXRUNTIME = 10;
    my $timeCost = 0;
    my $widget = QApplication::focusWindow();
    while (($timeCost != $MAXRUNTIME) && (index($widget->objectName(), "PNMainWindow") == -1))
    {                              
        $timeCost++;
        snooze(3);
        $widget = QApplication::focusWindow();        
    } 
   if($timeCost==$MAXRUNTIME)
   {test::fail("MAXRUNTIME is out");  }
}
