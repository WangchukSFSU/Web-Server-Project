require_relative 'config'

class HttpdConfig < Configure

  attr_reader :server_root,:document_root,:listen,:logfile,:script_alias,:alias,:dir_index
  attr_reader :httpd_config

   def initialize(file)
     @httpd_config = file
  end

  def load
   mmap = parse(@httpd_config)
   process_line(mmap)  
  end

   def process_line(mmap)
     puts "httpd parsed"
    mmap.each do |key,val|
       print key,val
       puts
    end
      @server_root = mmap["ServerRoot"][0]
      @document_root = mmap["DocumentRoot"][0]
      @listen = mmap["Listen"][0]
      @logfile = mmap["LogFile"][0]
      
      alias_array = mmap["Alias"] 
      @alias = Hash[*alias_array] 
      
      script_alias_array = mmap["ScriptAlias"]
      @script_alias = Hash[*script_alias_array]
     puts "values : ----"
     print "server root : " ,@server_root," doc root ",@document_root
     print "\n listen " , @listen," lofile ", @logfile
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

     def alias?(uri)
       @alias.has_key?(uri)
     end

     def get_alias(uri)
        @alias[uri]
      end

      def script_alias?(uri)
       @script_alias.has_key?(uri)
     end

     def get_script_alias(uri)
        @script_alias[uri]
      end
   end
