require 'rubygems'
gem 'ParseTree', '>= 3.0.3'
require 'parse_tree'

gem 'ruby2ruby', '= 1.1.9'
require 'ruby2ruby'

module Arguments
  def self.names klass, method
    args = ParseTree.translate( klass, method ).assoc(:scope).assoc(:block).assoc(:args)[1..-1]
    vals = args.pop[1..-1]

    args.collect do |arg|
      if val = vals.find{ |v| v[1] == arg }
        [arg, Ruby2Ruby.new.process(val.last)]
      else
        [arg]
      end
    end
  end
end
