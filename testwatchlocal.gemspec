Gem::Specification.new do |s|
  s.name = %q{testwatchlocal}
  s.version = "0.0.1"
  s.date = %q{2011-09-02}
  s.authors = ["Neelima/Robert/Christopher"]
  s.email = %q{neelima.sriramula@wnco.com}
  s.summary = %q{test_watch watches your source code for code quality.}
  s.homepage = %q{http://www.southwest.com/}
  s.description = %q{test_watch watches your source code for code quality.}
  s.files = ["lib/testwatchlocal.rb", "lib/code_watch.rb", "lib/code_watch_local.rb", "lib/git_history.rb"]
  s.add_development_dependency "json"
  s.add_runtime_dependency "json"
end