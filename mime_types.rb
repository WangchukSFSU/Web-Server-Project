require_relative 'config'

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
  
     puts "MIME "
     @mime_type.each do |k,v|
        print k,"  ",v
        puts
     end
   end
 
end

