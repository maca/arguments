require 'rubygems'
gem 'ParseTree', '>= 3.0.3'
require 'parse_tree'

gem 'ruby2ruby', '= 1.1.9'
require 'ruby2ruby'

module Arguments
  def self.names klass, method
    begin 
      args = ParseTree.translate( klass, method ).assoc(:scope).assoc(:block).assoc(:args)[1..-1]
    rescue NoMethodError # binary method will fail on one of those assoc's
      return nil
    end
    if args.last.instance_of? Array
      vals = args.pop[1..-1]
    else
      # if it has no optionals
      vals = []
    end

    args.collect do |arg|
      if val = vals.find{ |v| v[1] == arg }
        [arg, Ruby2Ruby.new.process(val.last)]
      else
        [arg]
      end
    end
  end
end
