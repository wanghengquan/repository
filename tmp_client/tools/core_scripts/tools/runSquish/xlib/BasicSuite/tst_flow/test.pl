 ##################################################
 #Date:2013.01.22
 #Usage: This is a public used templete to record test case
 #2.13.2.27  modify setLayout() and setDefaultLayout()
 # Updated by Shawn for GUI test
 ##################################################


 use strict;
 use Cwd qw( abs_path );

 my $prjListFile = "prjlist.tsv";
 my $root_dir = `pwd`;
 chomp($root_dir);
 my $work_dir = $root_dir."/..";
 chomp($work_dir);
 #===========================================================

 sub main
 {
    waitForObject(":MainWindow",5000000);
    source(findFile("scripts", "public.pl"));
    my $myLayout = "Project_Navigator";
    my $tst_name = getTstname($root_dir);
    test::log("tst_name".$tst_name);
    setDefaultLayout();
    # GetBaliVersion();
    setLayout($myLayout);

    my @records = testData::dataset($prjListFile);
    for (my $row = 0; $row < scalar(@records); $row++) {
        my $record = $records[$row];

        my $location = testData::field($record, "location");
        my $prj_name = testData::field($record, "prj");
        my $prjlist = $work_dir."/".$location."/".$prj_name;
        $prjlist = abs_path($prjlist);

        if(! -f $prjlist)
        {
            test::fatal("Diamond Project : $prjlist doesn't exist") ;
            next;
        }
        test::log("ldf file".$prjlist);
        openProject($prjlist);

        runSynthesis();

        clickButton(waitForObject(":Lattice Diamond - Start Page.Netlist Analyzer_QToolButton"));
        waitForObjectItem( ":_SchView::private_impl::DesignTreeView",
            "Instances(2)" );
        clickItem( ":_SchView::private_impl::DesignTreeView",
            "Instances(2)", -11, 9, 0, Qt::LeftButton );
        waitForObjectItem( ":_SchView::private_impl::DesignTreeView",
            "Ports(3)" );
        clickItem( ":_SchView::private_impl::DesignTreeView",
            "Ports(3)", -9, 5, 0, Qt::LeftButton );
        waitForObjectItem( ":_SchView::private_impl::DesignTreeView",
            "Nets(6)" );
        clickItem( ":_SchView::private_impl::DesignTreeView",
            "Nets(6)", -8, 8, 0, Qt::LeftButton );
        clickButton( waitForObject(":Netlist Analyzer.Rtl View_QToolButton") );
        clickButton(
            waitForObject(":Netlist Analyzer.Technology View_QToolButton") );

            openContextMenu(waitForObject(":_NlvQWidget"), 70, 89, 0);
            activateItem(
                waitForObjectItem(
                    ":Lattice Diamond - Netlist Analyzer.My ToolBar_QMenu",
                    "Flatten Schematic"
                )
            );
            openContextMenu( waitForObject(":_NlvQWidget"), 59, 100, 0 );
            activateItem(
                waitForObjectItem(
                    ":Lattice Diamond - Netlist Analyzer.My ToolBar_QMenu",
                    "Unflatten Schematic"
                )
            );
            clickButton(
                waitForObject(":Netlist Analyzer.Rtl View_QToolButton") );
            openContextMenu( waitForObject(":_NlvQWidget"), 68, 100, 0 );
            activateItem(
                waitForObjectItem(
                    ":Lattice Diamond - Netlist Analyzer.My ToolBar_QMenu",
                    "Flatten Schematic"
                )
            );
            openContextMenu( waitForObject(":_NlvQWidget"), 99, 133, 0 );
            activateItem(
                waitForObjectItem(
                    ":Lattice Diamond - Netlist Analyzer.My ToolBar_QMenu",
                    "Unflatten Schematic"
                )
            );
            mouseClick( waitForObject(":_NlvQWidget"),
                182, 154, 0, Qt::LeftButton );
            openContextMenu( waitForObject(":_NlvQWidget"), 182, 154, 0 );
            activateItem(
                waitForObjectItem(
                    ":Lattice Diamond - Netlist Analyzer.My ToolBar_QMenu",
                    "Filter Schematic"
                )
            );

        clickButton(
            waitForObject(":Lattice Diamond - Netlist Analyzer_CloseButton") );

        test::log("Run test case!");

        closeProject();

    }
 #===========================================================

    ExitBali();
    test::log("Test finished!");

 }






