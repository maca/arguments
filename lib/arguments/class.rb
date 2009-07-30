module NamedArgs
  def named_arguments_for *methods
    methods = instance_methods - Object.methods if methods.empty?
    
    methods.each do |meth|
      if(meth.to_s.include?('.'))
         # they may have passed in a parameter like :klass.method for a class method
         klass, meth = meth.to_s.split('.')
         klass = eval(klass) # from "Klass" to Klass
         klass = (class << klass; self; end)
         names = Arguments.names klass, meth
      else
        names  = Arguments.names self, meth
        klass = self
      end
      next if names.empty? || names.any?{|name| name[0] == :"*args"}
      
      assigns = []
      names.each_with_index do |name, index|
        unless name.size == 1
          # optionals
          assigns << <<-RUBY_EVAL
            #{ name.first } =
            if opts.key?(:#{ name.first })
              opts[:#{ name.first }]
            else
              args.size >= #{ index + 1 } ? args[#{ index }] : #{ name.last }
            end
          RUBY_EVAL
        else
          # requireds
          assigns << <<-RUBY_EVAL 
            begin
              #{ name.first } = opts.key?(:#{ name.first }) ? opts[:#{ name.first }] : args.fetch(#{ index })
            rescue 
              raise ArgumentError.new('passing `#{ name.first }` is required')
            end
          RUBY_EVAL
        end
      end

      klass.module_eval <<-RUBY_EVAL, __FILE__, __LINE__
        def __new_#{ meth } *args, &block
          opts = args.last.kind_of?( Hash ) ? args.pop : {}
          #{ assigns.join("\n") }
          __original_#{ meth } #{ names.collect{ |n| n.first }.join(', ') }, &block
        end
        
        alias __original_#{ meth } #{ meth }
        alias #{ meth } __new_#{ meth }
      RUBY_EVAL
    end
  end

  alias :named_args_for :named_arguments_for
  alias :named_args     :named_arguments_for
  
end

class Class; include NamedArgs; end
class Module; include NamedArgs; end
