require 'rubygems'
require "#{ dir = File.dirname __FILE__ }/../lib/arguments"
require 'benchmark'


# TODO: Refactor specs for clarity and better coverage
describe Arguments do

  before do
    Object.send(:remove_const, 'Klass') rescue nil
    load "#{ dir }/klass.rb"
    @instance = Klass.new
  end

  it "should not respond to named_arguments" do
    lambda { Klass.new.send( :named_arguments_for ) }.should raise_error( NoMethodError )
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
    error =
    begin 
      @instance.two( :three => 3 )
    rescue ArgumentError => e
      e
    end
    error.to_s.should == "passing `one` is required"
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
  
  it "should patch methods that accept proc as argument" do
    Klass.send( :named_arguments_for, :with_block2 )
    @instance.with_block2(1, :three => nil, :two => 'something'){ :block }.should == [1, 'something', nil, :block]
  end
  
  it "should override defaults on standard passing" do
    Klass.send( :named_arguments_for, :asr )
    @instance.asr(0, 1, :curve => 3).should == [0, 1, 1, 3]
  end

  it "should work with class methods" do
    (class << Klass; self; end).send( :named_arguments_for, :k_method )
    Klass.k_method(:d => :d).should == [1, 2, 3, :d]
  end
  
  it "should override defaults on standard passing" do
    Klass.send( :named_arguments_for, 'self.k_method' )
    Klass.k_method(:d => :d).should == [1, 2, 3, :d]
  end
  
  it "should not use options if all arguments are passed" do
    Klass.send( :named_arguments_for, :two )
    @instance.two( 1, 2, :three => nil ).should == [1, 2, {:three => nil}]
  end
  
  it "should raise ArgumentError if passing a not recoginized keyword" do
    Klass.send( :named_arguments_for, :two )
    error =
    begin 
      @instance.two( 1, :four => nil )
    rescue ArgumentError => e
      e
    end
    error.to_s.should == "`four` is not a recognized argument keyword"
  end
  
  it "should raise ArgumentError if passing recoginized keywords" do
    Klass.send( :named_arguments_for, :two )
    error =
    begin 
      @instance.two( 1, :four => nil, :five => nil  )
    rescue ArgumentError => e
      e
    end
    error.to_s.should == "`four, five` are not recognized argument keywords"
  end
  
  it "should not patch methods that accept no args" do
    Klass.send( :named_arguments_for, :no_args )
    lambda { @instance.no_args(1) }.should raise_error(ArgumentError)
    @instance.no_args.should be_nil
  end
  
  it "should not patch methods that use splatter op" do
    Klass.send( :named_arguments_for, :splatted )
    @instance.splatted(1, :args => 1).should == [1, {:args => 1}]
  
    Klass.send( :named_arguments_for, :splatted2 )
    @instance.splatted2(:a => 1, :"*rest" => 3).should == [{:a => 1, :'*rest' => 3}, []]
  
    Klass.send( :named_arguments_for, :splatted3 )
    @instance.splatted3(:a => 1, :"*args" => 3).should == [{:a => 1, :"*args" => 3}, []]
    @instance.splatted3(1, :b => 2, :args => 1).should == [1, [{:b => 2, :args => 1}]]
  
    Klass.send( :named_arguments_for, :splatted4 )
    @instance.splatted4(1, :b => 2, :args => 1).should == [1, {:b => 2, :args => 1}, []]
  end
  
  it "should not patch methods with no optionals" do
    Klass.send( :named_arguments_for, :no_opts )
    @instance.method(:no_opts).arity.should == 3
  end
  
  it "should patch all methods" do
    Klass.send( :named_args )
    @instance.two(1, :three => 3).should == [1, 2, 3]
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