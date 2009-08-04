
module Arguments
  def self.names klass, method
    source, line = klass.instance_method( method ).source_location rescue klass.method( method ).source_location
    return [] unless source and line
    str = IO.readlines(source)[ line - 1 ]
    return [] if str.match(/\*\w+/)
    throw 'poor comma' + str if str  =~ /,\W*&/
    str.match(/def\s*\w+\s*\(?\s*([^)\n]*)/)[1] #This could look better
      .scan(/(\w+)(?:\s*=\s*([^,]+))|(\w+)/).map{ |e| e.compact  }.collect{|e2| e2[1].gsub!(/\W*\&.*/, '') if e2[1]; e2}
  end
end
