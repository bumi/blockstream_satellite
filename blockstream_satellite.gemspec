
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "blockstream_satellite/version"

Gem::Specification.new do |spec|
  spec.name          = "blockstream_satellite"
  spec.version       = BlockstreamSatellite::VERSION
  spec.authors       = ["Michael Bumann"]
  spec.email         = ["hello@michaelbumann.com"]

  spec.summary       = %q{API client for the Blockstream satellite}
  spec.description   = %q{API client to interact with the Blockstream satellite}
  spec.homepage      = "http://github.com/bumi/blockstream_satellite"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["homepage_uri"] = spec.homepage
    spec.metadata["source_code_uri"] = spec.homepage
    spec.metadata["changelog_uri"] = "http://github.com/bumi/blockstream_satellite/"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.17"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_dependency "faraday", "> 0.8"
  spec.add_dependency "faraday_middleware", ">0.12"
  spec.add_dependency "lnrpc", ">= 0.7.1"
  spec.add_dependency "activesupport", ">= 5.0.1"
end
