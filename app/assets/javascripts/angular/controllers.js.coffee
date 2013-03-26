@startupApp.controller 'CompaniesCtrl', (['$scope', '$http', ($scope, $http) ->
  # $scope.loadMoreCompanies = () ->
  #   last = $scope.visibleCompanies.length - 1
  #   $scope.visibleCompanies = $scope.visibleCompanies.concat($scope.companies.slice(last, last + 10))

  markerFactory = (mrkr) ->
    elem = mapbox.markers.simplestyle_factory(mrkr)
    MM.addEvent(elem, 'mouseover', (e) => #on marker mouseover
      $scope.hovered_company = mrkr.properties.title
    )
    MM.addEvent(elem, 'click', (e) => #on marker click
      $scope.map.ease.location({ #center on marker
        lat: mrkr.geometry.coordinates[1]
        lon: mrkr.geometry.coordinates[0]
      }).zoom($scope.map.zoom()).optimal()
    )
    elem

  makeMapMarkers = (companies_json) ->
    markers = []
    for c in companies_json
      if c.latitude && c.longitude
        markers.push companyMarker(c)
    markers

  companyMarker = (c) ->
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

  mapbox.auto('startup-map', 'chuka.map-rvhdpssw', (map, o) ->
    $scope.map = map
    $scope.map.addLayer o.layer
    $scope.markerLayer = mapbox.markers.layer()
    interaction = mapbox.markers.interaction($scope.markerLayer)
    interaction.showOnHover false
    interaction.hideTooltips true
    interaction.exclusive true
    $scope.markerLayer.factory markerFactory
    $scope.map.addLayer $scope.markerLayer
    $scope.markerLayer.features makeMapMarkers($scope.companies)
  )

  $http.get('/companies.json', {}).success((response) ->
    $scope.companies = response
    # $scope.visibleCompanies = response.slice(0, 10)
    if $scope.markerLayer
      $scope.markerLayer.features makeMapMarkers(response)
  ).error((error) ->
    # Jamie: Handle this
  )
])