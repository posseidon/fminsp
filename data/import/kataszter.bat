shp2pgsql -s 4258 -g geom -D -I  -W LATIN1 -N abort MESTERSZALLAS_FOLDRESZLET_KOZT.shp > MESTERSZALLAS_FOLDRESZLET_KOZT.sql
psql -d fomi -U fomi -f MESTERSZALLAS_FOLDRESZLET_KOZT.sql
shp2pgsql -s 4258 -g geom -D -I  -W LATIN1 -N abort MESTERSZALLAS_FOLDRESZLET_MAGAN.shp > MESTERSZALLAS_FOLDRESZLET_MAGAN.sql
psql -d fomi -U fomi -f MESTERSZALLAS_FOLDRESZLET_MAGAN.sql
