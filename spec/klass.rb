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
  
  def with_block2 one, two = 2, three = 3, &action
    [one, two, three, action.call]
  end

  def asr attackTime = 3, sustainLevel = 2, releaseTime = 1, curve = 0
    [attackTime, sustainLevel, releaseTime, curve]
  end
  
  def no_args
  end

  def splatted *args
    args
  end

  def splatted2 a=1, *rest
    [a, rest]
  end

  def splatted3 a, *rest
    [a, rest]
  end
  
  def splatted4 a, b=1, *rest
    [a, b, rest]
  end

  def no_opts a, b, c
    [a, b, c]
  end
  
  class << self
    def asr attackTime = 3, sustainLevel = 2, releaseTime = 1, curve = 0
      [attackTime, sustainLevel, releaseTime, curve]
    end
    
    def k_method a = 1, b = 2, c = 3, d = 4
      [a, b, c, d]
    end
  end
  
  def == other
    self.class == other.class
  end
end
