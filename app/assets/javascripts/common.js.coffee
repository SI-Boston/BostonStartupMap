jQuery ->
  handleSizing = () ->
    console.log("resized")
    h = $(window).height()
    topBar = $('.top-bar').height()
    search = $('.row.map form').height()
    section = $('.row.map .title').height()
    credits = $('.credits').height()
    $('#startup-map').height(h - topBar - credits)
    $('#map-select .content').height(h - (topBar + search) - (section * 7) - credits)

  $(window).resize ->
    handleSizing()

  handleSizing()  