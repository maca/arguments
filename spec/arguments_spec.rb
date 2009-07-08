require "#{ File.dirname __FILE__ }/../lib/arguments"
require 'benchmark'

describe Arguments do

  before do
    Object.send(:remove_const, 'Klass') rescue nil
    load "#{ File.dirname __FILE__ }/klass.rb"
    @instance = Klass.new
  end
  
  it "should respond to named_arguments" do
    Klass.send( :named_arguments_for, :three )
  end
  
  it "should not respond to named_arguments" do
    lambda { Klass.new.send( :named_arguments_for ) }.should raise_error( NoMethodError )
  end
  
  it "should get argument names with literals" do
    Arguments.names( Klass, :two ).collect{ |a, b| [a.to_sym, b].compact }.
      should == [[:one], [:two, "2"], [:three, "Klass.new"]]
  end
  
  it "shouldn't break defaults" do
    @instance.two(1).should == [1, 2, Klass.new]
  end
  
  it "should allow passing named argument" do
    Klass.send( :named_arguments_for, :two )
    @instance.two(1, :three => 3).should == [1, 2, 3]
  end
  
  it "should raise ArgumentError if not passing required params" do
    Klass.send( :named_arguments_for, :two )
    lambda { @instance.two( :three => 3 ) }.should raise_error(ArgumentError)
  end
  
  it "should override passed value with hash" do
    Klass.send( :named_arguments_for, :two )
    @instance.two( :one => nil ).should == [nil, 2, Klass.new]
  end
  
  it "should allow overriding with nil" do
    Klass.send( :named_arguments_for, :two )
    @instance.two( 1, :three => nil ).should == [1, 2, nil]
  end
  
  it "should pass block" do
    Klass.send( :named_arguments_for, :with_block )
    @instance.with_block( 1, :three => nil, :two => 'something' ){ :block }.should == [1, 'something', nil, :block]
  end
  
  it "should override defaults on standard passing" do
    Klass.send( :named_arguments_for, :asr )
    @instance.asr(0, 1, 2, :curve => 3).should == [0,1,2,3]
  end
  
  it "should work with class methods" do
    Klass.asr(0, 1, 2, :curve => 3).should == [0,1,2,3]
  end
  
  it "should benchmark without hack" do
    puts Benchmark.measure {
      1_000.times do
        @instance.with_block( 1, :three => nil ){ :block }
      end
    }
  end
  
  it "should benchmark with hack" do
    puts Benchmark.measure {
      Klass.send( :named_arguments_for, :with_block )
    }
    puts Benchmark.measure {
      1_000.times do
        @instance.with_block( 1, :three => nil ){ :block }
      end
    }
  end
end