#!/usr/bin/env perl

use warnings;
#use strict;
use Data::Dumper;

$var = "str01";
$num = 123;

print "$var\n";
print "$num\n";

sub ensure_ag_installed {
  my ($ag_path) = map {chomp;
    $_} qx(which ag 2>/dev/null);
  if (!defined($ag_path) || (!-e $ag_path)) {
    printf STDERR "ag is missing, please install ag at first, refer to https://github.com/ggreer/the_silver_searcher\n";
    exit 1; 
  }
  
}

ensure_ag_installed;

my $ignore_pattern = join "", map {" --ignore '$_' "} qw(*test* *benchmark* "CMakeFiles* *contrib/* *thirdparty/* *3rd-[pP]arty/* *3rd[pP]arty/*");
my $cpp_filename_pattern = qq/'\\.(c|cc|cpp|C|h|hh|hpp|H)\$'/;

sub multiline_break_enabled() {
  my ($enabled) = map {chomp;
    $_} qx(echo enabled|ag --multiline-break enabled 2>/dev/null);
  return defined($enabled) && $enabled eq "enabled";
}

print "$ignore_pattern\n";
print "$cpp_filename_pattern\n";

sub all_sub_classes() {
  my $attr_re = "\\[\\[[^\\[\\]]+\\]\\]";
  my $template_specifier_re = "final|private|public|protected";
  my $template_arguments_re = "<([^<>]*(?:<(?1)>|[^<>])[^<>]*)?>";
  my $cls_re = "^\\s*(template\\s*$template_arguments_re)?(?:\\s*typedef)?\\s*\\b(class|struct)\\b\\s*([a-zA-Z_]\\w*)\\s*[^{};*()=]*?{";
  my $cls_filter_re = "";

  my $cache_file = ".cpptree.list"
  my @matches = ();

  my $multiline_break = ""
  if (multiline_break_enabled()) {
    $multiline_break = "--multiline-break";
  }

  if ((-f $cache_file) && file_newer_than_script($cache_file)) {
    @matches = map {chomp;
     $_} qx(cat $cache_file);
   qx(touch $cache_file);
  }
}
 


my @cls  = shift || die "missing class name";
my @filter = shift;
my @verbose = shift;
my @depth = shift;


$filter = ".*" unless (defined($filter) && $filter ne "");
$verbose = undef if (defined($verbose) && $verbose == 0);
$depth = 100000 unless defined($depth);

print $filter;
print $verbose;
print $depth;

