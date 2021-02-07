require "uri"
require "net/http"
require "json"

def request(url,token = nil)
    url = URI("#{url}&api_key=#{token}")
    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true
    request = Net::HTTP::Get.new(url)
    response = https.request(request)
    return JSON.parse(response.read_body)
end

def buid_web_page(response_result)
    File.open('index.html', 'w') do |file|
        file.puts '<html>'
        file.puts '<head>'
        file.puts '</head>'
        file.puts '<body>'
        file.puts '<ul>'
        i = 0
        loop do
            file.puts "<li><img src='#{response_result['photos'][i]['img_src']}' width='200'></li>"
            if i == ((response_result['photos'].length) - 1)
                break
            end
            i += 1
        end
        file.puts '</ul>'
        file.puts '</body>'
        file.puts '</html>'
    end
end

def photos_count(response_result)
    camaras = []
    i = 0
    loop do
        camaras << response_result['photos'][i]['camera']['name']
        if i == ((response_result['photos'].length) - 1)
            break
        end
        i += 1
    end
    
    hash = camaras.reduce (Hash.new(0)) {|conteo, elemento| conteo[elemento]+=1; conteo}
    puts hash.class #con el punto class imprimo el objeto
end

nasa_array = request('https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?sol=1000', 'cTZ0aU4XJ0dqhUI01mbWxn4AcdOMo5YzSkzmztau')

puts buid_web_page(nasa_array)
puts photos_count(nasa_array)