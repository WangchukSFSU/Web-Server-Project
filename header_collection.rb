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
end
