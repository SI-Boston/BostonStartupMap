@startupApp = angular.module("StartupMap", ['infinite-scroll'], ['$locationProvider', ($locationProvider, infiniteScroll) ->
  $locationProvider.html5Mode(true)
])