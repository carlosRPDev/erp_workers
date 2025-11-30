require_relative "lib/erp_workers/version"

Gem::Specification.new do |spec|
  spec.name        = "erp_workers"
  spec.version     = ErpWorkers::VERSION
  spec.authors     = [ "Carlos Rodriguez" ]
  spec.email       = [ "ucroxlive@gmail.com" ]
  spec.homepage    = "https://github.com/carlosRPDev/erp_workers"
  spec.summary     = "Workers management engine for the ERP system."
  spec.description = "Internal management of the workers engine."

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/carlosRPDev/erp_plus"
  spec.metadata["changelog_uri"] = "https://example.com/erp_workers/changelog"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", ">= 8.0.4"

  spec.add_dependency "view_component"
end
