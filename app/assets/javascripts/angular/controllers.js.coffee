@CompaniesCtrl = ['$scope', '$http', ($scope, $http) ->
  markerFactory: (mrkr) ->
    elem = mapbox.markers.simplestyle_factory(mrkr)
    MM.addEvent(elem, 'mouseover', (e) => #on marker mouseover
      # Jamie: Display company name here
    )
    MM.removeEvent(elem, 'click')
    MM.addEvent(elem, 'click', (e) => #on marker click
      $scope.map.ease.location({ #center on marker
        lat: mrkr.geometry.coordinates[1]
        lon: mrkr.geometry.coordinates[0]
      }).zoom($scope.map.zoom()).optimal()
    )
    elem

  makeMapMarkers: (companies_json) ->
    markers = []
    for c in companies_json
      if c.latitude && c.longitude
        markers.push companyMarker(c)
    markers

  companyMarker: (c) ->
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

  mapbox.load 'chuka.map-rvhdpssw', (o) =>
    $scope.map = mapbox.map('startup-map')
    setTimeout (=>
      $scope.map.addLayer o.layer
      $scope.map.ui.zoomer.add()
      $scope.map.setZoomRange(0, 8)
      $scope.map.ui.zoombox.add() #SHIFT+click to zoom to bounding box #TODO - add this info to ui?
      $scope.markerLayer = mapbox.markers.layer()
      interaction = mapbox.markers.interaction($scope.markerLayer)
      interaction.showOnHover false
      interaction.hideTooltips true
      interaction.exclusive true
      $scope.markerLayer.factory markerFactory
      $scope.map.addLayer $scope.markerLayer
      $scope.markerLayer.features makeMapMarkers($scope.companies)
    ), 100

  $http.get('/companies.json', {}).success((response) ->
    $scope.companies = response
    if $scope.markerLayer
      $scope.markerLayer.features makeMapMarkers(response)
  ).error((error) ->
    # Jamie: Handle this
  )
]