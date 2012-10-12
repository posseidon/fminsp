-- Add National Level to Administrative Units Table -- 
alter table au_1 add column natlevel varchar(10) default '1stOrder';
alter table au_2 add column natlevel varchar(10) default '2ndOrder';
alter table au_3 add column natlevel varchar(10) default '3rdOrder';
alter table au_4 add column natlevel varchar(10) default '4thOrder';
alter table au_5 add column natlevel varchar(10) default '5thOrder';

-- Create table AdiminUnits from 5 National levels --
create table au as select * from au_1;
insert into au select * from au_2;
insert into au select * from au_3;
insert into au select * from au_4;
insert into au select * from au_5;


--alter table aun add column data xml;
update au
set 
  data = xmlelement(name "adminunits", xmlattributes('http://www.opengis.net/gml/3.2' as "xmlns:gml", 'HU.FOMI.AU.'||shn as "gml:id"), xmlforest(shn as id, namn as name, icc as code, shn as natcode, desn as levelname, natlevel as level, st_asgml(3,geom,10,2)::xml as geometria));

select addgeometrycolumn('au','env',4258,'POLYGON',2);
update au
	set env = st_geomfromgml(st_asgml(3,st_envelope(geom),10,1));

--update gml_objects set gml_bounded_by = st_geomfromtext('POLYGON((47.430712 21.556804,47.773724 21.556804,47.773724 22.1297205,47.430712 22.1297205,47.430712 21.556804))');
--Geometry visible only on certain zoom levels.
--Map goes to correct location

