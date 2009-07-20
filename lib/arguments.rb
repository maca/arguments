$:.unshift(File.dirname(__FILE__)) unless $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'arguments/class'



RUBY_VERSION.to_f >= 1.9 ? require( 'arguments/vm' ) : require( 'arguments/mri' )

module Arguments
  VERSION = '0.4.7'
end