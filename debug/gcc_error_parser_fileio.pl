#!/usr/bin/perl -w
use strict;

my $app;

# grab curent diectory
my $mydir = `cmd /c cd`;
chomp $mydir;

#receive WR output
my $infile = 'workbenchBuildOutput.txt';
open my $handle, '<', $infile;
#chomp(my @lines = <$handle>);
my @lines = <$handle>; # don't chomp; preserve newlines
close $handle;

#open handle to post-processing output
my $outfile = 'postProcessOutput.txt';
open (FILE, "> $outfile");

# (test) process each line of infile
foreach (@lines) #improvement
{
	# grab the Vxworks app currently
	# under compilation 
	if (/^(--- Building )([a-zA-Z]+)\s/)
	{
		$app = $2;		
	}
	
	############
	
	if (/^([^ ]+):([0-9]+):([0-9]+): (.*)$/)
	{
		#CASE 1:
		#input includes line and column, (e.g., 'odfcfg.c:607:25:'')
		print FILE unix2winpath($1)."($2,$3) : $4\n";
	}
	elsif (/^([^ ]+):([0-9]+): (.*)$/)
	{
		#CASE 2:
		#input includes only line; no column (e.g., 'odfcfg.c:607:')
		print FILE unix2winpath($1)."($2) : $3\n";
	}
	elsif (/^(In file included from )([^ ]+):([0-9]+):([0-9]+):$/)
	{
		#CASE 3:
		#'In file included from' with a line and column numbers
		print FILE unix2winpath($2)."($3,$4) : <==== Included from here (double-click to go to line)\n";
	}
	elsif (/^(In file included from )([^ ]+):([0-9]+):$/)
	{
		#CASE 4:
		#'In file included from' with only a line number
		print FILE unix2winpath($2)."($3) : <==== Included from here (double-click to go to line)\n";
	}
	elsif (/^(In file included from )([^ ]+):([0-9]+),$/)
	{
		#CASE 5:
		#'In file included from' with a line number, e.g., (8,)
		print FILE unix2winpath($2)."($3) : <==== Included from here (double-click to go to line)\n";
	}
	elsif (/^([^ ]+):( In function) (.*)$/)
	{
		#CASE 6:
		#'In function' 
		print FILE unix2winpath($1)."$2 -> $3\n";
	}
	elsif(/^(\s{1,}from )([^ ]+):([0-9]+):$/)
	{
		#CASE 7:
		# continuation of 'In function'
		# 			from ../src.../ with :
		# 			from ../src.../
		print FILE $1.unix2winpath($2)."($3) : <== (double-click to go to line)\n";
	}
	elsif(/^(\s{1,}from )([^ ]+):([0-9]+),$/)
	{
		#CASE 8:
		# continuation of 'In function'
		# 			from ../src.../ with coma
		# 			from ../src.../
		print FILE $1.unix2winpath($2)."($3) : <== (double-click to go to line)\n";
	}
	else
	{
		#CASE 9:
		# pass-through
		print FILE "$_";
	}
}

# close output handle
close (FILE);


sub unix2winpath
{
	my $fp = $_[0];
	#Handle "c:/xxx" paths
	if (substr($fp,1,1) eq ':')
	{
		$fp =~ s/\//\\/g;
		return $fp;
	}
	#Handle relative paths
	if (substr($fp,0,1) ne '/')
	{
		$fp =~ s/\//\\/g;
		# e.g., replace '../src' with 'Host/src'
		$fp =~ s/\.{2,2}/$app/;
		
		return "$mydir\\$fp";
	}
}


#foreach(`mount`)
#{
#	if (/^([^ \t]+) on ([^ \t]+) /)
#	{
#		if ($2 eq '/')
#		{
#			$ROOTMOUNT = $1;
#		}
#		else
#		{
#			$MOUNTS{$2} = $1;
#		}
#	}
#}

#foreach(keys %MOUNTS)
#{
#    if ($fp =~ /^$_\/(.*)$/)
#    {
#       my $suffix = $1;
#      $suffix =~ s/\//\\/g;
#     return "$MOUNTS{$_}\\$suffix";
#    }
#}
#$fp =~ s/\//\\/g;
#return $ROOTMOUNT.$fp;
