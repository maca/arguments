class Class
  def named_arguments_for *methods
    methods = instance_methods - Object.methods if methods.empty?
    
    methods.each do |meth|
      unbound = instance_method meth
      names   = Arguments.names self, meth
      
      next if names.empty? || names.inject(0){ |sum, pair| sum + pair.size } == names.size
      
      assigns = []
      names.each_with_index do |name, index|
        unless name.size == 1
          assigns << <<-RUBY_EVAL
            #{ name.first } =
            if opts.key?(:#{ name.first })
              opts[:#{ name.first }]
            else
              args.size >= #{ index + 1 } ? args[#{ index }] : #{ name.last }
            end
          RUBY_EVAL
        else
          assigns << <<-RUBY_EVAL 
            begin
              #{ name.first } = opts.key?(:#{ name.first }) ? opts[:#{ name.first }] : args.fetch(#{ index })
            rescue 
              raise ArgumentError.new('passing `#{ name.first }` is required')
            end
          RUBY_EVAL
        end
      end

      self.module_eval <<-RUBY_EVAL, __FILE__, __LINE__
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