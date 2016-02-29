class Configure

   def parse(filepath)
      lines = IO.readlines(filepath)
      mmap = {}

      lines.select do |line|
          line.length !=0 && line[0] != "#"
      end.map do |line|
          values = line.split(" ")
           key = values.shift
           if mmap.has_key?(key)
              values.each do |value|
                  mmap[key] << value
              end 
           else
               mmap[key] = values
            end
      end   
   mmap 
  end
end
