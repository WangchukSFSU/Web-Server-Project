class Worker
 attr_reader :client,:conf,:mime_types,:logger

  def initialize(client,conf,mime,logger)
   @client = client
   @logger = logger
   @conf = conf
   @mime_types = mime
  end

  def handle_request
       request_string = ""
   
#    begin

#       begin
          while next_line_readable?(client)
               line = client.gets
               #  puts line
               puts "LINE: #{line}"
               request_string <<  line.chop
               request_string << "\n"
           end
       #  puts "Request received: " + request_string 

          request = Request.new(request_string)
          request.parse
          puts request
#       rescue
#           if ! client.closed?
#           client.print ResponseFactory.create_response("400")
#           client.close
#           return
#           end
#       end

       resource = Resource.new(request.uri, @conf, @mimes)
       absolute_path = resource.resolve
       puts "------------ absolute path --------" + absolute_path
       #code to create a new request

       response = ResponseFactory.create(request,resource,
                                        @conf.document_root,@mime_types)
       @logger.write(request,response)
       puts response
       client.print response
       client.close
 #begin
 #  rescue
  #    if ! client.closed?
  #      client.print ResponseFactory.create_response("500")
  #      client.close
  #    end
  # end
#end
 
 end

 # fd be nil if next line cannot be read
    def next_line_readable?(socket)
      readfds, writefds, exceptfds = select([socket], nil, nil, 0.1)
      readfds
    end


end
