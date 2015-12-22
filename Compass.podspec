Pod::Spec.new do |s|
  s.name             = "Compass"
  s.summary          = "Compass helps you setup a central navigation system for your iOS application."
  s.version          = "1.2.3"
  s.homepage         = "https://github.com/hyperoslo/Compass"
  s.license          = 'MIT'
  s.author           = { "Hyper Interaktiv AS" => "ios@hyper.no" }
  s.source           = { :git => "https://github.com/hyperoslo/Compass.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/hyperoslo'
  s.platform     = :ios, '8.0'
  s.requires_arc = true
  s.source_files = 'Source/**/*'
end
