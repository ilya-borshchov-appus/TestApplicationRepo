#
#  Be sure to run `pod spec lint AppusPageControl.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
  s.name         = "AppApp"
  s.version      = "0.0.1"
  s.summary      = "AppApp allow you to use customisable page control with many featues"
  s.homepage     = "http://appus.pro"
  s.license      = { :type => "Apache", :file => "LICENSE" }
  s.author             = { "Ilya Borshchov" => "ilya.borshchov@appus.me" }
  s.platform     = :ios
  s.ios.deployment_target = "9.0"
  s.source       = { :git => "https://github.com/ilya-borshchov-appus/TestApplicationRepo.git", :tag => "0.0.1" }

  s.source_files = "AppusApplications/**/*.{swift}"
  s.resources = "AppusApplications/**/*.{png,jpeg,jpg,storyboard,xib}"
  s.frameworks             = 'Foundation', 'UIKit'
	
  s.dependency "Alamofire"
  s.dependency "AlamofireImage"
  s.dependency "SwiftyJSON"
  s.requires_arc = true
end
