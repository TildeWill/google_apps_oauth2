Gem::Specification.new do |spec|
  spec.name = 'google_apps_oauth2'
  spec.version = '0.1'
  spec.license = "MIT"
  spec.summary = 'Google Apps APIs using OAuth2'
  spec.description = 'Library for interfacing with Google Apps Domain and Application APIs via OAuth2'
  spec.authors = ['Will Read']
  spec.files = Dir.glob(File.join('**', 'lib', '**', '*.rb'))
  spec.homepage = 'https://github.com/TildeWill/google_apps'

  spec.add_dependency('libxml-ruby', '>= 2.2.2')
  spec.add_dependency('httparty')

  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'webmock'

  spec.files = `git ls-files`.split("\n")
  spec.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
end
