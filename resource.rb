
  class Resource
    attr_reader :uri, :httpd_conf, :mimes

    def initialize(uri, httpd_conf, mimes)
      
      @uri = uri
      @conf = httpd_conf
      @mimes = mimes
    
    end

    def resolve
       modified_uri = ""
       
     if @conf.alias?(@uri)
      puts @conf.alias?(@uri)
       # if aliased?(@uri)
       
           alias1 = ""
           uri_alias = @conf.get_alias(@uri)
           
           puts "JJJJJ " + uri_alias
           modified_uri = uri_alias

           puts "URI "+ @uri

        #elsif script_aliased?
          #elsif @httpd_conf.alias?(@uri)
          # modified_uri = @httpd_conf.get_script_alias(@uri)    
          #puts @httpd_conf.get_script_alias(@uri)
          else
            modified_uri = @uri
        end


         resolved_path = @conf.document_root + modified_uri
         if ! File.file?(resolved_path)
          puts " resolved_path" + resolved_path
          puts " @conf.dir_index " + @conf.dir_index

              absolute_path = resolved_path + @conf.dir_index
              
            else
              
               absolute_path = resolved_path
           end

           absolute_path

    end

 
  



end