# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{arguments}
  s.version = "0.6"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Macario Ortega"]
  s.date = %q{2010-01-17}
  s.description = %q{You don't have to wait until Ruby 2.0 to get (named|keyword) arguments support.
Arguments has been tested with Ruby 1.8.6 and ruby 1.9.1 and eventually will work with JRuby (if someone is interested in contributing, I guess is possible since merb-action-args works with JRuby)}
  s.email = ["macarui@gmail.com"]
  s.extra_rdoc_files = ["History.txt", "Manifest.txt"]
  s.files = ["History.txt", "Manifest.txt", "README.rdoc", "Rakefile", "arguments.gemspec", "lib/arguments.rb", "lib/arguments/class.rb", "lib/arguments/mri.rb", "lib/arguments/vm.rb", "spec/arguments_spec.rb", "spec/klass.rb", "spec/module.rb"]
  s.homepage = %q{http://github.com/maca/arguments}
  s.rdoc_options = ["--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{arguments}
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{You don't have to wait until Ruby 2.0 to get (named|keyword) arguments support}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<ruby_parser>, [">= 2.0.2"])
      s.add_runtime_dependency(%q<ParseTree>, [">= 3.0.3"])
      s.add_runtime_dependency(%q<ruby2ruby>, ["= 1.1.9"])
      s.add_development_dependency(%q<rubyforge>, [">= 2.0.3"])
      s.add_development_dependency(%q<gemcutter>, [">= 0.3.0"])
      s.add_development_dependency(%q<hoe>, [">= 2.5.0"])
    else
      s.add_dependency(%q<ruby_parser>, [">= 2.0.2"])
      s.add_dependency(%q<ParseTree>, [">= 3.0.3"])
      s.add_dependency(%q<ruby2ruby>, ["= 1.1.9"])
      s.add_dependency(%q<rubyforge>, [">= 2.0.3"])
      s.add_dependency(%q<gemcutter>, [">= 0.3.0"])
      s.add_dependency(%q<hoe>, [">= 2.5.0"])
    end
  else
    s.add_dependency(%q<ruby_parser>, [">= 2.0.2"])
    s.add_dependency(%q<ParseTree>, [">= 3.0.3"])
    s.add_dependency(%q<ruby2ruby>, ["= 1.1.9"])
    s.add_dependency(%q<rubyforge>, [">= 2.0.3"])
    s.add_dependency(%q<gemcutter>, [">= 0.3.0"])
    s.add_dependency(%q<hoe>, [">= 2.5.0"])
  end
end
