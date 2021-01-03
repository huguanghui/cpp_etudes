#!/usr/bin/env perl

use warnings;
#use strict;

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
