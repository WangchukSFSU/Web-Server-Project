require_relative 'config'

module Configuration
    class MimeTypes < Configure
       attr_reader :mime_type,:file_path
 
       def initialize(file)
         @file_path = file
         @mime_type = {}
       end
    
       def load
           mmap = parse(@file_path)
           mmap.each do |key,values|
             values.each do |val|
                @mime_type[val] = key
             end
          end 
  
      end
 
     def to_s
        puts "MIME "
        @mime_type.each do |k,v|
          print k,"  ",v
          puts
        end
     end
  
     def get_mime_type(extension)
       @mime_type[extension]
     end

  end
end

