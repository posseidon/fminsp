create view 
  fnt 
as 
  select 
    n.objectid, 
    n.nev, 
    t.tipusnev, 
    te.tipus_name as typename, 
    f.forrasnev, 
    n.geometria, 
    st_asgml(3,n.geometria,10,0) as gml 
  from 
    fnt_orszagos_jav n, 
    tipus t, 
    tipus_en te, 
    forras f 
  where 
    n.tipus_id = t.id and 
    t.id = te.id and 
    n.forras1 = f.id;
