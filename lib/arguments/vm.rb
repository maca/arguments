
module Arguments
  def self.names klass, method
    source, line = klass.instance_method( method ).source_location rescue klass.method( method ).source_location
    return [] unless source and line
    str = IO.readlines(source)[ line - 1 ]
    return [] if str.match(/\*\w+/)
    str.match(/def\s*\w+\s*\(?\s*([^)\n]*)/)[1] #This could look better
      .scan(/(\w+)(?:\s*=\s*([^,]+))|(\w+)/).map{ |e| e.compact  }
  end
end
