
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
    flag
  end

end
