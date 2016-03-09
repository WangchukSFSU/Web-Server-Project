class HeaderCollections

   def initialize
    @headers = {}
  end

  def add(key,value)
  @headers[key]=value
  end

  def get(key)
   @headers[key]
  end

  def to_s
  @headers.map do |key,value|
    "#{key}: #{value}"
  end.join("\n")
  end
 
 def has_key?(key)
     @headers.has_key?(key)
   end

  def uppercase
    upcase_headers = Hash.new
    @headers.keys.each do |key|
        upcase_headers[key] = "HTTP_" + key.upcase
    end
   mapped = @headers.map {|k, v| [upcase_headers[k], v] }.to_h
  end

end
