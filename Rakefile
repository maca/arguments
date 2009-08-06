require 'rubygems'
gem 'hoe', '>= 2.1.0'
require 'hoe'
require 'fileutils'
require './lib/arguments'

Hoe.plugin :newgem
# Hoe.plugin :website
# Hoe.plugin :cucumberfeatures

# Generate all the Rake tasks
# Run 'rake -T' to see list of generated tasks (from gem root directory)
$hoe = Hoe.spec 'arguments' do
  self.developer 'Macario Ortega', 'macarui@gmail.com'
  self.rubyforge_name = self.name # TODO this is default value
  self.extra_deps = [
    ['ruby_parser', '>= 2.0.2'],
    ['ParseTree',   '>= 3.0.3'],
    ['ruby2ruby',    '= 1.1.9']
  ]
end

require 'newgem/tasks'
Dir['tasks/**/*.rake'].each { |t| load t }

# TODO - want other tests/tasks run by default? Add them to the list
# remove_task :default
# task :default => [:spec, :features]
