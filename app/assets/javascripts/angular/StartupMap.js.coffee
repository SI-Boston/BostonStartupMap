angular.module("StartupMap", [], ['$locationProvider', ($locationProvider) ->
  $locationProvider.html5Mode(true)
])