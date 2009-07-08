class Class
  
  def named_arguments_for *methods
    methods.each do |method|
      names   = Arguments.names self, method
      assigns = []
      
      names.each_with_index do |name, index|
        unless name.size == 1
          # optionals
          assigns << "#{ name.first } = opts.key?(:#{ name.first }) ? opts[:#{ name.first }] : args.fetch(#{ index },#{ name.last })"
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

      self.module_eval <<-RUBY_EVAL, __FILE__, __LINE__
        def __new_#{ method } *args, &block
          opts = args.last.kind_of?( Hash ) ? args.pop : {}
          #{ assigns.join("\n") }
          __original_#{ method } #{ names.collect{ |n| n.first }.join(', ') }, &block
        end
        
        alias __original_#{ method } #{ method }
        alias #{ method } __new_#{ method }
      RUBY_EVAL
    end
  end
  alias :named_args_for :named_arguments_for
  
end
