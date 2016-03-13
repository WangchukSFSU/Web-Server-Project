require_relative 'config'

# parses httpd_config file
module Configuration
   class HttpdConfig < Configure

      attr_reader :server_root,:document_root,:listen,:logfile,:script_alias,
              :alias,:dir_index,:httpd_config

      def initialize(file)
         @httpd_config = file
       end

     # loads config file and store values in instance variables.
      def load
         mmap = parse(@httpd_config)
         process_line(mmap)  
      end

       def process_line(mmap)

           @server_root =  mmap["ServerRoot"][0]
           @document_root = mmap["DocumentRoot"][0]
           @listen = mmap["Listen"][0]
           @logfile = mmap["LogFile"][0]
           @dir_index = mmap["DirectoryIndex"][0]
           alias_array = mmap["Alias"] 
           @alias = Hash[*alias_array] 
           script_alias_array = mmap["ScriptAlias"]
           @script_alias = Hash[*script_alias_array]

       end

       # checks if provided URI is alias
       def alias?(uri)
          @alias.any? {|k,v| uri.include? k}
       end

      # checks if provided URI is script_alias
       def script_alias?(uri)
            @script_alias.any? {|k,v| uri.include?(k)}
       end

      # string representation of object
       def to_s
         puts "values : ----"
         print "server root : " ,@server_root," doc root ",@document_root
         print "\n listen " , @listen," lofile ",
                @logfile, " dir index ",@dir_index
         puts 
         print "alias "
         @alias.each do |k,v|
            print k," ",v
            puts
         end
         puts "script alias"
         @script_alias.each do |k,v|
            print k," ",v
            puts
         end
       end

  end
end
