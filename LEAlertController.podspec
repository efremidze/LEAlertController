#
# Be sure to run `pod lib lint LEAlertController.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "LEAlertController"
  s.version          = "0.1.0"
  s.summary          = "UIAlertController for both iOS 7 and 8"
  s.description      = "LEAlertController is a UIAlertController extension for iOS 7 support"
  s.homepage         = "https://github.com/efremidze/LEAlertController"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Lasha Efremidze" => "efremidzel@hotmail.com" }
  s.source           = { :git => "https://github.com/efremidze/LEAlertController.git", :tag => s.version.to_s }
  s.social_media_url = 'http://linkedin.com/in/efremidze'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'LEAlertController' => ['Pod/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
