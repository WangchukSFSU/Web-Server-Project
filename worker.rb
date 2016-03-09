require_relative 'request'
require_relative 'response'
require_relative 'resource'
require_relative 'response_factory'

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
               if(line == "\r\n")
                 break
               end
               #  puts line
               puts line.length
               puts "LINE: #{line}"
               request_string <<  line.chop
               request_string << "\n"
           end
       #  puts "Request received: " + request_string 

          request = Request.new(request_string)
          status = request.parse
          if(status != 0) 
            body = client.readpartial(request.headers.get("Content-Length").to_i)
            request.read_body(body)
          end
          puts request
#       rescue
#           if ! client.closed?
#           client.print ResponseFactory.create_response("400")
#           client.close
#           return
#           end
#       end

       resource = Resource.new(request.uri, @conf, @mimes,request.http_method)
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
