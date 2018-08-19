require 'net/http'
require 'uri'

class Zapi

  attr_reader :uri, :response, :responder

  def initialize zapi_url: ENV['ZAPI_URI'], responder: nil
    @uri = URI.parse(zapi_url)
    @responder = responder || ZapiResponse
  end

  def request xml:
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    req = Net::HTTP::Post.new(uri.request_uri)
    req.body = xml

    @response = responder.new(raw_response: http.request(req))
#raise @response.raw_xml
    @response.data
  end

end
