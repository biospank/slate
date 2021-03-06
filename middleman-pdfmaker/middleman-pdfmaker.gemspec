# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "middleman-pdfmaker"
  s.version     = "0.0.1"
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Fabio Petrucci"]
  s.email       = ["fabio.petrucci@gmail.com"]
  # s.homepage    = "http://example.com"
  s.summary     = %q{Middleman extension to generate pdf}
  s.description = %q{Middleman extension to generate pdf}
  s.license = "MIT"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  # s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # The version of middleman-core your extension depends on
  s.add_runtime_dependency("middleman-core", [">= 4.1.10"])

  # Additional dependencies
  s.add_runtime_dependency("pdfkit", "~> 0.8.2")
end
