Pod::Spec.new do |s|
  s.name             = "Compass"
  s.summary          = "Compass helps you setup a central navigation system for your iOS application."
  s.version          = "6.0.0"
  s.homepage         = "https://github.com/hyperoslo/Compass"
  s.license          = 'MIT'
  s.author           = { "Hyper Interaktiv AS" => "ios@hyper.no" }
  s.source           = { :git => "https://github.com/hyperoslo/Compass.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/hyperoslo'

  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.10'

  s.requires_arc = true

  s.source_files = 'Sources/**/*'
  s.frameworks = 'Foundation'

  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '3.0' }
end
