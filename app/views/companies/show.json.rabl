object @company

attributes :id, :name, :url, :description, :address, :zip, :latitude, :longitude, :twitter_handle, :facebook_handle, :category

node(:marker) do |c|
  case c.category
  when "Startup"
  "/assets/map_markers/startups.png"
  when "Accelerator/Incubator"
  "/assets/map_markers/incubators-accelerators.png"
  when "Venture Capitalist"
  "/assets/map_markers/vcs.png"
  when "Angel Investor"
  "/assets/map_markers/angels.png"
  when "Co-working space"
  "/assets/map_markers/co-working.png"
  when "Hang-out spot"
  "/assets/map_markers/hang-spots.png"
  when "Event"
  "/assets/map_markers/events.png"
  else
  "/assets/map_markers/startups.png"
  end
end