require 'rubygems'
require 'rake'

begin
  gem 'jeweler', '~> 1.4'
  require 'jeweler'

  Jeweler::Tasks.new do |gem|
    gem.name        = 'rr-sweatshop'
    gem.summary     = 'Plugin for building pseudo random models representing restful resources'
    gem.description = gem.summary
    gem.email       = 'mat [a] miehle [d] org'
    gem.homepage    = 'http://github.com/matinahat/%s' % gem.name
    gem.authors     = [ 'Mat Miehle' ]
    gem.files       = FileList["[A-Z]*", "lib/**/*"]

    # gem.rubyforge_project = ''

    gem.add_dependency 'randexp', '~> 0.1.5'

    gem.add_development_dependency 'rspec',          '~> 1.3'
  end

  Jeweler::GemcutterTasks.new

  FileList['tasks/**/*.rake'].each { |task| import task }
rescue LoadError
  puts 'Jeweler (or a dependency) not available. Install it with: gem install jeweler'
end
