// Simple client to load farmshops dataset and display filters, list and map
(async function(){
  const dataUrl = 'data/farmshops.example.json';
  let shops = [];
  try{ const r=await fetch(dataUrl); shops=await r.json(); }catch(e){console.error('Failed to load data',e);}

  const countrySelect=document.getElementById('countrySelect');
  const regionSelect=document.getElementById('regionSelect');
  const muniSelect=document.getElementById('municipalitySelect');
  const searchInput=document.getElementById('searchInput');
  const listEl=document.getElementById('list');

  // init map
  const map=L.map('map').setView([59.9,10.7],5);
  L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',{maxZoom:18,attribution:'© OpenStreetMap contributors'}).addTo(map);
  const markers=L.layerGroup().addTo(map);

  function unique(values){ return [...new Set(values)].sort(); }

  function populateCountries(){
    const countries=unique(shops.map(s=>s.country));
    countrySelect.innerHTML='<option value="">Velg land</option>' + countries.map(c=>`<option>${c}</option>`).join('');
  }

  function populateRegions(country){
    const regions=unique(shops.filter(s=>!country||s.country===country).map(s=>s.region));
    regionSelect.innerHTML='<option value="">Velg fylke/region</option>' + regions.map(r=>`<option>${r}</option>`).join('');
    muniSelect.innerHTML='<option value="">Velg kommune</option>'
  }

  function populateMunicipalities(country,region){
    const munis=unique(shops.filter(s=>(!country||s.country===country)&&(!region||s.region===region)).map(s=>s.municipality));
    muniSelect.innerHTML='<option value="">Velg kommune</option>' + munis.map(m=>`<option>${m}</option>`).join('');
  }

  function renderList(filtered){
    listEl.innerHTML='';
    markers.clearLayers();
    filtered.forEach(s=>{
      const div=document.createElement('div'); div.className='item';
      div.innerHTML=`<strong>${s.name}</strong><br>${s.address||''} ${s.municipality||''}, ${s.region||''}<br>Produkter: ${s.products.join(', ')}<br><a href='${s.website}' target='_blank'>Nettside</a>`;
      listEl.appendChild(div);
      if(s.lat && s.lon){
        const m=L.marker([s.lat,s.lon]).bindPopup(`<strong>${s.name}</strong><br>${s.address||''}`);
        markers.addLayer(m);
      }
    });
    if(markers.getLayers().length) map.fitBounds(markers.getBounds(),{maxZoom:12});
  }

  function filterShops(){
    const country=countrySelect.value;
    const region=regionSelect.value;
    const muni=muniSelect.value;
    const q=searchInput.value.trim().toLowerCase();
    let filtered=shops.filter(s=>(!country||s.country===country)&&(!region||s.region===region)&&(!muni||s.municipality===muni));
    if(q){ filtered=filtered.filter(s=>s.name.toLowerCase().includes(q) || s.products.join(' ').toLowerCase().includes(q)); }
    renderList(filtered);
    return filtered;
  }

  countrySelect.addEventListener('change',()=>{ populateRegions(countrySelect.value); populateMunicipalities(countrySelect.value,''); filterShops(); });
  regionSelect.addEventListener('change',()=>{ populateMunicipalities(countrySelect.value,regionSelect.value); filterShops(); });
  muniSelect.addEventListener('change',filterShops);
  searchInput.addEventListener('input',()=>{ filterShops(); });

  document.getElementById('resetBtn').addEventListener('click',()=>{ countrySelect.value=''; regionSelect.value=''; muniSelect.value=''; searchInput.value=''; populateRegions(''); populateMunicipalities('',''); filterShops(); });

  // route functionality: geocode start/end with Nominatim, compute simple route via OSRM public demo (best effort) or approximate polyline between points
  async function geocode(q){
    const url=`https://nominatim.openstreetmap.org/search?format=json&q=${encodeURIComponent(q)}`;
    const res=await fetch(url); const js=await res.json(); return js[0];
  }

  async function findAlongRoute(from,to){
    if(!from||!to) return;
    const f=await geocode(from); const t=await geocode(to);
    if(!f||!t){ alert('Kunne ikke finne adresser'); return; }
    // try OSRM route
    const osrmUrl=`https://router.project-osrm.org/route/v1/driving/${f.lon},${f.lat};${t.lon},${t.lat}?overview=full&geometries=geojson`;
    let routeGeom=null;
    try{ const r=await fetch(osrmUrl); const j=await r.json(); if(j.routes && j.routes[0]) routeGeom=j.routes[0].geometry; }
    catch(e){ console.warn('OSRM failed',e); }
    if(!routeGeom){ routeGeom={type:'LineString',coordinates:[[+f.lon,+f.lat],[+t.lon,+t.lat]]}; }
    // build turf line and buffer
    const line=turf.lineString(routeGeom.coordinates);
    const buffer=turf.buffer(line,25, {units:'kilometers'});
    // filter shops within buffer
    const filtered=shops.filter(s=>{
      if(!s.lat||!s.lon) return false;
      const pt=turf.point([s.lon,s.lat]);
      return turf.booleanPointInPolygon(pt,buffer);
    });
    renderList(filtered);
    // draw route on map
    if(window._routeLayer) map.removeLayer(window._routeLayer);
    window._routeLayer=L.geoJSON(routeGeom,{style:{color:'blue',weight:3}}).addTo(map);
    const bufLayer=L.geoJSON(buffer,{style:{color:'#00f',weight:1,opacity:0.15}}).addTo(map);
    setTimeout(()=>{ if(bufLayer) map.removeLayer(bufLayer); },10000);
    if(markers.getLayers().length) map.fitBounds(markers.getBounds(),{maxZoom:12});
  }

  document.getElementById('routeBtn').addEventListener('click',()=>{ const f=document.getElementById('routeFrom').value; const t=document.getElementById('routeTo').value; findAlongRoute(f,t); });

  // init
  populateCountries(); populateRegions(''); populateMunicipalities('','');
  renderList(shops);

})();
