-- Add National Level to Administrative Units Table
alter table au_1 add column natlevel varchar(10) default '1stOrder';
alter table au_2 add column natlevel varchar(10) default '2ndOrder';
alter table au_3 add column natlevel varchar(10) default '3rdOrder';
alter table au_4 add column natlevel varchar(10) default '4thOrder';
alter table au_5 add column natlevel varchar(10) default '5thOrder';

-- Create table Administrative Units from 5 National Level tables
create table au as select * from au_1;
insert into au select * from au_2;
insert into au select * from au_3;
insert into au select * from au_4;
insert into au select * from au_5; 


alter table au add column xml xml;
update au
set 
  xml = xmlelement(name "adminunits", 
  	xmlattributes('http://www.opengis.net/gml/3.2' as "xmlns:gml", 'HU.FOMI.AU.'||shn as "gml:id"), 
  	xmlforest(
  		shn as id, 
  		namn as name, 
  		icc as code, 
  		shn as natcode, 
  		desn as levelname, 
  		natlevel as level, 
  		st_asgml(3,geom,10,2)::xml as geometria));

select addgeometrycolumn('au','env',4258,'POLYGON',2);
update au
	set env = st_envelope(st_transform(geom,4258));

--Geometry visible only on certain zoom levels.
--Map goes to correct location

