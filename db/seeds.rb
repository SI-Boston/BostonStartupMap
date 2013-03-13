require 'open-uri' 
require 'json'

def get_boston_address(offices)
  if offices.count <= 1
    office = offices[0]
  else
    office = nil
    offices.each do |o|
      if o["state_code"] == "MA" || o["city"] == "Boston" || o["city"] == "Cambridge"
        office = o
        break
      end
    end
  end

  office
end

radius = 20

resp = JSON.parse(open("http://api.crunchbase.com/v/1/search.js?geo=Boston,MA&range=#{radius}&api_key=t3bycxvfhz2cp7avjyb322e7").read)
(1..((resp["total"] / 30)+1)).each do |page|
  begin
    startups = JSON.parse(open("http://api.crunchbase.com/v/1/search.js?geo=Boston,MA&range=#{radius}&api_key=t3bycxvfhz2cp7avjyb322e7&page=#{page}").read)
    startups["results"].each do |s|
      begin
        office = get_boston_address(s["offices"])
        Company.create!(
          name: s["name"],
          description: s["overview"],
          remote_image_url: s["image"].blank? ? nil : "http://crunchbase.com/#{s["image"]["available_sizes"][0][1]}",
          address: "#{office["address1"]}#{", " + office["address2"] if !office["address2"].blank?}",
          zip: office["zip_code"].to_i,
          latitude: office["latitude"],
          longitude: office["longitude"]
        )
      rescue => ex
      end
    end
  rescue => ex
  end
end