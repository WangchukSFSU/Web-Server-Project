
  class Resource
   attr_reader :uri, :conf, :mimes, :resolved_uri,
               :uri_without_doc_root,:script_flag

    def initialize(uri, httpd_conf, mimes)
      
      @uri = uri.clone
      @conf = httpd_conf
      @mimes = mimes
    
    end

    def resolve

      puts "in resolve " + @uri
      uri_to_be_checked = @uri
     
      file = false
      if @uri.include?(".")
          file_name = File.basename @uri
          uri_to_be_checked = File.dirname @uri
          uri_to_be_checked.concat "/"
          puts "  filename ",file_name,"uri ",uri_to_be_checked 
      #    uri_to_be_checked = @uri.split('.')[-1] 
          file = true
      end
 
     if script? uri_to_be_checked
         modified_uri = get_script_alias(uri_to_be_checked)
     elsif alias? uri_to_be_checked
         modified_uri = get_alias(uri_to_be_checked)
     else
         modified_uri = uri_to_be_checked
     end

      @uri_without_doc_root = modified_uri.clone

#     modified_uri.insert(0,get_document_root)
     modified_uri.prepend(get_document_root)

  #  puts "file : " + file
     if (file == true)
       modified_uri.concat file_name
     else
        modified_uri.concat get_directory_index
     end
     @resolved_uri = modified_uri.clone
    
      puts "URI without doc root" +  @uri_without_doc_root
     modified_uri
 
  end

  def script?(uri)
    @conf.script_alias?(uri)
  end

 def alias?(uri)
   @conf.alias?(uri)
  end
 
  def get_script_alias(uri)
    @conf.get_script_alias(uri)
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
