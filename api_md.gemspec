$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "api_md/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "api_md"
  s.version     = ApiMd::VERSION
  s.authors     = ["Pawit Khid-arn"]
  s.email       = ["khidarn.pawit@gmail.com"]
  s.homepage    = "TODO"
  s.summary     = "POST API and comments to markdown document"
  s.description = "ApiMd is a gem for generating markdown files for controllers using the route file and inline comment-like syntax in controllers"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_development_dependency "sqlite3"
end
