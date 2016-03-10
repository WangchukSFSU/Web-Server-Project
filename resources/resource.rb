module WebServer
  class Resource

   attr_reader :uri, :conf, :mimes, :resolved_uri,
               :uri_without_doc_root,:script_flag,:http_method

    def initialize(uri, httpd_conf, mimes,http_method)
      
      @uri = uri.clone
      @conf = httpd_conf
      @mimes = mimes
      @http_method = http_method
    end

    # resolve aliases and script aliases 
    def resolve

      puts "in resolve " + @uri
      uri_to_be_resolved = @uri.clone
     
 
     if script? uri_to_be_resolved
         full_path = replace_script_aliases(uri_to_be_resolved)
     elsif alias? uri_to_be_resolved
         full_path = replace_aliases(uri_to_be_resolved)
     else
         full_path = File.join(@conf.document_root,uri_to_be_resolved)
         @uri_without_doc_root = uri_to_be_resolved.clone
         puts "URI without doc root" +  @uri_without_doc_root
     end

     if (! File.file? full_path) &&
          ( @http_method.casecmp("PUT") != 0) &&  (! script? @uri)
          full_path = File.join(full_path,get_directory_index)
     end 
     
      @resolved_uri = full_path.clone
      full_path 
  end

 
  def script?(uri)
    @conf.script_alias?(uri)
  end

  def alias?(uri)
   @conf.alias?(uri)
  end
 
  def replace_aliases(path)
      new_path = path.clone
       @conf.alias.each do |aliases,alias_path|
         new_path.sub!(aliases,alias_path) 
       end
      new_path
  end

  def replace_script_aliases(path)
      new_path = path.clone
      @conf.script_alias.each do |s_aliases,script_alias_path|
        new_path.sub!(s_aliases, script_alias_path)
      end
      new_path
  end

  def get_alias(uri)
    @conf.get_alias(uri)
  end

  def get_document_root
    @conf.document_root
  end

  def get_directory_index
   @conf.dir_index
  end

 end
end
