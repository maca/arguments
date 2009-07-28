require 'rubygems'
gem 'ParseTree', '>= 3.0.3'
require 'parse_tree'

gem 'ruby2ruby', '= 1.1.9'
require 'ruby2ruby'

module Arguments
  def self.names klass, method
    args = ParseTree.translate( klass, method ).assoc(:scope).assoc(:block).assoc(:args)
    args = args[1..-1]
    return [] if args.empty?
    if args.last.instance_of? Array
      vals = args.pop[1..-1]
    else
      # if it has no optionals then vals is empty
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
