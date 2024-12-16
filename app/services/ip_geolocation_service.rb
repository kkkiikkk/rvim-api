class IpGeolocationService < ApplicationService
  require 'net/http'
  require 'json'

  GEOLOCATION_API_URL = "http://ip-api.com/json/".freeze

  def call(ip)
    return nil if ip.blank? || ip == '127.0.0.1'

    url = "#{GEOLOCATION_API_URL}#{ip}"
    response = Net::HTTP.get(URI(url))
    data = JSON.parse(response)
    data['countryCode'] rescue nil
  end
end