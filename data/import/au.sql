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


alter table au add column data xml;
update au
set 
  data = xmlelement(name "adminunits", xmlforest(objectid as id, namn as name, icc as code, shn as natcode, desn as levelname, natlevel as level, st_asgml(3,geom,10,1)::xml as geometria));
