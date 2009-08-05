gem 'ParseTree', '>= 3.0.3'
require 'parse_tree'

module Arguments
  def self.ast_for_method klass, method
    ParseTree.translate( klass, method ).assoc(:scope).assoc(:block)
  end
end

