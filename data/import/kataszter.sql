alter table 
  mesterszallas_foldreszlet_magan
add column
  xml xml;

update 
  mesterszallas_foldreszlet_magan
set
  xml = xmlelement(name "cadastral",
          xmlforest(
            parcel_id as id,
            felulet_id as localid,
            terulet as area,
            hrsz as label,
            to_char(parcel_id,'999') || '-' || hrsz as natref,
            st_asgml(3,geom,10,1)::xml as geometria
          ));

alter table 
  mesterszallas_foldreszlet_kozt
add column
  xml xml;

update 
  mesterszallas_foldreszlet_kozt
set
  xml = xmlelement(name "cadastral",
          xmlforest(
            parcel_id as id,
            felulet_id as localid,
            terulet as area,
            hrsz as label,
            to_char(parcel_id,'999') || '-' || hrsz as natref,
            st_asgml(3,geom,10,1)::xml as geometria
          ));
  