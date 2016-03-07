
      require 'base64'
      require 'digest'

class HtaccessChecker

  attr_reader :path,:request,:doc_root

  def initialize(path, request,document_root)
     @path = path
     @request = request
     @doc_root = document_root
  end
  
  def protected?
     flag = false
     appended_path = ""
     @path.split(File::SEPARATOR).map do |subdir|
         appended_path.concat(subdir=="" ? File::SEPARATOR : File::SEPARATOR + subdir)
         puts "checking path " + @doc_root + appended_path + "/.htaccess"
         if(File.exists?(@doc_root + appended_path + "/.htaccess")) 
         file_path = @doc_root << appended_path << "/.htaccess"    
            flag = true
            break
         end
     end
    flag
  end

  def can_authorized?
     request.headers.has_key?("Authorization")
  end

  def authorized?
     flag = false
     parse_file(file_path)
     encryptheader = request.headers["Authorization"].split(" ")[2]
     decryptheader = Base64.decode64(encryptstring)
     key,value = decryptstring.split(':')
       if htpasswd.has_key?(key)
        if htpasswd[key] == Digest::SHA1.base64digest(value)

    flag = true
  end

  end
end


      def parse_file(file_path)
     file_lines = IO.readlines(file_path)
      file_content = Hash.new
file_lines.each do |line|
  key, value = line.split(" ")
  file_content[key.strip] = value.strip
end
file_content
end




def htpasswd
  htpasswdlist = Hash.new
  htpasswd = IO.readlines(file_content[AuthUserFile])
  htpasswd.each do |line|
  key, value = line.split(':')
  value.gsub(/{SHA}/,'' )
  htpasswdlist[key.strip] = value.strip
end

htpasswdlist
end






end
