require 'socket'
require_relative 'resources/config/httpd_config'
require_relative 'resources/worker'
require_relative 'resources/logger'
require_relative 'resources/config/mime_types'

module WebServer

  class WebServer
      attr_reader :options

      DEFAULT_PORT = 56789
      attr_accessor :request, :httpd_conf, :mimes

    def initialize(options={})
        @httpd_conf = Configuration::HttpdConfig.new('config/httpd.conf')
        @mimes = Configuration::MimeTypes.new('config/mime.types')
        @options = options
        @params = {}
    end

    def start

     # load config files
       @httpd_conf.load    
       @mimes.load
     # initialze logger 
       logger = Logger.new(@httpd_conf.logfile)   
       Thread.abort_on_exception=true
       
       loop do
           puts "Opening server socket to listen for connections"

        # handle incoming request
         Thread.start(server.accept) do |client|
           worker = Worker.new(client,@httpd_conf,@mimes,logger)     
           worker.handle_request
         end
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
end


webserver_test = WebServer::WebServer.new
webserver_test.start
