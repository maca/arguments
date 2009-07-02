class Class
  
  def named_arguments_for *methods
    methods.each do |method|
      names   = Arguments.names self, method
      assigns = []
      
      names.each_with_index do |name, index|
        unless name.size == 1
          assigns << "#{ name.first } = opts.key?(:#{ name.first }) ? opts[:#{ name.first }] : #{ name.last }"
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

      self.module_eval <<-RUBY_EVAL
        def __new_#{ method } *args, &block
          opts = args.pop if args.last.kind_of? Hash
          #{ assigns.join("\n") }
          __original_#{ method } #{ names.collect{ |n| n.first }.join(', ') }, &block
        end
        
        alias __original_#{ method } #{ method }
        alias #{ method } __new_#{ method }
      RUBY_EVAL
    end
  end
  
end