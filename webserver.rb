require 'socket'
require_relative 'httpd_config'
require_relative 'worker'
require_relative 'logger'
require_relative 'mime_types'


class WebServer
  attr_reader :options

  DEFAULT_PORT = 56789
attr_accessor :request, :httpd_conf, :mimes

  def initialize(options={})
     @httpd_conf = HttpdConfig.new('config/httpd.conf')
     @mimes = MimeTypes.new('config/mime.types')
     @options = options
     @params = {}
  end

  def start

   @httpd_conf.load    
   @mimes.load
   logger = Logger.new(@httpd_conf.logfile)   
    Thread.abort_on_exception=true
    loop do
         puts "Opening server socket to listen for connections"

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

webserver_test = WebServer.new
webserver_test.start
