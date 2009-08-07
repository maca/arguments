gem 'ruby_parser', '>= 2.0.2'
require 'ruby_parser'

module Arguments
  class PermissiveRubyParser < RubyParser
    def on_error t, val, vstack
      @rescue = vstack.first
    end

    def parse str, file = "(string)"
      super || @rescue
    end
  end
  
  def self.ast_for_method klass, method
    source, line = klass.instance_method(method).source_location
    str = IO.readlines( source )[ (line-1)..-1 ].join
    ast = PermissiveRubyParser.new.parse( str )
    ast.assoc( :defn ) or ast
  end
end