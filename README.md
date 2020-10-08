## Synopsis

This repo is a collection of utility scripts.  Their function will range and are works in progress.

## Descriptions

- word_frequency.pl - will produce a list of words and how often they appear in the body of a webpage.

## Dependencies
### word_frequency.pl
`cpan install Mojo::DOM`  
`cpan install Mojo::Collection`  
`cpan install Mojo::UserAgent`

## Usage

Calling perl is only needed if you do not make the script executable

`perl -s word_frequency.pl -url=URL`  
`perl -s word_frequency.pl -help`
