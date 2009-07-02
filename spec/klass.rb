class Klass
  def three one = 1, two = 2, three = 3
    [one, two, three]
  end
  
  def two one, two = 2, three = Klass.new
    [one, two, three]
  end
  
  def with_block one, two = 2, three = 3
    [one, two, three, yield]
  end
  
  def klass_method one = 1, two = 2, three = 3
  end
  
  def == other
    self.class == other.class
  end
end