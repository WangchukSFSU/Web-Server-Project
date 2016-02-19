require 'socket'
require_relative 'request'
require_relative 'response'

class WebServer
  attr_reader :options

  DEFAULT_PORT = 56789

  def initialize(options={})
    @options = options
  end

  def start
    response = ""
    loop do
      puts "Opening server socket to listen for connections"
      client = server.accept
#      client.read_nonblock(1024,response);
       while next_line_readable?(client)
        line = client.gets
        puts line.chop
      end

      #code to create a new request
      puts "Writing message"
      test_response = Response.new
      client.puts test_response

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
