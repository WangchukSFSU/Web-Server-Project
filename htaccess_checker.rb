
class HtaccessChecker

  attr_reader :path,:request

  def initialize(path, request)
     @path = path
     @request = request
  end
  
  def protected?
     flag = false
     appended_path = ""
     @path.split(File::SEPARATOR).map do |subdir|
         appended_path.concat(subdir=="" ? File::SEPARATOR : File::SEPARATOR + subdir)
         if(File.exists?(appended_path + "/.htaccess"))      
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
