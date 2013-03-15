@CompaniesCtrl = ['$scope', '$http', ($scope, $http) ->
  $http.get('/companies.json', {}).success((response) ->
    $scope.companies = response
  ).error((error) ->
    # Jamie: Handle this
  )
]