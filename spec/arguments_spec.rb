require "#{ File.dirname __FILE__ }/../lib/arguments"
require 'benchmark'

describe Arguments do

  before do
    Object.send(:remove_const, 'Klass') rescue nil
    load "#{ File.dirname __FILE__ }/klass.rb"
    load "#{ File.dirname __FILE__ }/module.rb"
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

  it "should work with methods that have no optionals" do
    Klass.send( :named_arguments_for, :go5 )
    @instance.go5(1, 2).should == [1,2]
    @instance.go5(1, :b => 3).should == [1,3]
    @instance.go5(:a => 4, :b => 5).should == [4, 5]
  end
 
  it "should work with class methods" do
    Klass.asr(0, 1, 2, :curve => 3).should == [0,1,2,3]
  end
  
  it "should work with class methods" do
    Klass.send( :named_arguments_for, :"Klass.class_method")
    Klass.class_method(:a => 1).should == 1
  end

  it "should work with class methods called like :self.method_name" do
    Klass.send( :named_arguments_for, :"self.class_method2")
    Klass.class_method2(:a => 1).should == 1
  end

  it "should work with class methods passed in by string instead of symboL" do
    Klass.send( :named_arguments_for, "self.class_method3")
    Klass.class_method3(:a => 1).should == 1
  end

  it "should not patch methods that accept no args" do
    # Arguments.should_not_receive(:names)
    Klass.send( :named_arguments_for, :no_args )
    lambda { @instance.no_args(1) }.should raise_error(ArgumentError)
    @instance.no_args.should be_nil
  end
  
  it "should not patch methods that use splatter op" do
    Klass.send( :named_arguments_for, :splatted )
    @instance.splatted(1, :args => 1).should == [1, {:args => 1}]

    Klass.send( :named_arguments_for, :splatted2 )
    @instance.splatted2(:a => 1, :"*args" => 3).should == []

    Klass.send( :named_arguments_for, :splatted3 )
    @instance.splatted3(:a => 1, :"*args" => 3).should == []
    @instance.splatted3(1, :b => 2, :args => 1).should == [{:b => 2, :args => 1}]

    Klass.send( :named_arguments_for, :splatted4 )
    @instance.splatted4(1, :b => 2, :args => 1).should == []

  end
  
  it "should patch methods with no optionals" do
    Klass.send( :named_arguments_for, :no_opts )
    lambda { @instance.no_opts(1,2, :a => 1)}.should raise_error(ArgumentError)
    @instance.no_opts(1,2, :c => 1).should == 1
  end
  
  it "should patch all methods" do
    Klass.send( :named_args )
  end
  
  it "should benchmark without hack" do
    puts Benchmark.measure {
      1_000.times do
        @instance.with_block( 1, :three => nil ){ :block }
      end
    }
  end
  
  it "should work with modules too" do
    TestMod.send( :named_arguments_for, :go)
    IncludesTestMod.new.go(:a => 1).should == 1
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
