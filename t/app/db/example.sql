
DROP TABLE IF EXISTS artist;

  CREATE TABLE artist (
    artistid INTEGER PRIMARY KEY,
    name TEXT NOT NULL
  );

DROP TABLE IF EXISTS cd;
  CREATE TABLE cd (
    cdid INTEGER PRIMARY KEY,
    artistid INTEGER NOT NULL REFERENCES artist(artistid),
    title TEXT NOT NULL,
    date DATE,
    last_listen DATETIME
  );

DROP TABLE IF EXISTS track;
  CREATE TABLE track (
    trackid INTEGER PRIMARY KEY,
    cdid INTEGER NOT NULL REFERENCES cd(cdid),
    title TEXT NOT NULL
  );
