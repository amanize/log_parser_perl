use strict;
use warnings;

package first;

use constant {
    MODE       => '-m',
    PATH       => '-p',
    HELP       => '-h',
    DUPLICATES => 'd',
    ANAGRAMMAS => 'a',
    VERSION    => '0.0.1'
};

main();

sub main {
    printf "log_parser_perl %s\n", VERSION;
    if (defined $ARGV[0] eq HELP() ) {
        printf
"Simple log parser:\n%s set path to log file. Example: %s path/to/file\n%s set mode. Available modes: \"%s\" - duplicates, \"%s\" - anagrammas, Example: %s %s\nFull command:\nperl log_parser.pl - p path/to/file -m d\n",
          PATH, PATH, MODE, DUPLICATES, ANAGRAMMAS, MODE, DUPLICATES;
        exit 0;
    }
    my %params;
    for ( my $i = 0 ; $i < @ARGV - 1 ; $i += 2 ) {
        $params{ $ARGV[$i] } = $ARGV[ $i + 1 ];
    }
    if ( !defined $params{ PATH() } && !$params{ PATH() } ne "" ) {
        printf STDERR "Path cannot be empty. Set path by %s\n", PATH;
        exit 2;
    }
    if ( !defined $params{ MODE() } ) {
        printf STDERR "Mode not selected. Available mods: %s, %s\n",
          DUPLICATES, ANAGRAMMAS;
        exit 2;
    }
    my $path = $params{ PATH() };
    if ( $params{ MODE() } eq DUPLICATES() ) {
        findDuplicates($path);
    }
    if ( $params{ MODE() } eq ANAGRAMMAS() ) {
        findAnagrammas($path);
    }
}

sub findDuplicates {
    my $path = $_[0];
    my %lines;
    open( my $file, '<', $path ) or die "Could not open file: $!";
    while ( my $line = <$file> ) {
        chomp $line;
        push( @{ $lines{$line} }, $. );
    }
    for ( keys %lines ) {
        my @duplicates = @{ $lines{$_} };
        if ( @duplicates > 1 ) {
            printf "Record: %s, duplicates: %s\n", $_, join( ",", @duplicates );
        }
    }
    close($file);
}

sub findAnagrammas {
    my $path = $_[0];
    my %lines;
    open( my $file, '<', $path ) or die "Could not open file: $!";
    while ( my $line = <$file> ) {
        chomp $line;
        my @sortedLine = sort split //, $line;
        push( @{ $lines{ join( "", @sortedLine ) } }, $. );
    }
    for ( keys %lines ) {
        my @anagrammas = @{ $lines{$_} };
        if ( @anagrammas > 1 ) {
            printf "Record: %s, anagrammas: %s\n", $_, join( ",", @anagrammas );
        }
    }
    close($file);
}
