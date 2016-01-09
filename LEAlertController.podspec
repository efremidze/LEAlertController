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
  s.version          = "0.1.7"
  s.summary          = "UIAlertController with iOS 7 support"
  s.description      = "LEAlertController is a UIAlertController extension for iOS 7 support"
  s.homepage         = "https://github.com/efremidze/LEAlertController"
  s.screenshots      = "https://github.com/efremidze/LEAlertController/raw/master/Screenshots/alert.png", "https://github.com/efremidze/LEAlertController/raw/master/Screenshots/actionsheet.png"
  s.license          = 'MIT'
  s.author           = { "Lasha Efremidze" => "efremidzel@hotmail.com" }
  s.source           = { :git => "https://github.com/efremidze/LEAlertController.git", :tag => s.version.to_s }
  s.social_media_url = 'http://linkedin.com/in/efremidze'
  s.platform         = :ios, '7.0'
  s.requires_arc     = true
  s.source_files     = 'LEAlertController/*'
end
