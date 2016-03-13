# stores headers of request and response in hash as key value pairs.

module WebServer
  class HeaderCollections

     def initialize
       @headers = {}
     end

     # add a new header
     def add(key,value)
        @headers[key]=value
     end

     # fetch the header based on key
     def get(key)
        @headers[key]
     end

    # get all the headers
     def to_s
        @headers.map do |key,value|
        "#{key}: #{value}"
        end.join("\n")
     end
 
     # check if header is present
     def has_key?(key)
         @headers.has_key?(key)
     end

    # convert all headers to uppercase and append HTTP_to them.
    # Used for CGI script handling 
     def uppercase
        upcase_headers = Hash.new
        @headers.keys.each do |key|
            upcase_headers[key] = "HTTP_" + key.upcase
        end
        mapped = @headers.map {|k, v| [upcase_headers[k], v] }.to_h
     end

   end
end
