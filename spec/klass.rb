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


  def go5(a, b)
    [a, b] 
  end

  def asr attackTime = 3, sustainLevel = 2, releaseTime = 1, curve = 0
    [attackTime, sustainLevel, releaseTime, curve]
  end
  
  def no_args
  end

  def splatted *args
    args
  end

  def splatted2 a=1, *args
    args
  end

  def splatted3 a, *args
    args
  end
  
  def splatted4 a, b=1, *args
    args
  end

  def no_opts a, b, c
    c
  end
  
  class << self
    def asr attackTime = 3, sustainLevel = 2, releaseTime = 1, curve = 0
      [attackTime, sustainLevel, releaseTime, curve]
    end
    named_arguments_for :asr

    def class_method(a)
      a
    end

    def class_method2(a)
      a
    end
    
    def class_method3(a)
      a
    end
  end
  
  def == other
    self.class == other.class
  end
end
