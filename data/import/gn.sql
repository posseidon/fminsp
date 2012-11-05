select addGeometryColumn('fnt_orszagos_jav','geometria',4258,'POINT',2);
update fnt_orszagos_jav set geometria = st_transform(geom, 4258);


create table 
  fnt 
as 
  select 
    n.objectid, 
    n.nev, 
    t.tipusnev, 
    te.tipus_name as tipus_name, 
    f.forrasnev, 
    n.geometria
  from 
    fnt_orszagos_jav n, 
    tipus t, 
    tipus_en te, 
    forras f 
  where 
    n.tipus_id = t.id and 
    t.id = te.id and 
    n.forras1 = f.id;


alter table fnt add column xml xml;
update fnt set xml = xmlelement(name "geographicalname", xmlattributes('http://www.opengis.net/gml/3.2' as "xmlns:gml", 'HU.FOMI.GN.'|| nev as "gml:id"),
          xmlforest(
            nev as nev,
            tipusnev as tipusnev,
            tipus_name as tipus_name,
            forrasnev as forrasnev,
            st_asgml(3,geometria,10,2)::xml as geometria
          ));
