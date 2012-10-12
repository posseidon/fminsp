shp2pgsql -s 4258 -g geom -D -I -G -W LATIN1 -N abort AU_1.shp > AU_1.sql
psql -d fomi -U fomi -f AU_1.sql
shp2pgsql -s 4258 -g geom -D -I -G -W LATIN1 -N abort AU_2.shp > AU_2.sql
psql -d fomi -U fomi -f AU_2.sql
shp2pgsql -s 4258 -g geom -D -I -G -W LATIN1 -N abort AU_3.shp > AU_3.sql
psql -d fomi -U fomi -f AU_3.sql
shp2pgsql -s 4258 -g geom -D -I -G -W LATIN1 -N abort AU_4.shp > AU_4.sql
psql -d fomi -U fomi -f AU_4.sql
shp2pgsql -s 4258 -g geom -D -I -G -W LATIN1 -N abort AU_5.shp > AU_5.sql
psql -d fomi -U fomi -f AU_5.sql

psql -d fomi -U fomi -f au.sql