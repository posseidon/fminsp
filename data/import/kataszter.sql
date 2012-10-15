select addGeometryColumn('mesterszallas_foldreszlet_kozt', 'geometria', 4258, 'MULTIPOLYGON', 2);
select addGeometryColumn('mesterszallas_foldreszlet_magan', 'geometria', 4258, 'MULTIPOLYGON', 2);

update mesterszallas_foldreszlet_kozt set geometria = st_transform(geom, 4258);
update mesterszallas_foldreszlet_magan set geometria = st_transform(geom, 4258);

alter table 
  mesterszallas_foldreszlet_magan
add column
  xml xml;

update 
  mesterszallas_foldreszlet_magan
set
  xml = xmlelement(name "cadastral", xmlattributes('http://www.opengis.net/gml/3.2' as "xmlns:gml", 'HU.FOMI.CP.'||to_char(parcel_id,'999') || '-' || hrsz as "gml:id"),
          xmlforest(
            parcel_id as id,
            felulet_id as localid,
            terulet as area,
            hrsz as label,
            to_char(parcel_id,'999') || '-' || hrsz as natref,
            st_asgml(3,geometria,10,2)::xml as geometria
          ));

alter table 
  mesterszallas_foldreszlet_kozt
add column
  xml xml;

update 
  mesterszallas_foldreszlet_kozt
set
  xml = xmlelement(name "cadastral", xmlattributes('http://www.opengis.net/gml/3.2' as "xmlns:gml", 'HU.FOMI.CP.'||to_char(parcel_id,'999') || '-' || hrsz as "gml:id"),
          xmlforest(
            parcel_id as id,
            felulet_id as localid,
            terulet as area,
            hrsz as label,
            to_char(parcel_id,'999') || '-' || hrsz as natref,
            st_asgml(3,geometria,10,2)::xml as geometria
          ));





select addGeometryColumn('mesterszallas_foldreszlet_magan', 'env', 4258, 'POLYGON', 2);
update mesterszallas_foldreszlet_magan set env = st_envelope(geometria);

select addGeometryColumn('mesterszallas_foldreszlet_kozt', 'env', 4258, 'POLYGON', 2);
update mesterszallas_foldreszlet_kozt set env = st_envelope(geometria);


