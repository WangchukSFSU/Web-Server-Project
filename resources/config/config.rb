module Configuration
   class Configure

     def parse(filepath)
        lines = IO.readlines(filepath)
         mmap = {}

         lines.select do |line|
            line.length !=0 && line[0] != "#"
          end.map do |line|
             values = line.split(" ")
             key = values.shift
             key = trim key
             if ! mmap.has_key?(key)
                 mmap[key] = []
             end
             values.each do |value|
                  value = trim value
                  mmap[key] << value
             end 
          end   
       mmap 
     end
  
     def trim(string)
       if string.to_s.empty?
         return string
       end
       string =  string.chomp("\"")
       if string[0,1] == "\""
         string.slice!(0)
       end
       string
    end

  end
end
