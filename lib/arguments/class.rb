class Class
  def named_arguments_for *methods
    methods = instance_methods - Object.methods if methods.empty?
        
    methods.each do |meth|
      meth    = meth.to_s
      klass   = meth.sub!(/^self./, '') ? (class << self; self; end) : self
      names   = Arguments.names klass, meth
      next if names.empty? or names.inject(false) { |bol, pair| bol || /^\*/ === pair.first.to_s }
      assigns = []
      names.pop if /^&/ === names[-1][0].to_s
      
      names.each_with_index do |name, index|
        unless name.size == 1
          assigns << <<-RUBY_EVAL
            #{ name.first } =
            if opts.key? :#{ name.first }
              opts.delete :#{ name.first }
            else
              args.size >= #{ index + 1 } ? args[#{ index }] : #{ name.last }
            end
          RUBY_EVAL
        else
          assigns << <<-RUBY_EVAL 
            begin
              #{ name.first } = opts.key?(:#{ name.first }) ? opts.delete(:#{ name.first }) : args.fetch(#{ index })
            rescue 
              raise ArgumentError.new('passing `#{ name.first }` is required')
            end
          RUBY_EVAL
        end
      end

      klass.module_eval <<-RUBY_EVAL, __FILE__, __LINE__
        def __#{ meth }_with_keyword_arguments *args, &block
          opts = args.last.kind_of?( Hash ) && args.size < #{ names.size } ? args.pop : {}
          #{ assigns.join("\n") }
          unless opts.empty?
            raise ArgumentError.new("`\#{ opts.keys.join(', ') }` \#{ opts.size == 1 ? 'is not a recognized argument keyword' : 'are not recognized argument keywords' }") 
          end
          __original_#{ meth } #{ names.collect{ |n| n.first }.join(', ') }, &block
        end
        
        alias __original_#{ meth } #{ meth }
        alias #{ meth } __#{ meth }_with_keyword_arguments
      RUBY_EVAL
    end
  end
  alias :named_args_for :named_arguments_for
  alias :named_args     :named_arguments_for
end