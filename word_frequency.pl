#/usr/bin/env perl -s

use strict;
use warnings;
use v5.10;
use vars qw($url $help);
use Mojo::UserAgent;

if($help){
    say 'usage: perl -s install_certs.pl -url=URL';
	exit;
}

if($url eq ''){
    say 'We need a url to operate on.';
    exit;
}

my $ua = Mojo::UserAgent->new;

my $response = $ua->get($url)->result;

my $freq_map = {};

if    ($response->is_success)  { traverse_dom($response->dom->find('body'),$freq_map) }
elsif ($response->is_error)    {say $response->message}
elsif ($response->code == 301) {say "Use this url instead: " . $response->headers->location}
else                      {say 'Things failed miserably'; exit;}

use Data::Dumper;
warn Dumper $freq_map;

sub traverse_dom{
    my ($dom,$text) = @_;

    my $children = 0;
    if(ref $dom eq 'Mojo::Collection'){
        $children = $dom->[0]->child_nodes;
    } elsif(ref $dom eq 'Mojo::DOM'){
        $children = $dom->child_nodes;
    }

    if($children->size > 0){
        foreach my $child (@{$children}){
            if(defined($child->tag) && $child->tag ne 'script'){
                traverse_dom($child,$text);
            }
        }
    }

    my @words = ();
    if(ref $dom eq 'Mojo::Collection'){
        @words = split(/\s+/,$dom->[0]->text);
    } else {
        @words = split(/\s+/,$dom->text);
    }

    foreach (@words){
        unless(exists($text->{$_})){
            $text->{lc($_)} = 0;
        }

        $text->{lc($_)}++;
    }

    return;
}

1;
