mapbox.load 'chuka.map-rvhdpssw', (o) =>
  @map = mapbox.map('startup-map')
  setTimeout (=>
    @map.addLayer o.layer
    @map.ui.zoomer.add()
    @map.setZoomRange(0, 8)
    @map.ui.zoombox.add() #SHIFT+click to zoom to bounding box #TODO - add this info to ui?
    @markerLayer = mapbox.markers.layer()
    interaction = mapbox.markers.interaction(@markerLayer)
    interaction.showOnHover false
    interaction.hideTooltips true
    interaction.exclusive true
    @markerLayer.factory window.markerFactory
    @map.addLayer @markerLayer
  ), 100

window.markerFactory = (mrkr) ->
  elem = mapbox.markers.simplestyle_factory(mrkr)
  MM.addEvent(elem, 'mouseover', (e) => #on marker mouseover
    # Jamie: Display company name here
  )
  MM.removeEvent(elem, 'click')
  MM.addEvent(elem, 'click', (e) => #on marker click
    @map.ease.location({ #center on marker
      lat: mrkr.geometry.coordinates[1]
      lon: mrkr.geometry.coordinates[0]
    }).zoom(@map.zoom()).optimal()
  )
  elem

window.makeMapMarkers = (companies_json) ->
  markers = []
  for c in companies_json
    if c.latitude && c.longitude
      markers.push @companyMarker(c)
  markers

window.companyMarker = (c) ->
  {
    geometry: { coordinates: [c.longitude, c.latitude] }
    properties:
      'marker-color': '#3A87AD' # badge info
      'marker-size': 'small'
      id: c.id
      type: 'company'
      title: c.name
      description: 'Test'
  }