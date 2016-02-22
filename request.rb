class Request
  attr_reader :http
  attr_reader :headers
  attr_reader :body
  attr_reader :test
  attr_reader :test2
  attr_reader :parsed

  def initialize
    @test =<<PARAGRAPH
GET /hello.htm HTTP/1.1
User-Agent: Mozilla/4.0 (compatible; MSIE5.01; Windows NT)
Host: www.tutorialspoint.com
Accept-Language: en-us
Accept-Encoding: gzip, deflate
Connection: Keep-Alive
PARAGRAPH
    @test2 =<<PARAGRAPH
POST /cgi-bin/process.cgi HTTP/1.1
User-Agent: Mozilla/4.0 (compatible; MSIE5.01; Windows NT)
Host: www.tutorialspoint.com
Content-Type: application/x-www-form-urlencoded
Content-Length: length
Accept-Language: en-us
Accept-Encoding: gzip, deflate
Connection: Keep-Alive

licenseID=string&content=string&/paramsXML=string
PARAGRAPH
    @headers = Array.new
    @body = Array.new

  end

  def parsetest
    @parsed = @test2.split("\n")
    @http = @parsed[0]
    index = 0
    unparsed_headers = Array.new
    parsed_headers = Array.new
    1.upto(@parsed.length - 1) { |i| 
      if(@parsed[i].length == 0)
	puts "FOUND"
        index = i + 1
        break
      end
    unparsed_headers.push @parsed[i]
    }
    if(index != 0)
      index.upto(@parsed.length - 1) { |i|
        @body.push @parsed[i]
      }
    end
    parsed_headers = unparsed_headers.map{|x| x.split(":")}
    parsed_headers.each_index{ |x| parsed_headers[x][1] = parsed_headers[x][1].strip}
    @headers = Hash[parsed_headers.map{|key, value| [key, value]}]
  end      


  def parse(http_request)
    @parsed = http_request.split("\n")
    @http = @parsed[0]
    index = 0
    unparsed_headers = Array.new
    parsed_headers = Array.new
    1.upto(@parsed.length - 1) { |i| 
      if(@parsed[i].length == 0)
	puts "FOUND"
        index = i + 1
        break
      end
    unparsed_headers.push @parsed[i]
    }
    if(index != 0)
      index.upto(@parsed.length - 1) { |i|
        @body.push @parsed[i]
      }
    end
    parsed_headers = unparsed_headers.map{|x| x.split(":")}
    parsed_headers.each_index{ |x| parsed_headers[x][1] = parsed_headers[x][1].strip}
    @headers = Hash[parsed_headers.map{|key, value| [key, value]}]
  end
end
