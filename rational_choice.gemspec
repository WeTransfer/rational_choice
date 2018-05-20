require_relative 'lib/rational_choice'

Gem::Specification.new do |s|
  s.name = 'rational_choice'
  s.version = RationalChoice::VERSION

  s.required_rubygems_version = Gem::Requirement.new('>= 0') if s.respond_to? :required_rubygems_version=
  s.require_paths = ['lib']
  s.authors = ['Julik Tarkhanov']
  s.date = Time.now.utc.strftime('%Y-%m-%d')
  s.description = 'Fuzzy logic gate'
  s.email = 'me@julik.nl'
  s.extra_rdoc_files = ['LICENSE.txt', 'README.md']
  s.files = `git ls-files -z`.split("\x0")
  s.homepage = 'https://github.com/wetransfer/rational_choice'
  s.licenses = ['MIT']
  s.rubygems_version = '2.2.2'
  s.summary = 'Makes life-concerning choices based on an informed coin toss'

  s.specification_version = 4
  s.add_development_dependency 'yard', '>= 0'
  s.add_development_dependency 'rspec', '~> 3.4.0'
  s.add_development_dependency 'rake', '~> 10'
  s.add_development_dependency 'bundler', '~> 1.0'
  s.add_development_dependency 'wetransfer_style', '0.5.0'
end
