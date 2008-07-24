#!/usr/bin/env perl

use strict;
use TV08TestCore;

my $validator = shift @ARGV;
error_quit("ERROR: Validator ($validator) empty or not an executable\n")
  if (($validator eq "") || (! -f $validator) || (! -x $validator));
my $mode = shift @ARGV;

print "** Running TV08ViperValidator tests:\n";

my $totest = 0;
my $testr = 0;
my $tn = ""; # Test name

$tn = "test0";
$testr += &do_simple_test($tn, "(Base XML Generation)", "-X", "res_$tn.txt");

$tn = "test1";
$testr += &do_simple_test($tn, "(Not a Viper File)", "TV08ViperValidator_tester.pl", "res_${tn}.txt");

$tn = "test2";
$testr += &do_simple_test($tn, "(GTF files check)", "../../test/common/test1-gtf.xml ../../test/common/test2-gtf.xml -g -w", "res_$tn.txt");

$tn = "test3";
$testr += &do_simple_test($tn, "(SYS file check)", "../../test/common/test1-1fa-sys.xml ../../test/common/test1-1md-sys.xml ../../test/common/test1-same-sys.xml ../../test/common/test2-1md_1fa-sys.xml ../../test/common/test2-same-sys.xml -w", "res_$tn.txt");

$tn = "test4";
$testr += &do_simple_test($tn, "(limitto check)", "../../test/common/test1-gtf.xml ../../test/common/test2-gtf.xml -g -w -l ObjectPut", "res_$tn.txt");

$tn = "test5a";
$testr += &do_simple_test($tn, "(subEventtypes)", "../../test/common/test5-subEventtypes-sys.xml -w", "res_$tn.txt");

$tn = "test5b";
$testr += &do_simple_test($tn, "(subEventtypes + pruneEvents)", "../../test/common/test5-subEventtypes-sys.xml -w -p", "res_$tn.txt");

$tn = "test5c";
$testr += &do_simple_test($tn, "(subEventtypes + pruneEvents + removeSubEventtypes)", "../../test/common/test5-subEventtypes-sys.xml -w -p -r", "res_$tn.txt");

$tn = "test6";
$testr += &do_simple_test($tn, "(crop)", "../../test/common/test1-1fa-sys.xml -w -p -c 1118:2000 -f 25", "res_$tn.txt");

$tn = "test7a";
$testr += &do_simple_test($tn, "(ChangeType SYS -> REF)", "../../test/common/test1-1fa-sys.xml ../../test/common/test2-1md_1fa-sys.xml -w -C 256 -p", "res_$tn.txt");

$tn = "test7b";
$testr += &do_simple_test($tn, "(ChangeType REF -> SYS w/ randomseed)", "../../test/common/test1-gtf.xml ../../test/common/test2-gtf.xml -g -w -C 256 -p", "res_$tn.txt");

$tn = "test7c";
$testr += &do_simple_test($tn, "(ChangeType REF -> SYS w/ randomseed + find_value)", "../../test/common/test2-gtf.xml -g -w -C 256:0.120257329 -p", "res_$tn.txt");

$tn = "test8a";
$testr += &do_simple_test($tn, "(MemDump)", "../../test/common/test1-1fa-sys.xml ../../test/common/test2-1md_1fa-sys.xml -w -W text -p", "res_$tn.txt");

$tn = "test8b";
$testr += &do_simple_test($tn, "(MemDump Load)", "../../test/common/test1-1fa-sys.xml.memdump ../../test/common/test2-1md_1fa-sys.xml.memdump -w -p", "res_$tn.txt");

$tn = "test9";
$testr += &do_simple_test($tn, "(ForceFilename)", "../../test/common/test1-1fa-sys.xml ../../test/common/test2-1md_1fa-sys.xml -w -p -F newfilename", "res_$tn.txt");

$tn = "test10a";
$testr += &do_simple_test($tn, "(displaySummary -- SYS)", "../../test/common/test1-1fa-sys.xml ../../test/common/test2-1md_1fa-sys.xml ../../test/common/test5-subEventtypes-sys.xml -d 3", "res_$tn.txt");

$tn = "test10b";
$testr += &do_simple_test($tn, "(displaySummary -- REF)", "-g ../../test/common/test1-gtf.xml ../../test/common/test2-gtf.xml -d 3", "res_$tn.txt");

if ($testr == $totest) {
  ok_quit("All tests ok\n\n");
} else {
  error_quit("Not all test ok\n\n");
}

die("You should never see this :)");

##########

sub do_simple_test {
  my ($testname, $subtype, $args, $res) = @_;

  my $command = "$validator $args";
  $totest++;

  return(TV08TestCore::run_simpletest($testname, $subtype, $command, $res, $mode));
}

#####

sub ok_quit {
  print @_;
  exit(0);
}

#####

sub error_quit {
  print @_;
  exit(1);
}
