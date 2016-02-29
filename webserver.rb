require 'socket'
require_relative 'request'
require_relative 'response'
require_relative 'header_collection'
class WebServer
  attr_reader :options

  DEFAULT_PORT = 56789

  def initialize(options={})
    @options = options
  end

  def start
     
    loop do
      puts "Opening server socket to listen for connections"
      client = server.accept
   
        request_string = ""
    #    request_string = client.read
    #    while line = client.gets
     #     request_string <<  line.chop << "\n"
     #    end


       while next_line_readable?(client)
          line = client.gets
         #  puts line
          request_string <<  line.chop 
          request_string << "\n"
      end
      puts "Request received: " + request_string;      
      request = Request.new(request_string);
      request.parse
      puts request
      puts "Writing message"
      
      #create a response
      hc = HeaderCollections.new()
      hc.add("Content-Type","text/html")
      hc.add("Content-Length","0")
      hc.add("Content-Language","en")
#                "WWW-Authenticate"  =>  "Basic"
      response = Response.new(:headers => hc,
                              :response_code => "200",
                              :http_version => "HTTP/1/1",
                              :body => "<html><body>My response</body></html>")   
#      test_response = Response.new
      client.print response

      client.close
    end
  end

  def server
    @server ||= TCPServer.open(options.fetch(:port, DEFAULT_PORT))
  end

   # fd be nil if next line cannot be read
    def next_line_readable?(socket)
      readfds, writefds, exceptfds = select([socket], nil, nil, 0.1)
      readfds 
    end
end

webserver_test = WebServer.new
webserver_test.start
