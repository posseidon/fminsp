
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

--update gml_objects set gml_bounded_by = st_geomfromtext('POLYGON((47.430712 21.556804,47.773724 21.556804,47.773724 22.1297205,47.430712 22.1297205,47.430712 21.556804))');
--Geometry visible only on certain zoom levels.
--Map goes to correct location

