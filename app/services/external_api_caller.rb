require 'net/http'
require 'uri'
class ExternalApiCaller
    def self.call_api(url)
        url = URI(url)
        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        request = Net::HTTP::Get.new(url)
        response = http.request(request)        
        return response.read_body
    end
end