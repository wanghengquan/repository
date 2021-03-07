#! /usr/bin/perl
# -----------------------------------------------------------------------------
# $Header: $
# $KeysEnd$
# -----------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# Process the chip_ice16pstruct.v file from HW team to fix
# the various issues found from verification.
#
# HW netlist is from
# */icecream/Engineering/verification/device/ICE40P16SF/chip_ice16pstruct.v
# ------------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# library
# -----------------------------------------------------------------------------
  use Getopt::Long;
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# command line
# -----------------------------------------------------------------------------
  $program = $0; $program =~ s/.*\///;
  $opt = &GetOptions(\%{$db{opt}}, 'h');

  if (!$opt || $db{opt}{h} || @ARGV != 1) {
    print STDERR "Usage: $program [options] <FC file>\n";
    print STDERR "Options\n";
    print STDERR " -h => print this help\n";
    exit(1);
  }

  $db{arg}{file} = $ARGV[0];
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# main program
# -----------------------------------------------------------------------------
  open(IFP, $db{arg}{file}) || die "Can't open file, $db{arg}{file}";
  # need to look back 6 lines so create a 6 deep FIFO
  # 5 lines + the 6th in the loop
  #$line = <IFP>; chomp($line); push(@fifo, $line);
  #$line = <IFP>; chomp($line); push(@fifo, $line);
  #$line = <IFP>; chomp($line); push(@fifo, $line);
  # New requirement for thunder
  # just need to look back 3 lines so create a 3 deep FIFO
  # 2 lines + the 3th in the loop
  $line = <IFP>; chomp($line); push(@fifo, $line);
  $line = <IFP>; chomp($line); push(@fifo, $line);
  while (<IFP>) {
    $line = $_; chomp($line); push(@fifo, $line);

    &commentoutmodule(\%db, \@fifo);
    &replaceinstance(\%db, \@fifo);
    &modify(\%db, \@fifo);
  }
  close(IFP);

  # process the remaining item in fifo
  while (@fifo != 0) { &modify(\%db, \@fifo); }

  # check if all the changes were made
  $maxfix = 3;
  $fix = $db{commentoutvddp}{fix}   +
         #$db{fixsmcjtagid}{fix}     +
         #$db{fixcmosswap}{fix}      +
         $db{commentoutmodule}{fix} +
         $db{replaceinstance}{fix};
  if ($fix == $maxfix) {
    print STDERR "All replacement done\n";
  } else {
    print STDERR "All replacement not done, $fix out of $maxfix\n";
  }
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# SF16 netlist assume there are 5 lines between endmodule to module
  sub commentoutmodule {
    my ($Hash, $Fifo) = @_;
    my ($i);

    # only process the 6th lines (where module is) because of assumption above
    $i = @$Fifo - 1;
    if ($$Fifo[$i] =~ /module inv_25 / ||
        $$Fifo[$i] =~ /module nand2_25 / ||
        $$Fifo[$i] =~ /module nand3_25 / || 
        $$Fifo[$i] =~ /module nand4_25 / ||
        $$Fifo[$i] =~ /module anor31_hvt / ||
        $$Fifo[$i] =~ /module creset_filter / ||
        $$Fifo[$i] =~ /module eh_core_pup_2 / ||
        $$Fifo[$i] =~ /module eh_io_pup_2_new_ice8p / ||
        $$Fifo[$i] =~ /module ml_rowdrvsup2 / ||
        $$Fifo[$i] =~ /module tiehi / ||
        $$Fifo[$i] =~ /module tielo / ||
        $$Fifo[$i] =~ /module ml_osc / ||
        $$Fifo[$i] =~ /module tiehi4x / ||
        $$Fifo[$i] =~ /module tielo4x / ||
        $$Fifo[$i] =~ /module dffrckb / ||
        $$Fifo[$i] =~ /module cebdffrqn / ||
        $$Fifo[$i] =~ /module ioin_mux_v2 / ||
        $$Fifo[$i] =~ /module ioin_mux_v3 / ||
        $$Fifo[$i] =~ /module rppolywo / ||
        $$Fifo[$i] =~ /module SDDIOBREAK_sbt_a / ||
        $$Fifo[$i] =~ /module SCORNER_sbt_a / ||
        $$Fifo[$i] =~ /module SVDD_sbt_a / ||
        $$Fifo[$i] =~ /module SVDDIO_sbt_a / ||
        $$Fifo[$i] =~ /module SVSS_sbt_a / ||
        $$Fifo[$i] =~ /module SUMB_sbt_8mA_PD / ||
        $$Fifo[$i] =~ /module SUMB_bscan_8mA / ||
        $$Fifo[$i] =~ /module SUMB_bscan_HX / ||
        $$Fifo[$i] =~ /module SUMB_bscan_HX8mA / ||
        $$Fifo[$i] =~ /module SUMB_bscan_8mA_poc / ||
        $$Fifo[$i] =~ /module io_r2rinbuf_comptbl / ||
        $$Fifo[$i] =~ /module smc_and_jtag_id_u40 / ||
        $$Fifo[$i] =~ /module leafcell_2prf_4kip_u40_schematic / ||
        $$Fifo[$i] =~ /module nvcm_top_id_u40 / ||
        $$Fifo[$i] =~ /module i2c_ip / ||
        $$Fifo[$i] =~ /module spi_ip / ||
        $$Fifo[$i] =~ /module osc_clkm / ||
        $$Fifo[$i] =~ /module osc_clkk / ||
        $$Fifo[$i] =~ /module odrv4 / ||
        $$Fifo[$i] =~ /module exor2_25 / ||
        $$Fifo[$i] =~ /module exor2_hvt / ||
        $$Fifo[$i] =~ /module inv_lvt / ||
        $$Fifo[$i] =~ /module inv / ||
        $$Fifo[$i] =~ /module inv_hvt / ||
        $$Fifo[$i] =~ /module inv_tri_2_hvt / ||
        $$Fifo[$i] =~ /module mux2_hvt / ||
        $$Fifo[$i] =~ /module nand2_lvt / ||
        $$Fifo[$i] =~ /module nand2 / ||
        $$Fifo[$i] =~ /module nand2_hvt / ||
        $$Fifo[$i] =~ /module nand3 / ||
        $$Fifo[$i] =~ /module nand3_hvt / ||
        $$Fifo[$i] =~ /module nand4_hvt / ||
        $$Fifo[$i] =~ /module nor2_lvt / ||
        $$Fifo[$i] =~ /module nor2 / ||
        $$Fifo[$i] =~ /module nor2_hvt / ||
        $$Fifo[$i] =~ /module in_mux_nand_icc / ||
        $$Fifo[$i] =~ /module clk_mux12to1_icc / ||
        $$Fifo[$i] =~ /module sbox1m3to1_icc / ||
        $$Fifo[$i] =~ /module in_mux_icc / ||
        $$Fifo[$i] =~ /module g_mux / ||
        $$Fifo[$i] =~ /module mux_4carry / ||
        $$Fifo[$i] =~ /module ce_clkm8to1 / ||
        $$Fifo[$i] =~ /module clk_mux12to1 / ||
        $$Fifo[$i] =~ /module odrv12 / ||
        $$Fifo[$i] =~ /module sbox7to1_220 / ||
        $$Fifo[$i] =~ /module sr_clkm8to1 / ||
        $$Fifo[$i] =~ /module o_mux / ||
        $$Fifo[$i] =~ /module eh_cram_cell_4 / ||
        $$Fifo[$i] =~ /module coredffr / ||
        $$Fifo[$i] =~ /module clk_mux2to1 / ||
        $$Fifo[$i] =~ /module clut4vic / ||
        $$Fifo[$i] =~ /module carry_logic_nand / ||
        $$Fifo[$i] =~ /module ABIWUBN2/) {
      print "/*\n"; # start commenting out this module
      $$Hash{commentoutmodule}{found} = 1;
      $$Hash{commentoutmodule}{fix} = 1;
    }
  }

  sub commentoutmodule2 {
    my ($Hash, $Line) = @_;

    if ($$Hash{commentoutmodule}{found} == 1 && $$Line =~ /endmodule/) {
      print "*/\n";
      $$Hash{commentoutmodule}{found} = 0;
    }
  }
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# replace the nvcm model from schematic with behavioral simple model
  sub replaceinstance {
    my ($Hash, $Fifo) = @_;

    if ($$Fifo[0] =~ / I_ml_chip_nvcm/) {
      $$Fifo[0] = "/*\n" . $$Fifo[0];
      $$Hash{replaceinstance}{found} = 1;
      $$Hash{replaceinstance}{fix} = 1;
    } elsif ($$Hash{replaceinstance}{found} == 1 && $$Fifo[0] =~ /\);/) {
      $$Fifo[0] = $$Fifo[0] . "\n*/\n";
      $$Fifo[0] = $$Fifo[0] . "nvcm_model I_ml_chip_nvcm ( .rst_b(rst_bd), .clk(clk),\n";
      $$Fifo[0] = $$Fifo[0] . ".fsm_nv_bstream(fsm_nv_bstream), .fsm_nv_rri_trim(fsm_nv_rri_trim),\n";
      $$Fifo[0] = $$Fifo[0] . ".fsm_nv_sisi_ui(fsm_nv_sisi_ui), .fsm_nv_redrow(fsm_nv_redrow),\n";
      $$Fifo[0] = $$Fifo[0] . ".fsm_coladd({2'b0, fsm_coladd[9:0]}), .fsm_rowadd( fsm_rowadd[8:0]),\n";
      $$Fifo[0] = $$Fifo[0] . ".fsm_blkadd(fsm_blkadd[3:0]), .fsm_pgm(fsm_pgm), .fsm_rd(fsm_rd),\n";
      $$Fifo[0] = $$Fifo[0] . ".fsm_pgmhv(fsm_pgmhv), .fsm_din(fsm_din), .fsm_sample(fsm_sample),\n";
      $$Fifo[0] = $$Fifo[0] . ".nv_dataout(nv_dataout[8:0]));\n";
      $$Hash{replaceinstance}{found} = 0;
    }
  }
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
  sub modify {
    my ($Hash, $Fifo) = @_;
    my ($line);

    # pick the first-in for processing
    $line = shift(@$Fifo);
    &commentoutvddp($Hash, \$line);
    #&fixsmcjtagid($Hash, \$line);
    #&fixcmosswap($Hash, \$line);
    print $line, "\n";
    &commentoutmodule2($Hash, \$line);
  }
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
  sub commentoutvddp {
    my ($Hash, $Line) = @_;

    if ($$Line =~ /^wire vddp_ = test.cds_globalsInst.vddp_/) {
     $$Line = "//" . $$Line;
    }
    if ($$Line =~ /^NCAP_25_LP/) {
     $$Line = "//" . $$Line;
    }
    if ($$Line =~ /^NCAP_ice4p0nvcm2_5/) {
     $$Line = "//" . $$Line;
    }
    if ($$Line =~ /^NCAP_ice4p0nvcm2_95/) {
     $$Line = "//" . $$Line;
    }


#    if ($$Line =~ /^endspecify$/) {
#       $$Line = $$Line . "
#supply1 vddp_,vdd_,VDD_; 
#supply0 gnd_,GND_;";
#    }
#      $$Line =~ s/cds_globals\.\\vddp!/vddp_/g;               
#      $$Line =~ s/cds_globals\.\\vdd!/vdd_/g;               
#      $$Line =~ s/cds_globals\.\\VDD!/VDD_/g;               
#      $$Line =~ s/cds_globals\.\\gnd!/gnd_/g;                 
#      $$Line =~ s/cds_globals\.\\GND!/GND_/g;                

    $$Hash{commentoutvddp}{fix} = 1;
  }
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
  sub fixsmcjtagid {
    my ($Hash, $Line) = @_;

    if ($$Line =~ /smc_and_jtag_id I_smc_and_jtag_id/) {
      $$Hash{fixsmcjtagid}{found} = 1;
    }
    if ($$Hash{fixsmcjtagid}{found} == 1) {
      if ($$Line =~ /endmodule/) {
        $$Hash{fixsmcjtagid}{found} = 0;
      } elsif ($$Line =~ /\.bm_sa\(bm_sa_i\[10:0\]\)/) {
        $$Line =~ s/\.bm_sa\(bm_sa_i\[10:0\]\)/.bm_sa(bm_sa_i[9:0])/;
        $$Hash{fixsmcjtagid}{fix} = 1;
        $$Hash{fixsmcjtagid}{found} = 0;
      }
    }
  }
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
  sub fixcmosswap {
    my ($Hash, $Line) = @_;

    if ($$Line =~ /module clk_mux2to1_ice8p/) {
      $$Hash{fixcmosswap}{found} = 1;
      $$Hash{fixcmosswap}{count} = 0;
    }
    if ($$Hash{fixcmosswap}{found} == 1 &&
        $$Hash{fixcmosswap}{count} != 8) {
      if ($$Line =~ /\.D\(vdd_/) {
        $$Line =~ s/\.D\(vdd_/.S(vdd_/;
        $$Hash{fixcmosswap}{count}++;
      }
      if ($$Line =~ /\.S\(l_vdd/) {
        $$Line =~ s/\.S\(l_vdd/.D(l_vdd/;
        $$Hash{fixcmosswap}{count}++;
      }
      if ($$Line =~ /\.S\(r_vdd/) {
        $$Line =~ s/\.S\(r_vdd/.D(r_vdd/;
        $$Hash{fixcmosswap}{count}++;
      }

      if ($$Hash{fixcmosswap}{count} == 8) {
        $$Hash{fixcmosswap}{fix}   = 1;
        $$Hash{fixcmosswap}{found} = 0;
      }
      if ($$Line =~ /endmodule/) {
        $$Hash{fixcmosswap}{found} = 0;
      }
    }
  }
# -----------------------------------------------------------------------------
