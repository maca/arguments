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
  
  def asr attackTime = 3, sustainLevel = 2, releaseTime = 1, curve = 0
    [attackTime, sustainLevel, releaseTime, curve]
  end
  
  class << self
    def asr attackTime = 3, sustainLevel = 2, releaseTime = 1, curve = 0
      [attackTime, sustainLevel, releaseTime, curve]
    end
  named_arguments_for :asr
  end
  
  def == other
    self.class == other.class
  end
end