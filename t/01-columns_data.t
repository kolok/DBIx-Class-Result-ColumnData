#!/usr/bin/perl -w

use Test::More;

use t::app::Main;
use strict;

system "sqlite3 t/app/db/example.db < t/app/db/example.sql";
if ($@)
{
  plan skip_all => "sqlite3 is require for these tests : $@";
  exit;
}
else
{
  plan tests => 4;
}

system "perl t/app/insertdb.pl";

my $schema = t::app::Main->connect('dbi:SQLite:t/app/db/example.db');

my @rs = $schema->resultset('Cd')->search({'title' => 'Bad'});
my $cd = @rs[0];
my $rh_result = {'artistid' => $cd->artistid(),'cdid' => $cd->cdid(),'title' => $cd->title};
is_deeply( $cd->columns_data, $rh_result, "columns_data return all column value of object");

my $artist = $cd->artist;
is_deeply($cd->artist_columns_data,$artist->columns_data, "artist_columns_data return column data of artist");

my @tracks = $cd->tracks_columns_data;
is(scalar(@tracks), 3, "3 tracks for cd `Bad'");
my @track = $schema->resultset('Track')->search({title => $tracks[0]->{'title'}});

is_deeply($track[0]->columns_data(), $tracks[0], "tracks_columns data return tracks on columns data form");

