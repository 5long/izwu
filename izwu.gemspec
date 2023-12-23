Gem::Specification.new do |s|
  s.name = "izwu"
  s.version = "0.1.1"
  s.license = "MIT"
  s.authors = ["Whyme Lyu"]
  s.email = "callme5long@gmail.com"
  s.homepage = "https://github.com/5long/izwu"
  s.summary = %{Automating "Is it worth upgrading my OS?"}

  s.required_ruby_version = ">= 3.0"
  s.add_development_dependency 'minitest'
  s.add_development_dependency 'rake'

  s.files = %w(izwu.gemspec) + Dir["*.md", "bin/*", "lib/**/*.rb"]
  s.executables = %w(izwu)
  s.require_paths = %w(lib)
end
