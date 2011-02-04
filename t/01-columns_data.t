#!/usr/bin/perl -w

use Test::More;

use t::lib::Utils;

use t::app::Main;
use strict;

use DateTime;

plan tests => 5;

my $schema = t::app::Main->connect('dbi:SQLite:t/app/db/example.db');
$schema->deploy({ add_drop_table => 1 });
populate_database($schema);

my @rs = $schema->resultset('Cd')->search({'title' => 'Bad'});
my $cd = $rs[0];
my $rh_result = {'artistid' => $cd->artistid(),'cdid' => $cd->cdid(),'title' => $cd->title, 'date' => undef, 'last_listen' => undef};
is_deeply( $cd->columns_data, $rh_result, "columns_data return all column value of object");

my $artist = $cd->artist;
is_deeply($cd->artist_columns_data,$artist->columns_data, "artist_columns_data return column data of artist");

my @tracks = $cd->tracks_columns_data;
is(scalar(@tracks), 3, "3 tracks for cd `Bad'");
my @track = $schema->resultset('Track')->search({title => $tracks[0]->{'title'}});

is_deeply($track[0]->columns_data(), $tracks[0], "tracks_columns data return tracks on columns data form");

# date and datetime format
my $date  = DateTime->now();
$cd->date($date);
$cd->last_listen($date);
my $format_date = $cd->date->ymd;
my $format_last_listen = $cd->last_listen->ymd.' '.$cd->last_listen->hms;
my $rh_result_date = {'artistid' => $cd->artistid(),'cdid' => $cd->cdid(),'title' => $cd->title, 'date' => $format_date, 'last_listen' => $format_last_listen};
is_deeply( $cd->columns_data, $rh_result_date, "columns_data return all column value of object with format date");


