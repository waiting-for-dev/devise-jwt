# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'devise/jwt/version'

Gem::Specification.new do |spec|
  spec.name          = "devise-jwt"
  spec.version       = Devise::JWT::VERSION
  spec.authors       = ["Marc Busqué"]
  spec.email         = ["marc@lamarciana.com"]

  spec.summary       = %q{JWT authentication for devise}
  spec.description   = %q{JWT authentication for devise with configurable token revocation strategies}
  spec.homepage      = "https://github.com/waiting-for-dev/devise-jwt"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'devise', '~> 4.0'

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "pry-byebug", "~> 3.4"
  # Needed to test the rails fixture application
  spec.add_development_dependency 'rails', '~> 5.0'
  spec.add_development_dependency 'sqlite3', '~> 1.3'
  spec.add_development_dependency 'rspec-rails', '~> 3.5'
  # Test reporting
  spec.add_development_dependency 'simplecov', '~> 0.13'
  spec.add_development_dependency 'codeclimate-test-reporter', '~> 1.0'
end
