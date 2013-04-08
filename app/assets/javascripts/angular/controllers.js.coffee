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

    elem.className = 'marker-image'
    elem.setAttribute('src', mrkr.properties.image)
    $scope.markers[mrkr.properties.id] = elem
    elem

  makeMapMarkers = (companies_json) ->
    markers = []
    for c in companies_json
      if c.latitude && c.longitude
        markers.push companyMarker(c)
    markers

  $scope.selectMarker = (id) ->
    $($scope.markers[id]).click()

  companyMarker = (c) ->
    {
      geometry: { coordinates: [c.longitude, c.latitude] }
      properties:
        id: c.id,
        type: 'company',
        title: c.name,
        description: c.address,
        image: c.marker
    }

  mapbox.auto('startup-map', 'chuka.map-rvhdpssw', (map, o) ->
    $scope.map = map
    $scope.markers = {}
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
    $scope.startups = _.where(response, {category: "Startup"})
    $scope.vcs = _.where(response, {category: "Venture Capitalist"})
    $scope.angels = _.where(response, {category: "Angel Investor"})
    $scope.accelerators = _.where(response, {category: "Accelerator/Incubator"})
    $scope.coworking = _.where(response, {category: "Co-working space"})
    $scope.hangouts = _.where(response, {category: "Hang-out spot"})
    $scope.events = _.where(response, {category: "Event"})
    if $scope.markerLayer
      $scope.markerLayer.features makeMapMarkers(response)
  ).error((error) ->
    # Jamie: Handle this
  )
])